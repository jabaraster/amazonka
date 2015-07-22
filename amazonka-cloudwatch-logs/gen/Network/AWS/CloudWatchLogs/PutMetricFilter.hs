{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}

{-# OPTIONS_GHC -fno-warn-unused-binds   #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.CloudWatchLogs.PutMetricFilter
-- Copyright   : (c) 2013-2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Creates or updates a metric filter and associates it with the specified
-- log group. Metric filters allow you to configure rules to extract metric
-- data from log events ingested through @PutLogEvents@ requests.
--
-- The maximum number of metric filters that can be associated with a log
-- group is 100.
--
-- <http://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_PutMetricFilter.html>
module Network.AWS.CloudWatchLogs.PutMetricFilter
    (
    -- * Request
      PutMetricFilter
    -- ** Request constructor
    , putMetricFilter
    -- ** Request lenses
    , pmfrqLogGroupName
    , pmfrqFilterName
    , pmfrqFilterPattern
    , pmfrqMetricTransformations

    -- * Response
    , PutMetricFilterResponse
    -- ** Response constructor
    , putMetricFilterResponse
    ) where

import           Network.AWS.CloudWatchLogs.Types
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response

-- | /See:/ 'putMetricFilter' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'pmfrqLogGroupName'
--
-- * 'pmfrqFilterName'
--
-- * 'pmfrqFilterPattern'
--
-- * 'pmfrqMetricTransformations'
data PutMetricFilter = PutMetricFilter'
    { _pmfrqLogGroupName          :: !Text
    , _pmfrqFilterName            :: !Text
    , _pmfrqFilterPattern         :: !Text
    , _pmfrqMetricTransformations :: !(List1 MetricTransformation)
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'PutMetricFilter' smart constructor.
putMetricFilter :: Text -> Text -> Text -> NonEmpty MetricTransformation -> PutMetricFilter
putMetricFilter pLogGroupName_ pFilterName_ pFilterPattern_ pMetricTransformations_ =
    PutMetricFilter'
    { _pmfrqLogGroupName = pLogGroupName_
    , _pmfrqFilterName = pFilterName_
    , _pmfrqFilterPattern = pFilterPattern_
    , _pmfrqMetricTransformations = _List1 # pMetricTransformations_
    }

-- | The name of the log group to associate the metric filter with.
pmfrqLogGroupName :: Lens' PutMetricFilter Text
pmfrqLogGroupName = lens _pmfrqLogGroupName (\ s a -> s{_pmfrqLogGroupName = a});

-- | A name for the metric filter.
pmfrqFilterName :: Lens' PutMetricFilter Text
pmfrqFilterName = lens _pmfrqFilterName (\ s a -> s{_pmfrqFilterName = a});

-- | A valid CloudWatch Logs filter pattern for extracting metric data out of
-- ingested log events.
pmfrqFilterPattern :: Lens' PutMetricFilter Text
pmfrqFilterPattern = lens _pmfrqFilterPattern (\ s a -> s{_pmfrqFilterPattern = a});

-- | A collection of information needed to define how metric data gets
-- emitted.
pmfrqMetricTransformations :: Lens' PutMetricFilter (NonEmpty MetricTransformation)
pmfrqMetricTransformations = lens _pmfrqMetricTransformations (\ s a -> s{_pmfrqMetricTransformations = a}) . _List1;

instance AWSRequest PutMetricFilter where
        type Sv PutMetricFilter = CloudWatchLogs
        type Rs PutMetricFilter = PutMetricFilterResponse
        request = postJSON
        response = receiveNull PutMetricFilterResponse'

instance ToHeaders PutMetricFilter where
        toHeaders
          = const
              (mconcat
                 ["X-Amz-Target" =#
                    ("Logs_20140328.PutMetricFilter" :: ByteString),
                  "Content-Type" =#
                    ("application/x-amz-json-1.1" :: ByteString)])

instance ToJSON PutMetricFilter where
        toJSON PutMetricFilter'{..}
          = object
              ["logGroupName" .= _pmfrqLogGroupName,
               "filterName" .= _pmfrqFilterName,
               "filterPattern" .= _pmfrqFilterPattern,
               "metricTransformations" .=
                 _pmfrqMetricTransformations]

instance ToPath PutMetricFilter where
        toPath = const "/"

instance ToQuery PutMetricFilter where
        toQuery = const mempty

-- | /See:/ 'putMetricFilterResponse' smart constructor.
data PutMetricFilterResponse =
    PutMetricFilterResponse'
    deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'PutMetricFilterResponse' smart constructor.
putMetricFilterResponse :: PutMetricFilterResponse
putMetricFilterResponse = PutMetricFilterResponse'
