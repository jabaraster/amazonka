{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}

{-# OPTIONS_GHC -fno-warn-unused-binds   #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.ELB.CreateLBCookieStickinessPolicy
-- Copyright   : (c) 2013-2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Generates a stickiness policy with sticky session lifetimes controlled
-- by the lifetime of the browser (user-agent) or a specified expiration
-- period. This policy can be associated only with HTTP\/HTTPS listeners.
--
-- When a load balancer implements this policy, the load balancer uses a
-- special cookie to track the back-end server instance for each request.
-- When the load balancer receives a request, it first checks to see if
-- this cookie is present in the request. If so, the load balancer sends
-- the request to the application server specified in the cookie. If not,
-- the load balancer sends the request to a server that is chosen based on
-- the existing load-balancing algorithm.
--
-- A cookie is inserted into the response for binding subsequent requests
-- from the same user to that server. The validity of the cookie is based
-- on the cookie expiration time, which is specified in the policy
-- configuration.
--
-- For more information, see
-- <http://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/elb-sticky-sessions.html#enable-sticky-sessions-duration Duration-Based Session Stickiness>
-- in the /Elastic Load Balancing Developer Guide/.
--
-- <http://docs.aws.amazon.com/ElasticLoadBalancing/latest/APIReference/API_CreateLBCookieStickinessPolicy.html>
module Network.AWS.ELB.CreateLBCookieStickinessPolicy
    (
    -- * Request
      CreateLBCookieStickinessPolicy
    -- ** Request constructor
    , createLBCookieStickinessPolicy
    -- ** Request lenses
    , clbcsprqCookieExpirationPeriod
    , clbcsprqLoadBalancerName
    , clbcsprqPolicyName

    -- * Response
    , CreateLBCookieStickinessPolicyResponse
    -- ** Response constructor
    , createLBCookieStickinessPolicyResponse
    -- ** Response lenses
    , clbcsprsStatus
    ) where

import           Network.AWS.ELB.Types
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response

-- | /See:/ 'createLBCookieStickinessPolicy' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'clbcsprqCookieExpirationPeriod'
--
-- * 'clbcsprqLoadBalancerName'
--
-- * 'clbcsprqPolicyName'
data CreateLBCookieStickinessPolicy = CreateLBCookieStickinessPolicy'
    { _clbcsprqCookieExpirationPeriod :: !(Maybe Integer)
    , _clbcsprqLoadBalancerName       :: !Text
    , _clbcsprqPolicyName             :: !Text
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'CreateLBCookieStickinessPolicy' smart constructor.
createLBCookieStickinessPolicy :: Text -> Text -> CreateLBCookieStickinessPolicy
createLBCookieStickinessPolicy pLoadBalancerName_ pPolicyName_ =
    CreateLBCookieStickinessPolicy'
    { _clbcsprqCookieExpirationPeriod = Nothing
    , _clbcsprqLoadBalancerName = pLoadBalancerName_
    , _clbcsprqPolicyName = pPolicyName_
    }

-- | The time period, in seconds, after which the cookie should be considered
-- stale. If you do not specify this parameter, the sticky session lasts
-- for the duration of the browser session.
clbcsprqCookieExpirationPeriod :: Lens' CreateLBCookieStickinessPolicy (Maybe Integer)
clbcsprqCookieExpirationPeriod = lens _clbcsprqCookieExpirationPeriod (\ s a -> s{_clbcsprqCookieExpirationPeriod = a});

-- | The name of the load balancer.
clbcsprqLoadBalancerName :: Lens' CreateLBCookieStickinessPolicy Text
clbcsprqLoadBalancerName = lens _clbcsprqLoadBalancerName (\ s a -> s{_clbcsprqLoadBalancerName = a});

-- | The name of the policy being created. This name must be unique within
-- the set of policies for this load balancer.
clbcsprqPolicyName :: Lens' CreateLBCookieStickinessPolicy Text
clbcsprqPolicyName = lens _clbcsprqPolicyName (\ s a -> s{_clbcsprqPolicyName = a});

instance AWSRequest CreateLBCookieStickinessPolicy
         where
        type Sv CreateLBCookieStickinessPolicy = ELB
        type Rs CreateLBCookieStickinessPolicy =
             CreateLBCookieStickinessPolicyResponse
        request = post
        response
          = receiveXMLWrapper
              "CreateLBCookieStickinessPolicyResult"
              (\ s h x ->
                 CreateLBCookieStickinessPolicyResponse' <$>
                   (pure (fromEnum s)))

instance ToHeaders CreateLBCookieStickinessPolicy
         where
        toHeaders = const mempty

instance ToPath CreateLBCookieStickinessPolicy where
        toPath = const "/"

instance ToQuery CreateLBCookieStickinessPolicy where
        toQuery CreateLBCookieStickinessPolicy'{..}
          = mconcat
              ["Action" =:
                 ("CreateLBCookieStickinessPolicy" :: ByteString),
               "Version" =: ("2012-06-01" :: ByteString),
               "CookieExpirationPeriod" =:
                 _clbcsprqCookieExpirationPeriod,
               "LoadBalancerName" =: _clbcsprqLoadBalancerName,
               "PolicyName" =: _clbcsprqPolicyName]

-- | /See:/ 'createLBCookieStickinessPolicyResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'clbcsprsStatus'
newtype CreateLBCookieStickinessPolicyResponse = CreateLBCookieStickinessPolicyResponse'
    { _clbcsprsStatus :: Int
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'CreateLBCookieStickinessPolicyResponse' smart constructor.
createLBCookieStickinessPolicyResponse :: Int -> CreateLBCookieStickinessPolicyResponse
createLBCookieStickinessPolicyResponse pStatus_ =
    CreateLBCookieStickinessPolicyResponse'
    { _clbcsprsStatus = pStatus_
    }

-- | FIXME: Undocumented member.
clbcsprsStatus :: Lens' CreateLBCookieStickinessPolicyResponse Int
clbcsprsStatus = lens _clbcsprsStatus (\ s a -> s{_clbcsprsStatus = a});
