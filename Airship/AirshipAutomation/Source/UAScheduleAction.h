/* Copyright Airship and Contributors */

#import "UAAirshipAutomationCoreImport.h"

/**
 * Action to schedule other actions.
 *
 * This action is registered under the names schedule_actions and ^sa.
 *
 * Expected argument values: NSDictionary representing a schedule info JSON.
 *
 * Valid situations: UASituationBackgroundPush, UASituationForegroundPush
 * UASituationWebViewInvocation, UASituationManualInvocation, and UASituationAutomation
 *
 * Result value: Schedule ID or nil if the schedule failed.
 */
@interface UAScheduleAction : UAAction

/**
 * Default registry name for schedule action.
 */
extern NSString * const UAScheduleActionDefaultRegistryName;

/**
 * Default registry alias for schedule action.
 */
extern NSString * const UAScheduleActionDefaultRegistryAlias;

/**
 * Default registry name for schedule action.
 *
 * @deprecated Deprecated – to be removed in SDK version 14.0. Please use UAScheduleActionDefaultRegistryName.
*/
extern NSString * const kUAScheduleActionDefaultRegistryName DEPRECATED_MSG_ATTRIBUTE("Deprecated – to be removed in SDK version 14.0. Please use UAScheduleActionDefaultRegistryName.");

/**
 * Default registry alias for schedule action.
 *
 * @deprecated Deprecated – to be removed in SDK version 14.0. Please use UAScheduleActionDefaultRegistryAlias.
*/
extern NSString * const kUAScheduleActionDefaultRegistryAlias DEPRECATED_MSG_ATTRIBUTE("Deprecated – to be removed in SDK version 14.0. Please use UAScheduleActionDefaultRegistryAlias.");

@end
