{-# LANGUAGE OverloadedStrings #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.Discovery.Types
-- Copyright   : (c) 2013-2016 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : auto-generated
-- Portability : non-portable (GHC extensions)
--
module Network.AWS.Discovery.Types
    (
    -- * Service Configuration
      discovery

    -- * Errors
    , _AuthorizationErrorException
    , _InvalidParameterException
    , _InvalidParameterValueException
    , _ServerInternalErrorException
    , _OperationNotPermittedException
    , _ResourceNotFoundException

    -- * AgentStatus
    , AgentStatus (..)

    -- * ConfigurationItemType
    , ConfigurationItemType (..)

    -- * ExportStatus
    , ExportStatus (..)

    -- * AgentConfigurationStatus
    , AgentConfigurationStatus
    , agentConfigurationStatus
    , acsAgentId
    , acsOperationSucceeded
    , acsDescription

    -- * AgentInfo
    , AgentInfo
    , agentInfo
    , aiHostName
    , aiAgentNetworkInfoList
    , aiConnectorId
    , aiHealth
    , aiAgentId
    , aiVersion

    -- * AgentNetworkInfo
    , AgentNetworkInfo
    , agentNetworkInfo
    , aniIpAddress
    , aniMacAddress

    -- * ConfigurationTag
    , ConfigurationTag
    , configurationTag
    , ctTimeOfCreation
    , ctConfigurationId
    , ctConfigurationType
    , ctValue
    , ctKey

    -- * ExportInfo
    , ExportInfo
    , exportInfo
    , eiConfigurationsDownloadURL
    , eiExportId
    , eiExportStatus
    , eiStatusMessage
    , eiExportRequestTime

    -- * Filter
    , Filter
    , filter'
    , fName
    , fValues
    , fCondition

    -- * Tag
    , Tag
    , tag
    , tagKey
    , tagValue

    -- * TagFilter
    , TagFilter
    , tagFilter
    , tfName
    , tfValues
    ) where

import           Network.AWS.Discovery.Types.Product
import           Network.AWS.Discovery.Types.Sum
import           Network.AWS.Lens
import           Network.AWS.Prelude
import           Network.AWS.Sign.V4

-- | API version '2015-11-01' of the Amazon Application Discovery Service SDK configuration.
discovery :: Service
discovery =
    Service
    { _svcAbbrev = "Discovery"
    , _svcSigner = v4
    , _svcPrefix = "discovery"
    , _svcVersion = "2015-11-01"
    , _svcEndpoint = defaultEndpoint discovery
    , _svcTimeout = Just 70
    , _svcCheck = statusSuccess
    , _svcError = parseJSONError "Discovery"
    , _svcRetry = retry
    }
  where
    retry =
        Exponential
        { _retryBase = 5.0e-2
        , _retryGrowth = 2
        , _retryAttempts = 5
        , _retryCheck = check
        }
    check e
      | has (hasStatus 429) e = Just "too_many_requests"
      | has (hasCode "ThrottlingException" . hasStatus 400) e =
          Just "throttling_exception"
      | has (hasCode "Throttling" . hasStatus 400) e = Just "throttling"
      | has (hasStatus 504) e = Just "gateway_timeout"
      | has (hasStatus 502) e = Just "bad_gateway"
      | has (hasStatus 503) e = Just "service_unavailable"
      | has (hasStatus 500) e = Just "general_server_error"
      | has (hasStatus 509) e = Just "limit_exceeded"
      | otherwise = Nothing

-- | The AWS user account does not have permission to perform the action.
-- Check the IAM policy associated with this account.
_AuthorizationErrorException :: AsError a => Getting (First ServiceError) a ServiceError
_AuthorizationErrorException =
    _ServiceError . hasCode "AuthorizationErrorException"

-- | One or more parameters are not valid. Verify the parameters and try
-- again.
_InvalidParameterException :: AsError a => Getting (First ServiceError) a ServiceError
_InvalidParameterException =
    _ServiceError . hasCode "InvalidParameterException"

-- | The value of one or more parameters are either invalid or out of range.
-- Verify the parameter values and try again.
_InvalidParameterValueException :: AsError a => Getting (First ServiceError) a ServiceError
_InvalidParameterValueException =
    _ServiceError . hasCode "InvalidParameterValueException"

-- | The server experienced an internal error. Try again.
_ServerInternalErrorException :: AsError a => Getting (First ServiceError) a ServiceError
_ServerInternalErrorException =
    _ServiceError . hasCode "ServerInternalErrorException"

-- | This operation is not permitted.
_OperationNotPermittedException :: AsError a => Getting (First ServiceError) a ServiceError
_OperationNotPermittedException =
    _ServiceError . hasCode "OperationNotPermittedException"

-- | The specified configuration ID was not located. Verify the configuration
-- ID and try again.
_ResourceNotFoundException :: AsError a => Getting (First ServiceError) a ServiceError
_ResourceNotFoundException =
    _ServiceError . hasCode "ResourceNotFoundException"