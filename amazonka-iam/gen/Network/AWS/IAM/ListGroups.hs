{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}

{-# OPTIONS_GHC -fno-warn-unused-binds   #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.IAM.ListGroups
-- Copyright   : (c) 2013-2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Lists the groups that have the specified path prefix.
--
-- You can paginate the results using the @MaxItems@ and @Marker@
-- parameters.
--
-- <http://docs.aws.amazon.com/IAM/latest/APIReference/API_ListGroups.html>
module Network.AWS.IAM.ListGroups
    (
    -- * Request
      ListGroups
    -- ** Request constructor
    , listGroups
    -- ** Request lenses
    , lgrqPathPrefix
    , lgrqMaxItems
    , lgrqMarker

    -- * Response
    , ListGroupsResponse
    -- ** Response constructor
    , listGroupsResponse
    -- ** Response lenses
    , lgrsMarker
    , lgrsIsTruncated
    , lgrsStatus
    , lgrsGroups
    ) where

import           Network.AWS.IAM.Types
import           Network.AWS.Pager
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response

-- | /See:/ 'listGroups' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'lgrqPathPrefix'
--
-- * 'lgrqMaxItems'
--
-- * 'lgrqMarker'
data ListGroups = ListGroups'
    { _lgrqPathPrefix :: !(Maybe Text)
    , _lgrqMaxItems   :: !(Maybe Nat)
    , _lgrqMarker     :: !(Maybe Text)
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'ListGroups' smart constructor.
listGroups :: ListGroups
listGroups =
    ListGroups'
    { _lgrqPathPrefix = Nothing
    , _lgrqMaxItems = Nothing
    , _lgrqMarker = Nothing
    }

-- | The path prefix for filtering the results. For example, the prefix
-- @\/division_abc\/subdivision_xyz\/@ gets all groups whose path starts
-- with @\/division_abc\/subdivision_xyz\/@.
--
-- This parameter is optional. If it is not included, it defaults to a
-- slash (\/), listing all groups.
lgrqPathPrefix :: Lens' ListGroups (Maybe Text)
lgrqPathPrefix = lens _lgrqPathPrefix (\ s a -> s{_lgrqPathPrefix = a});

-- | Use this only when paginating results to indicate the maximum number of
-- items you want in the response. If there are additional items beyond the
-- maximum you specify, the @IsTruncated@ response element is @true@.
--
-- This parameter is optional. If you do not include it, it defaults to
-- 100.
lgrqMaxItems :: Lens' ListGroups (Maybe Natural)
lgrqMaxItems = lens _lgrqMaxItems (\ s a -> s{_lgrqMaxItems = a}) . mapping _Nat;

-- | Use this parameter only when paginating results and only after you have
-- received a response where the results are truncated. Set it to the value
-- of the @Marker@ element in the response you just received.
lgrqMarker :: Lens' ListGroups (Maybe Text)
lgrqMarker = lens _lgrqMarker (\ s a -> s{_lgrqMarker = a});

instance AWSPager ListGroups where
        page rq rs
          | stop (rs ^. lgrsIsTruncated) = Nothing
          | isNothing (rs ^. lgrsMarker) = Nothing
          | otherwise =
            Just $ rq & lgrqMarker .~ rs ^. lgrsMarker

instance AWSRequest ListGroups where
        type Sv ListGroups = IAM
        type Rs ListGroups = ListGroupsResponse
        request = post
        response
          = receiveXMLWrapper "ListGroupsResult"
              (\ s h x ->
                 ListGroupsResponse' <$>
                   (x .@? "Marker") <*> (x .@? "IsTruncated") <*>
                     (pure (fromEnum s))
                     <*>
                     (x .@? "Groups" .!@ mempty >>=
                        parseXMLList "member"))

instance ToHeaders ListGroups where
        toHeaders = const mempty

instance ToPath ListGroups where
        toPath = const "/"

instance ToQuery ListGroups where
        toQuery ListGroups'{..}
          = mconcat
              ["Action" =: ("ListGroups" :: ByteString),
               "Version" =: ("2010-05-08" :: ByteString),
               "PathPrefix" =: _lgrqPathPrefix,
               "MaxItems" =: _lgrqMaxItems, "Marker" =: _lgrqMarker]

-- | Contains the response to a successful ListGroups request.
--
-- /See:/ 'listGroupsResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'lgrsMarker'
--
-- * 'lgrsIsTruncated'
--
-- * 'lgrsStatus'
--
-- * 'lgrsGroups'
data ListGroupsResponse = ListGroupsResponse'
    { _lgrsMarker      :: !(Maybe Text)
    , _lgrsIsTruncated :: !(Maybe Bool)
    , _lgrsStatus      :: !Int
    , _lgrsGroups      :: ![Group]
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'ListGroupsResponse' smart constructor.
listGroupsResponse :: Int -> ListGroupsResponse
listGroupsResponse pStatus_ =
    ListGroupsResponse'
    { _lgrsMarker = Nothing
    , _lgrsIsTruncated = Nothing
    , _lgrsStatus = pStatus_
    , _lgrsGroups = mempty
    }

-- | When @IsTruncated@ is @true@, this element is present and contains the
-- value to use for the @Marker@ parameter in a subsequent pagination
-- request.
lgrsMarker :: Lens' ListGroupsResponse (Maybe Text)
lgrsMarker = lens _lgrsMarker (\ s a -> s{_lgrsMarker = a});

-- | A flag that indicates whether there are more items to return. If your
-- results were truncated, you can make a subsequent pagination request
-- using the @Marker@ request parameter to retrieve more items.
lgrsIsTruncated :: Lens' ListGroupsResponse (Maybe Bool)
lgrsIsTruncated = lens _lgrsIsTruncated (\ s a -> s{_lgrsIsTruncated = a});

-- | FIXME: Undocumented member.
lgrsStatus :: Lens' ListGroupsResponse Int
lgrsStatus = lens _lgrsStatus (\ s a -> s{_lgrsStatus = a});

-- | A list of groups.
lgrsGroups :: Lens' ListGroupsResponse [Group]
lgrsGroups = lens _lgrsGroups (\ s a -> s{_lgrsGroups = a});
