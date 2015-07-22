{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}

{-# OPTIONS_GHC -fno-warn-unused-binds   #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.OpsWorks.DescribeLayers
-- Copyright   : (c) 2013-2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Requests a description of one or more layers in a specified stack.
--
-- You must specify at least one of the parameters.
--
-- __Required Permissions__: To use this action, an IAM user must have a
-- Show, Deploy, or Manage permissions level for the stack, or an attached
-- policy that explicitly grants permissions. For more information on user
-- permissions, see
-- <http://docs.aws.amazon.com/opsworks/latest/userguide/opsworks-security-users.html Managing User Permissions>.
--
-- <http://docs.aws.amazon.com/opsworks/latest/APIReference/API_DescribeLayers.html>
module Network.AWS.OpsWorks.DescribeLayers
    (
    -- * Request
      DescribeLayers
    -- ** Request constructor
    , describeLayers
    -- ** Request lenses
    , dlrqLayerIds
    , dlrqStackId

    -- * Response
    , DescribeLayersResponse
    -- ** Response constructor
    , describeLayersResponse
    -- ** Response lenses
    , dlrsLayers
    , dlrsStatus
    ) where

import           Network.AWS.OpsWorks.Types
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response

-- | /See:/ 'describeLayers' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dlrqLayerIds'
--
-- * 'dlrqStackId'
data DescribeLayers = DescribeLayers'
    { _dlrqLayerIds :: !(Maybe [Text])
    , _dlrqStackId  :: !(Maybe Text)
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'DescribeLayers' smart constructor.
describeLayers :: DescribeLayers
describeLayers =
    DescribeLayers'
    { _dlrqLayerIds = Nothing
    , _dlrqStackId = Nothing
    }

-- | An array of layer IDs that specify the layers to be described. If you
-- omit this parameter, @DescribeLayers@ returns a description of every
-- layer in the specified stack.
dlrqLayerIds :: Lens' DescribeLayers [Text]
dlrqLayerIds = lens _dlrqLayerIds (\ s a -> s{_dlrqLayerIds = a}) . _Default;

-- | The stack ID.
dlrqStackId :: Lens' DescribeLayers (Maybe Text)
dlrqStackId = lens _dlrqStackId (\ s a -> s{_dlrqStackId = a});

instance AWSRequest DescribeLayers where
        type Sv DescribeLayers = OpsWorks
        type Rs DescribeLayers = DescribeLayersResponse
        request = postJSON
        response
          = receiveJSON
              (\ s h x ->
                 DescribeLayersResponse' <$>
                   (x .?> "Layers" .!@ mempty) <*> (pure (fromEnum s)))

instance ToHeaders DescribeLayers where
        toHeaders
          = const
              (mconcat
                 ["X-Amz-Target" =#
                    ("OpsWorks_20130218.DescribeLayers" :: ByteString),
                  "Content-Type" =#
                    ("application/x-amz-json-1.1" :: ByteString)])

instance ToJSON DescribeLayers where
        toJSON DescribeLayers'{..}
          = object
              ["LayerIds" .= _dlrqLayerIds,
               "StackId" .= _dlrqStackId]

instance ToPath DescribeLayers where
        toPath = const "/"

instance ToQuery DescribeLayers where
        toQuery = const mempty

-- | Contains the response to a @DescribeLayers@ request.
--
-- /See:/ 'describeLayersResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dlrsLayers'
--
-- * 'dlrsStatus'
data DescribeLayersResponse = DescribeLayersResponse'
    { _dlrsLayers :: !(Maybe [Layer])
    , _dlrsStatus :: !Int
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'DescribeLayersResponse' smart constructor.
describeLayersResponse :: Int -> DescribeLayersResponse
describeLayersResponse pStatus_ =
    DescribeLayersResponse'
    { _dlrsLayers = Nothing
    , _dlrsStatus = pStatus_
    }

-- | An array of @Layer@ objects that describe the layers.
dlrsLayers :: Lens' DescribeLayersResponse [Layer]
dlrsLayers = lens _dlrsLayers (\ s a -> s{_dlrsLayers = a}) . _Default;

-- | FIXME: Undocumented member.
dlrsStatus :: Lens' DescribeLayersResponse Int
dlrsStatus = lens _dlrsStatus (\ s a -> s{_dlrsStatus = a});
