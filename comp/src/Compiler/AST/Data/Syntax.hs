{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE MultiWayIf        #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TupleSections     #-}
{-# LANGUAGE ViewPatterns      #-}

-- Module      : Compiler.AST.Data.Syntax
-- Copyright   : (c) 2013-2015 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

module Compiler.AST.Data.Syntax where

import           Compiler.AST.Data.Field
import           Compiler.AST.Data.Instance
import           Compiler.AST.TypeOf
import           Compiler.Formatting
import           Compiler.Protocol
import           Compiler.Text
import           Compiler.Types
import           Control.Comonad.Cofree
import           Control.Error
import           Control.Lens                 hiding (iso, mapping, op)
import qualified Data.Foldable                as Fold
import           Data.Function                ((&))
import qualified Data.HashMap.Strict          as Map
import           Data.List                    (nub)
import           Data.Monoid
import           Data.Text                    (Text)
import qualified Data.Text                    as Text
import qualified Language.Haskell.Exts        as Exts
import           Language.Haskell.Exts.Build  hiding (pvar, var)
import           Language.Haskell.Exts.SrcLoc (noLoc)
import           Language.Haskell.Exts.Syntax hiding (Int, List, Lit, Var)

ctorSig :: Timestamp -> Id -> [Field] -> Decl
ctorSig ts n = TypeSig noLoc [n ^. smartCtorId . to ident]
    . Fold.foldr' TyFun (n ^. typeId . to tycon)
    . map (external ts)
    . filter (^. fieldRequired)

ctorDecl :: Id -> [Field] -> Decl
ctorDecl n fs = sfun noLoc name ps (UnGuardedRhs rhs) noBinds
  where
    name :: Name
    name = n ^. smartCtorId . to ident

    ps :: [Name]
    ps = map (view fieldParam) (filter (view fieldRequired) fs)

    rhs :: Exp
    rhs | null fs   = var (n ^. ctorId)
        | otherwise = RecConstr (n ^. ctorId . to unqual) (map fieldUpdate fs)

fieldUpdate :: Field -> FieldUpdate
fieldUpdate f = FieldUpdate (f ^. fieldAccessor . to unqual) set'
  where
    set' | opt, f ^. fieldMonoid    = var "mempty"
         | opt                      = var "Nothing"
         | Just v <- iso (typeOf f) = infixApp v "#" p
         | otherwise                = p

    opt = not (f ^. fieldRequired)

    p = Exts.Var (UnQual (f ^. fieldParam))

lensSig :: Timestamp -> TType -> Field -> Decl
lensSig ts t f = TypeSig noLoc [ident (f ^. fieldLens)] $
    TyApp (TyApp (tycon "Lens'")
                 (signature ts t)) (external ts f)

lensDecl :: Field -> Decl
lensDecl f = sfun noLoc (ident l) [] (UnGuardedRhs rhs) noBinds
  where
    l = f ^. fieldLens
    a = f ^. fieldAccessor

    rhs = mapping (typeOf f) $
        app (app (var "lens") (var a))
            (paren (lamE noLoc [pvar "s", pvar "a"]
                   (RecUpdate (var "s") [FieldUpdate (unqual a) (var "a")])))

dataDecl :: Id -> [QualConDecl] -> [Derive] -> Decl
dataDecl n fs cs = DataDecl noLoc arity [] (ident (n ^. typeId)) [] fs ds
  where
    arity = case fs of
        [QualConDecl _ _ _ (RecDecl _ [_])] -> NewType
        _                                   -> DataType

    ds = map ((,[]) . UnQual . Ident . drop 1 . show) cs

conDecl :: Text -> QualConDecl
conDecl n = QualConDecl noLoc [] [] (ConDecl (ident n) [])

recDecl :: Timestamp -> Id -> [Field] -> QualConDecl
recDecl _  n [] = conDecl (n ^. ctorId)
recDecl ts n fs = QualConDecl noLoc [] [] $
    RecDecl (ident (n ^. ctorId)) (map g fs)
  where
    g f = ([f ^. fieldAccessor . to ident], internal ts f)

requestD :: HasMetadata a f
         => a
         -> HTTP Identity
         -> (Id, [Inst])
         -> (Solved, Id, [Field])
         -> Decl
requestD m h (a, as) (s, b, bs) = instD "AWSRequest" a
    [ assocTyD a "Sv" (m ^. serviceAbbrev)
    , assocTyD a "Rs" (b ^. typeId)
    , funD "request"  (requestF h as)
    , funD "response" (responseE (m ^. protocol) h s b bs)
    ]

responseE :: Protocol -> HTTP Identity -> Solved -> Id -> [Field] -> Exp
responseE p h s n fs = app (responseF p h fs) bdy
  where
    bdy :: Exp
    bdy | null fs    = n ^. ctorId . to var
        | isShared s = lam parseAll
        | otherwise  = lam . ctorE n $ map parseField fs

    lam :: Exp -> Exp
    lam = lamE noLoc [pvar "s", pvar "h", pvar "x"]

    parseField :: Field -> Exp
    parseField x = case x ^. fieldLocation of
        Just Headers        -> parseHeadersE p x
        Just Header         -> parseHeadersE p x
        Just StatusCode     -> app (var "pure") (var "s")
        Just Body    | body -> app (var "pure") (var "x")
        Nothing      | body -> app (var "pure") (var "x")
        _                   -> parseProto x

    parseProto :: Field -> Exp
    parseProto = case p of
        JSON     -> parseJSONE p
        RestJSON -> parseJSONE p
        _        -> parseXMLE  p

    parseAll :: Exp
    parseAll = flip app (var "x") $
        case p of
            JSON     -> var "parseJSON"
            RestJSON -> var "parseJSON"
            _        -> var "parseXML"

    body = any (view fieldStream) fs

instanceD :: Protocol -> Id -> Inst -> Decl
instanceD p n = \case
    FromXML   fs -> fromXMLD   p n fs
    FromJSON  fs -> fromJSOND  p n fs
    ToElement f  -> toElementD p n f
    ToXML     fs -> toXMLD     p n fs
    ToJSON    fs -> toJSOND    p n fs
    ToHeaders es -> toHeadersD p n es
    ToPath    es -> toPathD      n es
    ToQuery   es -> toQueryD   p n es
    ToBody    f  -> toBodyD      n f

fromXMLD, fromJSOND :: Protocol -> Id -> [Field] -> Decl
fromXMLD  p n = decodeD "FromXML"  n "parseXML"  (ctorE n) . map (parseXMLE  p)
fromJSOND p n = decodeD "FromJSON" n "parseJSON" (ctorE n) . map (parseJSONE p)

toElementD :: Protocol -> Id -> Field -> Decl
toElementD p n = instD1 "ToElement" n . funD "toElement" . toElementE p

toXMLD, toJSOND :: Protocol -> Id -> [Field] -> Decl
toXMLD  p n = encodeD "ToXML"  n "toXML"  mconcatE . map (toXMLE p)
toJSOND p n = encodeD "ToJSON" n "toJSON" listE . map (toJSONE p)

toHeadersD :: Protocol -> Id -> [Either (Text, Text) Field] -> Decl
toHeadersD p n = instD1 "ToHeaders" n
    . wildcardD n "toHeaders" (mconcatE . map (toHeadersE p))

toQueryD :: Protocol -> Id -> [Either (Text, Maybe Text) Field] -> Decl
toQueryD p n = instD1 "ToQuery" n
    . wildcardD n "toQuery" (mconcatE . map (toQueryE p))

toPathD :: Id -> [Either Text Field] -> Decl
toPathD n = instD1 "ToPath" n . \case
    [Left t] -> funD "toPath" . app (var "const") $ str t
    es       -> wildcardD n "toPath" (mconcatE . map toPathE) es

toBodyD :: Id -> Field -> Decl
toBodyD n f = instD "ToBody" n [funD "toBody" (toBodyE f)]

instD1 :: Text -> Id -> InstDecl -> Decl
instD1 c n = instD c n . (:[])

instD :: Text -> Id -> [InstDecl] -> Decl
instD c n = InstDecl noLoc Nothing [] [] (unqual c) [n ^. typeId . to tycon]

funD :: Text -> Exp -> InstDecl
funD f = InsDecl . patBind noLoc (pvar f)

funArgsD :: Text -> [Text] -> Exp -> InstDecl
funArgsD f as e = InsDecl $
    sfun noLoc (ident f) (map ident as) (UnGuardedRhs e) noBinds

wildcardD :: Id -> Text -> ([Either a b] -> Exp) -> [Either a b] -> InstDecl
wildcardD n f g = \case
    []                        -> constMemptyD f
    es | not (any isRight es) -> funD f $ app (var "const") (g es)
       | otherwise            -> InsDecl (FunBind [match rec  es])
  where
    match p es = Match noLoc (ident f) [p] Nothing (UnGuardedRhs (g es)) noBinds

    ctor = PApp (n ^. ctorId . to unqual) []
    rec  = PRec (n ^. ctorId . to unqual) [PFieldWildcard]

assocTyD :: Id -> Text -> Text -> InstDecl
assocTyD n x y = InsType noLoc (TyApp (tycon x) (n ^. typeId . to tycon)) (tycon y)

decodeD :: Text -> Id -> Text -> ([a] -> Exp) -> [a] -> Decl
decodeD c n f dec = instD1 c n . \case
    [] -> funD f . app (var "const") $ dec []
    es -> funArgsD f ["x"] (dec es)

encodeD :: Text -> Id -> Text -> ([a] -> Exp) -> [a] -> Decl
encodeD c n f enc = instD c n . (:[]) . \case
    [] -> constMemptyD f
    es -> wildcardD n f (enc . map (either id id)) (map Right es)

constMemptyD :: Text -> InstDecl
constMemptyD f = funArgsD f [] $ app (var "const") (var "mempty")

ctorE :: Id -> [Exp] -> Exp
ctorE n = seqE (n ^. ctorId . to var)

mconcatE :: [Exp] -> Exp
mconcatE = app (var "mconcat") . listE

seqE :: Exp -> [Exp] -> Exp
seqE l []     = app (var "pure") l
seqE l (r:rs) = infixApp l "<$>" (infixE r "<*>" rs)

infixE :: Exp -> QOp -> [Exp] -> Exp
infixE l _ []     = l
infixE l o (r:rs) = infixE (infixApp l o r) o rs

parseXMLE, parseJSONE, parseHeadersE :: Protocol -> Field -> Exp
parseXMLE     = decodeE (Dec ".@" ".@?" ".!@" (var "x"))
parseJSONE    = decodeE (Dec ".:" ".:?" ".!=" (var "x"))
parseHeadersE = decodeE (Dec ".#" ".#?" ".!#" (var "h"))

toXMLE, toJSONE :: Protocol -> Field -> Exp
toXMLE  = encodeE (Enc "@=" "@@=")
toJSONE = encodeE (Enc ".=" ".=")

toElementE :: Protocol -> Field -> Exp
toElementE p f = appFun (var "mkElement")
    [ str name
    , var "."
    , var (f ^. fieldAccessor)
    ]
  where
    name | Just ns <- f ^. fieldNamespace = "{" <> ns <> "}" <> n
         | otherwise                      = n

    n = memberName p Input (f ^. fieldId) (f ^. fieldRef)

toHeadersE :: Protocol -> Either (Text, Text) Field -> Exp
toHeadersE p = either pair (encodeE (Enc "=#" "=##") p)
  where
    pair (k, v) = infixApp (str k) "=#" (impliesE (str v) (var ""))

toQueryE :: Protocol -> Either (Text, Maybe Text) Field -> Exp
toQueryE p = either pair (encodeE (Enc "=:" "=:") p)
  where
    pair (k, Nothing) = str k
    pair (k, Just v)  = infixApp (str k) "=:" (impliesE (str v) (var "ByteString"))

toPathE :: Either Text Field -> Exp
toPathE = either str (app (var "toText") . var . view fieldAccessor)

toBodyE :: Field -> Exp
toBodyE f = var (f ^. fieldAccessor)

impliesE :: Exp -> Exp -> Exp
impliesE x y = paren (infixApp x "::" y)

data Dec = Dec
    { decodeOp      :: QOp
    , decodeMaybeOp :: QOp
    , decodeDefOp   :: QOp
    , decodeVar     :: Exp
    }

decodeE :: Dec -> Protocol -> Field -> Exp
decodeE o p f = go (f ^. fieldRef . refAnn . to unwrap)
  where
    go = \case
        Map  m                 -> decodeMapE  o p f m
        List l                 -> decodeListE o p f l
        _ | f ^. fieldRequired -> infixApp x (decodeOp      o) n
          | otherwise          -> infixApp x (decodeMaybeOp o) n

    n = str $ memberName p Output (f ^. fieldId) (f ^. fieldRef)
    x = decodeVar o

decodeMapE o p f m = case p of
    RestJSON -> decodeDefaultE o n
    JSON     -> decodeDefaultE o n
    _        -> appFun (var "parseXMLMap") [maybeStrE mx, str e, str k, str v, decodeVar o]
  where
    (mx, e, k, v) = mapNames p Output (f ^. fieldId) (f ^. fieldRef) m

    n = memberName p Output (f ^. fieldId) (f ^. fieldRef)

-- FIXME: need to deal with result wrappers

decodeListE o p f l = case p of
    RestJSON -> decodeDefaultE o n
    JSON     -> decodeDefaultE o n
    _        -> appFun (var fun) [maybeStrE mx, str i, decodeVar o]
  where
    fun | TList1 _ <- typeOf f = "parseXMLList1"
        | otherwise            = "parseXMLList"

    (mx, i) = listNames p Output (f ^. fieldId) (f ^. fieldRef) l

    n = memberName p Output (f ^. fieldId) (f ^. fieldRef)

decodeDefaultE o n = infixApp (decodeMaybeE o n) (decodeDefOp o) (var "mempty")

decodeMaybeE o n = infixApp (decodeVar o) (decodeMaybeOp o) (var n)

maybeStrE :: Maybe Text -> Exp
maybeStrE = maybe (var "Nothing") (paren . app (var "Just") . str)

       -- list l Nothing  = parse n
    -- list l (Just i) = paren $
    --     infixApp (infixApp x
    --                        (decodeMaybeOp o)
    --                        (infixApp n
    --                                  (decodeDefOp o)
    --                                  (var "mempty")))
    --              ">>="
    --              (parse i)

    -- parse = app (var ("parse" <> protocolSuffix p <> fromMaybe mempty name))

    -- name | fieldList1 f = Just "NonEmpty"
    --      | fieldList  f = Just "List"
    --      | fieldMap   f = Just "Map"
    --      | otherwise    = Nothing

    -- x = var (decodeVar o)

-- memberNames :: Protocol -> Direction -> Field -> (Exp, Maybe Exp)
-- memberNames p d f =
--     ( str  $  memberName p d (f ^. fieldId) (f ^. fieldRef)
--     , str <$> item
--     )
--   where
--     item = case unwrap (f ^. fieldRef . refAnn) of
--         List l -> listItemName p d l
--         Map  m
--         _      -> Nothing

data Enc = Enc
    { encodeOp     :: QOp
    , encodeListOp :: QOp
    }

encodeE :: Enc -> Protocol -> Field -> Exp
encodeE o p f
-- FIXME:
--    | Just i <- m  = infixApp n (encodeOp     o) (infixApp i (encodeListOp o) v) --
    -- | fieldList1 f = infixApp n (encodeListOp o) v
    -- | fieldList  f = infixApp n (encodeListOp o) v
--    | fieldMap   f = infixApp n (encodeOp c) v
    | otherwise    = infixApp n (encodeOp     o) v
  where
    n = str $ memberName p Input (f ^. fieldId) (f ^. fieldRef)

    v = var (f ^. fieldAccessor)

requestF :: HTTP Identity -> [Inst] -> Exp
requestF h is = var v
  where
    v = mappend (methodToText (h ^. method))
      . fromMaybe mempty
      . listToMaybe
      $ mapMaybe f is

    f = \case
        ToBody    {} -> Just "Body"
        ToJSON    {} -> Just "JSON"
        ToElement {} -> Just "XML"
        _            -> Nothing

-- FIXME: take method into account for responses, such as HEAD etc, particuarly
-- when the body might be totally empty.
responseF :: Protocol -> HTTP Identity -> [Field] -> Exp
responseF p h fs = var ("receive" <> f)
  where
    f | null fs                   = "Null"
      | any (view fieldStream) fs = "Body"
      | otherwise                 = protocolSuffix p

signature :: Timestamp -> TType -> Type
signature ts = directed False ts Nothing

internal, external :: Timestamp -> Field -> Type
internal ts f = directed True  ts (f ^. fieldDirection) f
external ts f = directed False ts (f ^. fieldDirection) f

directed :: TypeOf a => Bool -> Timestamp -> Maybe Direction -> a -> Type
directed i ts d (typeOf -> t) = case t of
    TType      x _    -> tycon x
    TLit       x      -> literal i ts x
    TNatural          -> tycon nat
    TStream           -> tycon stream
    TSensitive x      -> sensitive (go x)
    TMaybe     x      -> TyApp  (tycon "Maybe")     (go x)
    TList      x      -> TyList (go x)
    TList1     x      -> TyApp  (tycon "NonEmpty")  (go x)
    TMap       k v    -> TyApp  (TyApp (tycon "HashMap") (go k)) (go v)
  where
    go = directed i ts d

    nat | i         = "Nat"
        | otherwise = "Natural"

    sensitive
        | i         = TyApp (tycon "Sensitive")
        | otherwise = id

    stream = case d of
        Nothing     -> "Stream"
        Just Input  -> "RqBody"
        Just Output -> "RsBody"

mapping :: TType -> Exp -> Exp
mapping t e = infixE e "." (go t)
  where
    go = \case
        TSensitive x -> var "_Sensitive" : go x
        TMaybe     x -> coerce (go x)
        x            -> maybeToList (iso x)

    coerce (x:xs) = app (var "mapping") x : xs
    coerce []     = []

iso :: TType -> Maybe Exp
iso = \case
    TLit Time    -> Just (var "_Time")
    TNatural     -> Just (var "_Nat")
    TSensitive _ -> Just (var "_Sensitive")
    _            -> Nothing

literal :: Bool -> Timestamp -> Lit -> Type
literal i ts = tycon . \case
    Int              -> "Int"
    Long             -> "Integer"
    Double           -> "Double"
    Text             -> "Text"
    Blob             -> "Base64"
    Bool             -> "Bool"
    Time | i         -> tsToText ts
         | otherwise -> "UTCTime"

tycon :: Text -> Type
tycon = TyCon . unqual

con :: Text -> Exp
con = Con . unqual

str :: Text -> Exp
str = Exts.Lit . String . Text.unpack

pvar :: Text -> Pat
pvar = Exts.pvar . ident

var :: Text -> Exp
var = Exts.var . ident

-- qop :: Text -> QOp
-- qop = Exts.op . Exts.sym . Text.unpack

param :: Int -> Name
param = Ident . mappend "p" . show

unqual :: Text -> QName
unqual = UnQual . ident

ident :: Text -> Name
ident = Ident . Text.unpack
