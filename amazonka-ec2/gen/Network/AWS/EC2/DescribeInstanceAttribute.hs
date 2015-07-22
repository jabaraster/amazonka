{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}

{-# OPTIONS_GHC -fno-warn-unused-binds   #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.EC2.DescribeInstanceAttribute
-- Copyright   : (c) 2013-2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Describes the specified attribute of the specified instance. You can
-- specify only one attribute at a time. Valid attribute values are:
-- @instanceType@ | @kernel@ | @ramdisk@ | @userData@ |
-- @disableApiTermination@ | @instanceInitiatedShutdownBehavior@ |
-- @rootDeviceName@ | @blockDeviceMapping@ | @productCodes@ |
-- @sourceDestCheck@ | @groupSet@ | @ebsOptimized@ | @sriovNetSupport@
--
-- <http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeInstanceAttribute.html>
module Network.AWS.EC2.DescribeInstanceAttribute
    (
    -- * Request
      DescribeInstanceAttribute
    -- ** Request constructor
    , describeInstanceAttribute
    -- ** Request lenses
    , diarqDryRun
    , diarqInstanceId
    , diarqAttribute

    -- * Response
    , DescribeInstanceAttributeResponse
    -- ** Response constructor
    , describeInstanceAttributeResponse
    -- ** Response lenses
    , drsInstanceId
    , drsGroups
    , drsSourceDestCheck
    , drsDisableAPITermination
    , drsRAMDiskId
    , drsKernelId
    , drsInstanceType
    , drsRootDeviceName
    , drsEBSOptimized
    , drsUserData
    , drsSRIOVNetSupport
    , drsInstanceInitiatedShutdownBehavior
    , drsProductCodes
    , drsBlockDeviceMappings
    , drsStatus
    ) where

import           Network.AWS.EC2.Types
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response

-- | /See:/ 'describeInstanceAttribute' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'diarqDryRun'
--
-- * 'diarqInstanceId'
--
-- * 'diarqAttribute'
data DescribeInstanceAttribute = DescribeInstanceAttribute'
    { _diarqDryRun     :: !(Maybe Bool)
    , _diarqInstanceId :: !Text
    , _diarqAttribute  :: !InstanceAttributeName
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'DescribeInstanceAttribute' smart constructor.
describeInstanceAttribute :: Text -> InstanceAttributeName -> DescribeInstanceAttribute
describeInstanceAttribute pInstanceId_ pAttribute_ =
    DescribeInstanceAttribute'
    { _diarqDryRun = Nothing
    , _diarqInstanceId = pInstanceId_
    , _diarqAttribute = pAttribute_
    }

-- | Checks whether you have the required permissions for the action, without
-- actually making the request, and provides an error response. If you have
-- the required permissions, the error response is @DryRunOperation@.
-- Otherwise, it is @UnauthorizedOperation@.
diarqDryRun :: Lens' DescribeInstanceAttribute (Maybe Bool)
diarqDryRun = lens _diarqDryRun (\ s a -> s{_diarqDryRun = a});

-- | The ID of the instance.
diarqInstanceId :: Lens' DescribeInstanceAttribute Text
diarqInstanceId = lens _diarqInstanceId (\ s a -> s{_diarqInstanceId = a});

-- | The instance attribute.
diarqAttribute :: Lens' DescribeInstanceAttribute InstanceAttributeName
diarqAttribute = lens _diarqAttribute (\ s a -> s{_diarqAttribute = a});

instance AWSRequest DescribeInstanceAttribute where
        type Sv DescribeInstanceAttribute = EC2
        type Rs DescribeInstanceAttribute =
             DescribeInstanceAttributeResponse
        request = post
        response
          = receiveXML
              (\ s h x ->
                 DescribeInstanceAttributeResponse' <$>
                   (x .@? "instanceId") <*>
                     (x .@? "groupSet" .!@ mempty >>=
                        may (parseXMLList "item"))
                     <*> (x .@? "sourceDestCheck")
                     <*> (x .@? "disableApiTermination")
                     <*> (x .@? "ramdisk")
                     <*> (x .@? "kernel")
                     <*> (x .@? "instanceType")
                     <*> (x .@? "rootDeviceName")
                     <*> (x .@? "ebsOptimized")
                     <*> (x .@? "userData")
                     <*> (x .@? "sriovNetSupport")
                     <*> (x .@? "instanceInitiatedShutdownBehavior")
                     <*>
                     (x .@? "productCodes" .!@ mempty >>=
                        may (parseXMLList "item"))
                     <*>
                     (x .@? "blockDeviceMapping" .!@ mempty >>=
                        may (parseXMLList "item"))
                     <*> (pure (fromEnum s)))

instance ToHeaders DescribeInstanceAttribute where
        toHeaders = const mempty

instance ToPath DescribeInstanceAttribute where
        toPath = const "/"

instance ToQuery DescribeInstanceAttribute where
        toQuery DescribeInstanceAttribute'{..}
          = mconcat
              ["Action" =:
                 ("DescribeInstanceAttribute" :: ByteString),
               "Version" =: ("2015-04-15" :: ByteString),
               "DryRun" =: _diarqDryRun,
               "InstanceId" =: _diarqInstanceId,
               "Attribute" =: _diarqAttribute]

-- | Describes an instance attribute.
--
-- /See:/ 'describeInstanceAttributeResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'drsInstanceId'
--
-- * 'drsGroups'
--
-- * 'drsSourceDestCheck'
--
-- * 'drsDisableAPITermination'
--
-- * 'drsRAMDiskId'
--
-- * 'drsKernelId'
--
-- * 'drsInstanceType'
--
-- * 'drsRootDeviceName'
--
-- * 'drsEBSOptimized'
--
-- * 'drsUserData'
--
-- * 'drsSRIOVNetSupport'
--
-- * 'drsInstanceInitiatedShutdownBehavior'
--
-- * 'drsProductCodes'
--
-- * 'drsBlockDeviceMappings'
--
-- * 'drsStatus'
data DescribeInstanceAttributeResponse = DescribeInstanceAttributeResponse'
    { _drsInstanceId                        :: !(Maybe Text)
    , _drsGroups                            :: !(Maybe [GroupIdentifier])
    , _drsSourceDestCheck                   :: !(Maybe AttributeBooleanValue)
    , _drsDisableAPITermination             :: !(Maybe AttributeBooleanValue)
    , _drsRAMDiskId                         :: !(Maybe AttributeValue)
    , _drsKernelId                          :: !(Maybe AttributeValue)
    , _drsInstanceType                      :: !(Maybe AttributeValue)
    , _drsRootDeviceName                    :: !(Maybe AttributeValue)
    , _drsEBSOptimized                      :: !(Maybe AttributeBooleanValue)
    , _drsUserData                          :: !(Maybe AttributeValue)
    , _drsSRIOVNetSupport                   :: !(Maybe AttributeValue)
    , _drsInstanceInitiatedShutdownBehavior :: !(Maybe AttributeValue)
    , _drsProductCodes                      :: !(Maybe [ProductCode])
    , _drsBlockDeviceMappings               :: !(Maybe [InstanceBlockDeviceMapping])
    , _drsStatus                            :: !Int
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'DescribeInstanceAttributeResponse' smart constructor.
describeInstanceAttributeResponse :: Int -> DescribeInstanceAttributeResponse
describeInstanceAttributeResponse pStatus_ =
    DescribeInstanceAttributeResponse'
    { _drsInstanceId = Nothing
    , _drsGroups = Nothing
    , _drsSourceDestCheck = Nothing
    , _drsDisableAPITermination = Nothing
    , _drsRAMDiskId = Nothing
    , _drsKernelId = Nothing
    , _drsInstanceType = Nothing
    , _drsRootDeviceName = Nothing
    , _drsEBSOptimized = Nothing
    , _drsUserData = Nothing
    , _drsSRIOVNetSupport = Nothing
    , _drsInstanceInitiatedShutdownBehavior = Nothing
    , _drsProductCodes = Nothing
    , _drsBlockDeviceMappings = Nothing
    , _drsStatus = pStatus_
    }

-- | The ID of the instance.
drsInstanceId :: Lens' DescribeInstanceAttributeResponse (Maybe Text)
drsInstanceId = lens _drsInstanceId (\ s a -> s{_drsInstanceId = a});

-- | The security groups associated with the instance.
drsGroups :: Lens' DescribeInstanceAttributeResponse [GroupIdentifier]
drsGroups = lens _drsGroups (\ s a -> s{_drsGroups = a}) . _Default;

-- | Indicates whether source\/destination checking is enabled. A value of
-- @true@ means checking is enabled, and @false@ means checking is
-- disabled. This value must be @false@ for a NAT instance to perform NAT.
drsSourceDestCheck :: Lens' DescribeInstanceAttributeResponse (Maybe AttributeBooleanValue)
drsSourceDestCheck = lens _drsSourceDestCheck (\ s a -> s{_drsSourceDestCheck = a});

-- | If the value is @true@, you can\'t terminate the instance through the
-- Amazon EC2 console, CLI, or API; otherwise, you can.
drsDisableAPITermination :: Lens' DescribeInstanceAttributeResponse (Maybe AttributeBooleanValue)
drsDisableAPITermination = lens _drsDisableAPITermination (\ s a -> s{_drsDisableAPITermination = a});

-- | The RAM disk ID.
drsRAMDiskId :: Lens' DescribeInstanceAttributeResponse (Maybe AttributeValue)
drsRAMDiskId = lens _drsRAMDiskId (\ s a -> s{_drsRAMDiskId = a});

-- | The kernel ID.
drsKernelId :: Lens' DescribeInstanceAttributeResponse (Maybe AttributeValue)
drsKernelId = lens _drsKernelId (\ s a -> s{_drsKernelId = a});

-- | The instance type.
drsInstanceType :: Lens' DescribeInstanceAttributeResponse (Maybe AttributeValue)
drsInstanceType = lens _drsInstanceType (\ s a -> s{_drsInstanceType = a});

-- | The name of the root device (for example, @\/dev\/sda1@ or
-- @\/dev\/xvda@).
drsRootDeviceName :: Lens' DescribeInstanceAttributeResponse (Maybe AttributeValue)
drsRootDeviceName = lens _drsRootDeviceName (\ s a -> s{_drsRootDeviceName = a});

-- | Indicates whether the instance is optimized for EBS I\/O.
drsEBSOptimized :: Lens' DescribeInstanceAttributeResponse (Maybe AttributeBooleanValue)
drsEBSOptimized = lens _drsEBSOptimized (\ s a -> s{_drsEBSOptimized = a});

-- | The Base64-encoded MIME user data.
drsUserData :: Lens' DescribeInstanceAttributeResponse (Maybe AttributeValue)
drsUserData = lens _drsUserData (\ s a -> s{_drsUserData = a});

-- | FIXME: Undocumented member.
drsSRIOVNetSupport :: Lens' DescribeInstanceAttributeResponse (Maybe AttributeValue)
drsSRIOVNetSupport = lens _drsSRIOVNetSupport (\ s a -> s{_drsSRIOVNetSupport = a});

-- | Indicates whether an instance stops or terminates when you initiate
-- shutdown from the instance (using the operating system command for
-- system shutdown).
drsInstanceInitiatedShutdownBehavior :: Lens' DescribeInstanceAttributeResponse (Maybe AttributeValue)
drsInstanceInitiatedShutdownBehavior = lens _drsInstanceInitiatedShutdownBehavior (\ s a -> s{_drsInstanceInitiatedShutdownBehavior = a});

-- | A list of product codes.
drsProductCodes :: Lens' DescribeInstanceAttributeResponse [ProductCode]
drsProductCodes = lens _drsProductCodes (\ s a -> s{_drsProductCodes = a}) . _Default;

-- | The block device mapping of the instance.
drsBlockDeviceMappings :: Lens' DescribeInstanceAttributeResponse [InstanceBlockDeviceMapping]
drsBlockDeviceMappings = lens _drsBlockDeviceMappings (\ s a -> s{_drsBlockDeviceMappings = a}) . _Default;

-- | FIXME: Undocumented member.
drsStatus :: Lens' DescribeInstanceAttributeResponse Int
drsStatus = lens _drsStatus (\ s a -> s{_drsStatus = a});
