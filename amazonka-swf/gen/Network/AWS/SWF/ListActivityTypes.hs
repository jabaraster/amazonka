{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}

{-# OPTIONS_GHC -fno-warn-unused-binds   #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.SWF.ListActivityTypes
-- Copyright   : (c) 2013-2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Returns information about all activities registered in the specified
-- domain that match the specified name and registration status. The result
-- includes information like creation date, current status of the activity,
-- etc. The results may be split into multiple pages. To retrieve
-- subsequent pages, make the call again using the @nextPageToken@ returned
-- by the initial call.
--
-- __Access Control__
--
-- You can use IAM policies to control this action\'s access to Amazon SWF
-- resources as follows:
--
-- -   Use a @Resource@ element with the domain name to limit the action to
--     only specified domains.
-- -   Use an @Action@ element to allow or deny permission to call this
--     action.
-- -   You cannot use an IAM policy to constrain this action\'s parameters.
--
-- If the caller does not have sufficient permissions to invoke the action,
-- or the parameter values fall outside the specified constraints, the
-- action fails. The associated event attribute\'s __cause__ parameter will
-- be set to OPERATION_NOT_PERMITTED. For details and example IAM policies,
-- see
-- <http://docs.aws.amazon.com/amazonswf/latest/developerguide/swf-dev-iam.html Using IAM to Manage Access to Amazon SWF Workflows>.
--
-- <http://docs.aws.amazon.com/amazonswf/latest/apireference/API_ListActivityTypes.html>
module Network.AWS.SWF.ListActivityTypes
    (
    -- * Request
      ListActivityTypes
    -- ** Request constructor
    , listActivityTypes
    -- ** Request lenses
    , latrqNextPageToken
    , latrqReverseOrder
    , latrqName
    , latrqMaximumPageSize
    , latrqDomain
    , latrqRegistrationStatus

    -- * Response
    , ListActivityTypesResponse
    -- ** Response constructor
    , listActivityTypesResponse
    -- ** Response lenses
    , latrsNextPageToken
    , latrsStatus
    , latrsTypeInfos
    ) where

import           Network.AWS.Pager
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response
import           Network.AWS.SWF.Types

-- | /See:/ 'listActivityTypes' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'latrqNextPageToken'
--
-- * 'latrqReverseOrder'
--
-- * 'latrqName'
--
-- * 'latrqMaximumPageSize'
--
-- * 'latrqDomain'
--
-- * 'latrqRegistrationStatus'
data ListActivityTypes = ListActivityTypes'
    { _latrqNextPageToken      :: !(Maybe Text)
    , _latrqReverseOrder       :: !(Maybe Bool)
    , _latrqName               :: !(Maybe Text)
    , _latrqMaximumPageSize    :: !(Maybe Nat)
    , _latrqDomain             :: !Text
    , _latrqRegistrationStatus :: !RegistrationStatus
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'ListActivityTypes' smart constructor.
listActivityTypes :: Text -> RegistrationStatus -> ListActivityTypes
listActivityTypes pDomain_ pRegistrationStatus_ =
    ListActivityTypes'
    { _latrqNextPageToken = Nothing
    , _latrqReverseOrder = Nothing
    , _latrqName = Nothing
    , _latrqMaximumPageSize = Nothing
    , _latrqDomain = pDomain_
    , _latrqRegistrationStatus = pRegistrationStatus_
    }

-- | If a @NextPageToken@ was returned by a previous call, there are more
-- results available. To retrieve the next page of results, make the call
-- again using the returned token in @nextPageToken@. Keep all other
-- arguments unchanged.
--
-- The configured @maximumPageSize@ determines how many results can be
-- returned in a single call.
latrqNextPageToken :: Lens' ListActivityTypes (Maybe Text)
latrqNextPageToken = lens _latrqNextPageToken (\ s a -> s{_latrqNextPageToken = a});

-- | When set to @true@, returns the results in reverse order. By default,
-- the results are returned in ascending alphabetical order by @name@ of
-- the activity types.
latrqReverseOrder :: Lens' ListActivityTypes (Maybe Bool)
latrqReverseOrder = lens _latrqReverseOrder (\ s a -> s{_latrqReverseOrder = a});

-- | If specified, only lists the activity types that have this name.
latrqName :: Lens' ListActivityTypes (Maybe Text)
latrqName = lens _latrqName (\ s a -> s{_latrqName = a});

-- | The maximum number of results that will be returned per call.
-- @nextPageToken@ can be used to obtain futher pages of results. The
-- default is 100, which is the maximum allowed page size. You can,
-- however, specify a page size /smaller/ than 100.
--
-- This is an upper limit only; the actual number of results returned per
-- call may be fewer than the specified maximum.
latrqMaximumPageSize :: Lens' ListActivityTypes (Maybe Natural)
latrqMaximumPageSize = lens _latrqMaximumPageSize (\ s a -> s{_latrqMaximumPageSize = a}) . mapping _Nat;

-- | The name of the domain in which the activity types have been registered.
latrqDomain :: Lens' ListActivityTypes Text
latrqDomain = lens _latrqDomain (\ s a -> s{_latrqDomain = a});

-- | Specifies the registration status of the activity types to list.
latrqRegistrationStatus :: Lens' ListActivityTypes RegistrationStatus
latrqRegistrationStatus = lens _latrqRegistrationStatus (\ s a -> s{_latrqRegistrationStatus = a});

instance AWSPager ListActivityTypes where
        page rq rs
          | stop (rs ^. latrsNextPageToken) = Nothing
          | stop (rs ^. latrsTypeInfos) = Nothing
          | otherwise =
            Just $ rq &
              latrqNextPageToken .~ rs ^. latrsNextPageToken

instance AWSRequest ListActivityTypes where
        type Sv ListActivityTypes = SWF
        type Rs ListActivityTypes = ListActivityTypesResponse
        request = postJSON
        response
          = receiveJSON
              (\ s h x ->
                 ListActivityTypesResponse' <$>
                   (x .?> "nextPageToken") <*> (pure (fromEnum s)) <*>
                     (x .?> "typeInfos" .!@ mempty))

instance ToHeaders ListActivityTypes where
        toHeaders
          = const
              (mconcat
                 ["X-Amz-Target" =#
                    ("SimpleWorkflowService.ListActivityTypes" ::
                       ByteString),
                  "Content-Type" =#
                    ("application/x-amz-json-1.0" :: ByteString)])

instance ToJSON ListActivityTypes where
        toJSON ListActivityTypes'{..}
          = object
              ["nextPageToken" .= _latrqNextPageToken,
               "reverseOrder" .= _latrqReverseOrder,
               "name" .= _latrqName,
               "maximumPageSize" .= _latrqMaximumPageSize,
               "domain" .= _latrqDomain,
               "registrationStatus" .= _latrqRegistrationStatus]

instance ToPath ListActivityTypes where
        toPath = const "/"

instance ToQuery ListActivityTypes where
        toQuery = const mempty

-- | Contains a paginated list of activity type information structures.
--
-- /See:/ 'listActivityTypesResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'latrsNextPageToken'
--
-- * 'latrsStatus'
--
-- * 'latrsTypeInfos'
data ListActivityTypesResponse = ListActivityTypesResponse'
    { _latrsNextPageToken :: !(Maybe Text)
    , _latrsStatus        :: !Int
    , _latrsTypeInfos     :: ![ActivityTypeInfo]
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'ListActivityTypesResponse' smart constructor.
listActivityTypesResponse :: Int -> ListActivityTypesResponse
listActivityTypesResponse pStatus_ =
    ListActivityTypesResponse'
    { _latrsNextPageToken = Nothing
    , _latrsStatus = pStatus_
    , _latrsTypeInfos = mempty
    }

-- | If a @NextPageToken@ was returned by a previous call, there are more
-- results available. To retrieve the next page of results, make the call
-- again using the returned token in @nextPageToken@. Keep all other
-- arguments unchanged.
--
-- The configured @maximumPageSize@ determines how many results can be
-- returned in a single call.
latrsNextPageToken :: Lens' ListActivityTypesResponse (Maybe Text)
latrsNextPageToken = lens _latrsNextPageToken (\ s a -> s{_latrsNextPageToken = a});

-- | FIXME: Undocumented member.
latrsStatus :: Lens' ListActivityTypesResponse Int
latrsStatus = lens _latrsStatus (\ s a -> s{_latrsStatus = a});

-- | List of activity type information.
latrsTypeInfos :: Lens' ListActivityTypesResponse [ActivityTypeInfo]
latrsTypeInfos = lens _latrsTypeInfos (\ s a -> s{_latrsTypeInfos = a});
