{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}

{-# OPTIONS_GHC -fno-warn-unused-binds   #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.CodeCommit.UpdateRepositoryDescription
-- Copyright   : (c) 2013-2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Sets or changes the comment or description for a repository.
--
-- The description field for a repository accepts all HTML characters and
-- all valid Unicode characters. Applications that do not HTML-encode the
-- description and display it in a web page could expose users to
-- potentially malicious code. Make sure that you HTML-encode the
-- description field in any application that uses this API to display the
-- repository description on a web page.
--
-- <http://docs.aws.amazon.com/codecommit/latest/APIReference/API_UpdateRepositoryDescription.html>
module Network.AWS.CodeCommit.UpdateRepositoryDescription
    (
    -- * Request
      UpdateRepositoryDescription
    -- ** Request constructor
    , updateRepositoryDescription
    -- ** Request lenses
    , urdrqRepositoryDescription
    , urdrqRepositoryName

    -- * Response
    , UpdateRepositoryDescriptionResponse
    -- ** Response constructor
    , updateRepositoryDescriptionResponse
    ) where

import           Network.AWS.CodeCommit.Types
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response

-- | Represents the input of an update repository description operation.
--
-- /See:/ 'updateRepositoryDescription' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'urdrqRepositoryDescription'
--
-- * 'urdrqRepositoryName'
data UpdateRepositoryDescription = UpdateRepositoryDescription'
    { _urdrqRepositoryDescription :: !(Maybe Text)
    , _urdrqRepositoryName        :: !Text
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'UpdateRepositoryDescription' smart constructor.
updateRepositoryDescription :: Text -> UpdateRepositoryDescription
updateRepositoryDescription pRepositoryName_ =
    UpdateRepositoryDescription'
    { _urdrqRepositoryDescription = Nothing
    , _urdrqRepositoryName = pRepositoryName_
    }

-- | The new comment or description for the specified repository.
urdrqRepositoryDescription :: Lens' UpdateRepositoryDescription (Maybe Text)
urdrqRepositoryDescription = lens _urdrqRepositoryDescription (\ s a -> s{_urdrqRepositoryDescription = a});

-- | The name of the repository to set or change the comment or description
-- for.
urdrqRepositoryName :: Lens' UpdateRepositoryDescription Text
urdrqRepositoryName = lens _urdrqRepositoryName (\ s a -> s{_urdrqRepositoryName = a});

instance AWSRequest UpdateRepositoryDescription where
        type Sv UpdateRepositoryDescription = CodeCommit
        type Rs UpdateRepositoryDescription =
             UpdateRepositoryDescriptionResponse
        request = postJSON
        response
          = receiveNull UpdateRepositoryDescriptionResponse'

instance ToHeaders UpdateRepositoryDescription where
        toHeaders
          = const
              (mconcat
                 ["X-Amz-Target" =#
                    ("CodeCommit_20150413.UpdateRepositoryDescription" ::
                       ByteString),
                  "Content-Type" =#
                    ("application/x-amz-json-1.1" :: ByteString)])

instance ToJSON UpdateRepositoryDescription where
        toJSON UpdateRepositoryDescription'{..}
          = object
              ["repositoryDescription" .=
                 _urdrqRepositoryDescription,
               "repositoryName" .= _urdrqRepositoryName]

instance ToPath UpdateRepositoryDescription where
        toPath = const "/"

instance ToQuery UpdateRepositoryDescription where
        toQuery = const mempty

-- | /See:/ 'updateRepositoryDescriptionResponse' smart constructor.
data UpdateRepositoryDescriptionResponse =
    UpdateRepositoryDescriptionResponse'
    deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'UpdateRepositoryDescriptionResponse' smart constructor.
updateRepositoryDescriptionResponse :: UpdateRepositoryDescriptionResponse
updateRepositoryDescriptionResponse = UpdateRepositoryDescriptionResponse'
