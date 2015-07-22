{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}

{-# OPTIONS_GHC -fno-warn-unused-binds   #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.SWF.RespondDecisionTaskCompleted
-- Copyright   : (c) 2013-2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Used by deciders to tell the service that the DecisionTask identified by
-- the @taskToken@ has successfully completed. The @decisions@ argument
-- specifies the list of decisions made while processing the task.
--
-- A @DecisionTaskCompleted@ event is added to the workflow history. The
-- @executionContext@ specified is attached to the event in the workflow
-- execution history.
--
-- __Access Control__
--
-- If an IAM policy grants permission to use
-- @RespondDecisionTaskCompleted@, it can express permissions for the list
-- of decisions in the @decisions@ parameter. Each of the decisions has one
-- or more parameters, much like a regular API call. To allow for policies
-- to be as readable as possible, you can express permissions on decisions
-- as if they were actual API calls, including applying conditions to some
-- parameters. For more information, see
-- <http://docs.aws.amazon.com/amazonswf/latest/developerguide/swf-dev-iam.html Using IAM to Manage Access to Amazon SWF Workflows>.
--
-- <http://docs.aws.amazon.com/amazonswf/latest/apireference/API_RespondDecisionTaskCompleted.html>
module Network.AWS.SWF.RespondDecisionTaskCompleted
    (
    -- * Request
      RespondDecisionTaskCompleted
    -- ** Request constructor
    , respondDecisionTaskCompleted
    -- ** Request lenses
    , rdtcrqDecisions
    , rdtcrqExecutionContext
    , rdtcrqTaskToken

    -- * Response
    , RespondDecisionTaskCompletedResponse
    -- ** Response constructor
    , respondDecisionTaskCompletedResponse
    ) where

import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response
import           Network.AWS.SWF.Types

-- | /See:/ 'respondDecisionTaskCompleted' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'rdtcrqDecisions'
--
-- * 'rdtcrqExecutionContext'
--
-- * 'rdtcrqTaskToken'
data RespondDecisionTaskCompleted = RespondDecisionTaskCompleted'
    { _rdtcrqDecisions        :: !(Maybe [Decision])
    , _rdtcrqExecutionContext :: !(Maybe Text)
    , _rdtcrqTaskToken        :: !Text
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'RespondDecisionTaskCompleted' smart constructor.
respondDecisionTaskCompleted :: Text -> RespondDecisionTaskCompleted
respondDecisionTaskCompleted pTaskToken_ =
    RespondDecisionTaskCompleted'
    { _rdtcrqDecisions = Nothing
    , _rdtcrqExecutionContext = Nothing
    , _rdtcrqTaskToken = pTaskToken_
    }

-- | The list of decisions (possibly empty) made by the decider while
-- processing this decision task. See the docs for the Decision structure
-- for details.
rdtcrqDecisions :: Lens' RespondDecisionTaskCompleted [Decision]
rdtcrqDecisions = lens _rdtcrqDecisions (\ s a -> s{_rdtcrqDecisions = a}) . _Default;

-- | User defined context to add to workflow execution.
rdtcrqExecutionContext :: Lens' RespondDecisionTaskCompleted (Maybe Text)
rdtcrqExecutionContext = lens _rdtcrqExecutionContext (\ s a -> s{_rdtcrqExecutionContext = a});

-- | The @taskToken@ from the DecisionTask.
--
-- @taskToken@ is generated by the service and should be treated as an
-- opaque value. If the task is passed to another process, its @taskToken@
-- must also be passed. This enables it to provide its progress and respond
-- with results.
rdtcrqTaskToken :: Lens' RespondDecisionTaskCompleted Text
rdtcrqTaskToken = lens _rdtcrqTaskToken (\ s a -> s{_rdtcrqTaskToken = a});

instance AWSRequest RespondDecisionTaskCompleted
         where
        type Sv RespondDecisionTaskCompleted = SWF
        type Rs RespondDecisionTaskCompleted =
             RespondDecisionTaskCompletedResponse
        request = postJSON
        response
          = receiveNull RespondDecisionTaskCompletedResponse'

instance ToHeaders RespondDecisionTaskCompleted where
        toHeaders
          = const
              (mconcat
                 ["X-Amz-Target" =#
                    ("SimpleWorkflowService.RespondDecisionTaskCompleted"
                       :: ByteString),
                  "Content-Type" =#
                    ("application/x-amz-json-1.0" :: ByteString)])

instance ToJSON RespondDecisionTaskCompleted where
        toJSON RespondDecisionTaskCompleted'{..}
          = object
              ["decisions" .= _rdtcrqDecisions,
               "executionContext" .= _rdtcrqExecutionContext,
               "taskToken" .= _rdtcrqTaskToken]

instance ToPath RespondDecisionTaskCompleted where
        toPath = const "/"

instance ToQuery RespondDecisionTaskCompleted where
        toQuery = const mempty

-- | /See:/ 'respondDecisionTaskCompletedResponse' smart constructor.
data RespondDecisionTaskCompletedResponse =
    RespondDecisionTaskCompletedResponse'
    deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'RespondDecisionTaskCompletedResponse' smart constructor.
respondDecisionTaskCompletedResponse :: RespondDecisionTaskCompletedResponse
respondDecisionTaskCompletedResponse = RespondDecisionTaskCompletedResponse'
