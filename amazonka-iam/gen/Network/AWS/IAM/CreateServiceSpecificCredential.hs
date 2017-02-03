{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}

{-# OPTIONS_GHC -fno-warn-unused-imports #-}
{-# OPTIONS_GHC -fno-warn-unused-binds   #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.IAM.CreateServiceSpecificCredential
-- Copyright   : (c) 2013-2016 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : auto-generated
-- Portability : non-portable (GHC extensions)
--
-- Generates a set of credentials consisting of a user name and password that can be used to access the service specified in the request. These credentials are generated by IAM, and can be used only for the specified service.
--
--
-- You can have a maximum of two sets of service-specific credentials for each supported service per user.
--
-- The only supported service at this time is AWS CodeCommit.
--
-- You can reset the password to a new service-generated value by calling 'ResetServiceSpecificCredential' .
--
-- For more information about service-specific credentials, see <http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_ssh-keys.html Using IAM with AWS CodeCommit: Git Credentials, SSH Keys, and AWS Access Keys> in the /IAM User Guide/ .
--
module Network.AWS.IAM.CreateServiceSpecificCredential
    (
    -- * Creating a Request
      createServiceSpecificCredential
    , CreateServiceSpecificCredential
    -- * Request Lenses
    , csscUserName
    , csscServiceName

    -- * Destructuring the Response
    , createServiceSpecificCredentialResponse
    , CreateServiceSpecificCredentialResponse
    -- * Response Lenses
    , csscrsServiceSpecificCredential
    , csscrsResponseStatus
    ) where

import           Network.AWS.IAM.Types
import           Network.AWS.IAM.Types.Product
import           Network.AWS.Lens
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response

-- | /See:/ 'createServiceSpecificCredential' smart constructor.
data CreateServiceSpecificCredential = CreateServiceSpecificCredential'
    { _csscUserName    :: !Text
    , _csscServiceName :: !Text
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | Creates a value of 'CreateServiceSpecificCredential' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'csscUserName' - The name of the IAM user that is to be associated with the credentials. The new service-specific credentials have the same permissions as the associated user except that they can be used only to access the specified service. This parameter allows (per its <http://wikipedia.org/wiki/regex regex pattern> ) a string of characters consisting of upper and lowercase alphanumeric characters with no spaces. You can also include any of the following characters: =,.@-
--
-- * 'csscServiceName' - The name of the AWS service that is to be associated with the credentials. The service you specify here is the only service that can be accessed using these credentials.
createServiceSpecificCredential
    :: Text -- ^ 'csscUserName'
    -> Text -- ^ 'csscServiceName'
    -> CreateServiceSpecificCredential
createServiceSpecificCredential pUserName_ pServiceName_ =
    CreateServiceSpecificCredential'
    { _csscUserName = pUserName_
    , _csscServiceName = pServiceName_
    }

-- | The name of the IAM user that is to be associated with the credentials. The new service-specific credentials have the same permissions as the associated user except that they can be used only to access the specified service. This parameter allows (per its <http://wikipedia.org/wiki/regex regex pattern> ) a string of characters consisting of upper and lowercase alphanumeric characters with no spaces. You can also include any of the following characters: =,.@-
csscUserName :: Lens' CreateServiceSpecificCredential Text
csscUserName = lens _csscUserName (\ s a -> s{_csscUserName = a});

-- | The name of the AWS service that is to be associated with the credentials. The service you specify here is the only service that can be accessed using these credentials.
csscServiceName :: Lens' CreateServiceSpecificCredential Text
csscServiceName = lens _csscServiceName (\ s a -> s{_csscServiceName = a});

instance AWSRequest CreateServiceSpecificCredential
         where
        type Rs CreateServiceSpecificCredential =
             CreateServiceSpecificCredentialResponse
        request = postQuery iam
        response
          = receiveXMLWrapper
              "CreateServiceSpecificCredentialResult"
              (\ s h x ->
                 CreateServiceSpecificCredentialResponse' <$>
                   (x .@? "ServiceSpecificCredential") <*>
                     (pure (fromEnum s)))

instance Hashable CreateServiceSpecificCredential

instance NFData CreateServiceSpecificCredential

instance ToHeaders CreateServiceSpecificCredential
         where
        toHeaders = const mempty

instance ToPath CreateServiceSpecificCredential where
        toPath = const "/"

instance ToQuery CreateServiceSpecificCredential
         where
        toQuery CreateServiceSpecificCredential'{..}
          = mconcat
              ["Action" =:
                 ("CreateServiceSpecificCredential" :: ByteString),
               "Version" =: ("2010-05-08" :: ByteString),
               "UserName" =: _csscUserName,
               "ServiceName" =: _csscServiceName]

-- | /See:/ 'createServiceSpecificCredentialResponse' smart constructor.
data CreateServiceSpecificCredentialResponse = CreateServiceSpecificCredentialResponse'
    { _csscrsServiceSpecificCredential :: !(Maybe ServiceSpecificCredential)
    , _csscrsResponseStatus            :: !Int
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'CreateServiceSpecificCredentialResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'csscrsServiceSpecificCredential' - A structure that contains information about the newly created service-specific credential. /Important:/ This is the only time that the password for this credential set is available. It cannot be recovered later. Instead, you will have to reset the password with 'ResetServiceSpecificCredential' .
--
-- * 'csscrsResponseStatus' - -- | The response status code.
createServiceSpecificCredentialResponse
    :: Int -- ^ 'csscrsResponseStatus'
    -> CreateServiceSpecificCredentialResponse
createServiceSpecificCredentialResponse pResponseStatus_ =
    CreateServiceSpecificCredentialResponse'
    { _csscrsServiceSpecificCredential = Nothing
    , _csscrsResponseStatus = pResponseStatus_
    }

-- | A structure that contains information about the newly created service-specific credential. /Important:/ This is the only time that the password for this credential set is available. It cannot be recovered later. Instead, you will have to reset the password with 'ResetServiceSpecificCredential' .
csscrsServiceSpecificCredential :: Lens' CreateServiceSpecificCredentialResponse (Maybe ServiceSpecificCredential)
csscrsServiceSpecificCredential = lens _csscrsServiceSpecificCredential (\ s a -> s{_csscrsServiceSpecificCredential = a});

-- | -- | The response status code.
csscrsResponseStatus :: Lens' CreateServiceSpecificCredentialResponse Int
csscrsResponseStatus = lens _csscrsResponseStatus (\ s a -> s{_csscrsResponseStatus = a});

instance NFData
         CreateServiceSpecificCredentialResponse
