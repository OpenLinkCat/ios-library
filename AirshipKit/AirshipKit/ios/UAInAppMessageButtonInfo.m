/* Copyright 2017 Urban Airship and Contributors */

#import "UAInAppMessageButtonInfo+Internal.h"
#import "UAInAppMessageTextInfo+Internal.h"
#import "UAGlobal.h"
#import "UAColorUtils+Internal.h"

NS_ASSUME_NONNULL_BEGIN
NSString *const UAInAppMessageButtonInfoDomain = @"com.urbanairship.in_app_message_button_info";

// JSON Keys and Values
NSString *const UAInAppMessageButtonInfoLabelKey = @"label";
NSString *const UAInAppMessageButtonInfoIdentifierKey = @"id";
NSString *const UAInAppMessageButtonInfoBehaviorKey = @"behavior";
NSString *const UAInAppMessageButtonInfoBorderRadiusKey = @"border_radius";
NSString *const UAInAppMessageButtonInfoBackgroundColorKey = @"background_color";
NSString *const UAInAppMessageButtonInfoBorderColorKey = @"border_color";
NSString *const UAInAppMessageButtonInfoActionsKey = @"actions";

NSString *const UAInAppMessageButtonInfoBehaviorCancelValue = @"cancel";
NSString *const UAInAppMessageButtonInfoBehaviorDismissValue = @"dismiss";

@interface UAInAppMessageButtonInfo ()
@property(nonatomic, strong) UAInAppMessageTextInfo *label;
@property(nonatomic, copy) NSString *identifier;
@property(nonatomic, assign) UAInAppMessageButtonInfoBehaviorType behavior;
@property(nonatomic, strong) UIColor *backgroundColor;
@property(nonatomic, strong) UIColor *borderColor;
@property(nonatomic, assign) NSUInteger borderRadius;
@property(nonatomic, copy, nullable) NSDictionary *actions;
@end

@implementation UAInAppMessageButtonInfoBuilder

// set default values for properties
- (instancetype)init {
    if (self = [super init]) {
        self.behavior = UAInAppMessageButtonInfoBehaviorDismiss;
        self.backgroundColor = [UIColor blackColor];
        self.borderColor = [UIColor blackColor];
    }
    return self;
}

- (BOOL)isValid {
    if (!self.label) {
        UA_LERR(@"In-app button infos require a label");
        return NO;
    }

    if (!self.identifier) {
        UA_LERR(@"In-app button infos require an identifier");
        return NO;
    }

    return YES;
}

@end

@implementation UAInAppMessageButtonInfo

- (instancetype)initWithBuilder:(UAInAppMessageButtonInfoBuilder *)builder {
    self = [super self];

    if (![builder isValid]) {
        UA_LDEBUG(@"UAInAppMessageButtonInfo instance could not be initialized, builder has missing or invalid parameters.");
        return nil;
    }

    if (self) {
        self.label = builder.label;
        self.identifier = builder.identifier;
        self.behavior = builder.behavior;
        self.backgroundColor = builder.backgroundColor;
        self.borderRadius = builder.borderRadius;
        self.borderColor = builder.borderColor;
        self.actions = builder.actions;
    }

    return self;
}

+ (nullable instancetype)buttonInfoWithBuilderBlock:(void(^)(UAInAppMessageButtonInfoBuilder *builder))builderBlock {
    UAInAppMessageButtonInfoBuilder *builder = [[UAInAppMessageButtonInfoBuilder alloc] init];

    if (builderBlock) {
        builderBlock(builder);
    }

    return [[UAInAppMessageButtonInfo alloc] initWithBuilder:builder];
}

+ (nullable instancetype)buttonInfoWithJSON:(id)json error:(NSError * _Nullable *)error {
    UAInAppMessageButtonInfoBuilder *builder = [[UAInAppMessageButtonInfoBuilder alloc] init];

    if (![json isKindOfClass:[NSDictionary class]]) {
        if (error) {
            NSString *msg = [NSString stringWithFormat:@"Attempted to deserialize invalid object: %@", json];
            *error =  [NSError errorWithDomain:UAInAppMessageButtonInfoDomain
                                          code:UAInAppMessageButtonInfoErrorCodeInvalidJSON
                                      userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return nil;
    }


    id labelDict = json[UAInAppMessageButtonInfoLabelKey];
    if (labelDict) {
        builder.label = [UAInAppMessageTextInfo textInfoWithJSON:labelDict error:error];
        if (!builder.label) {
            return nil;
        }
    }

    id identifierText = json[UAInAppMessageButtonInfoIdentifierKey];
    if (identifierText) {
        if (![identifierText isKindOfClass:[NSString class]]) {
            if (error) {
                NSString *msg = [NSString stringWithFormat:@"In-app message button identifier must be a string. Invalid value: %@", identifierText];
                *error =  [NSError errorWithDomain:UAInAppMessageButtonInfoDomain
                                              code:UAInAppMessageButtonInfoErrorCodeInvalidJSON
                                          userInfo:@{NSLocalizedDescriptionKey:msg}];
            }
            
            return nil;
        }

        builder.identifier = identifierText;
    }

    id behaviorContents = json[UAInAppMessageButtonInfoBehaviorKey];
    if (behaviorContents) {
        if (![behaviorContents isKindOfClass:[NSString class]]) {
            if (error) {
                NSString *msg = [NSString stringWithFormat:@"Behavior must be a string."];
                *error =  [NSError errorWithDomain:UAInAppMessageButtonInfoDomain
                                              code:UAInAppMessageButtonInfoErrorCodeInvalidJSON
                                          userInfo:@{NSLocalizedDescriptionKey:msg}];
            }
            return nil;
        }

       behaviorContents = [behaviorContents lowercaseString];

        if ([UAInAppMessageButtonInfoBehaviorCancelValue isEqualToString:behaviorContents]) {
            builder.behavior = UAInAppMessageButtonInfoBehaviorCancel;
        } else if ([UAInAppMessageButtonInfoBehaviorDismissValue isEqualToString:behaviorContents]) {
            builder.behavior = UAInAppMessageButtonInfoBehaviorDismiss;
        } else {
            if (error) {
                NSString *msg = [NSString stringWithFormat:@"Invalid in-app message button behavior: %@", behaviorContents];
                *error =  [NSError errorWithDomain:UAInAppMessageButtonInfoDomain
                                              code:UAInAppMessageButtonInfoErrorCodeInvalidJSON
                                          userInfo:@{NSLocalizedDescriptionKey:msg}];
            }

            return nil;
        }
    }

    id backgroundColorHex = json[UAInAppMessageButtonInfoBackgroundColorKey];
    if (backgroundColorHex) {
        if (![backgroundColorHex isKindOfClass:[NSString class]]) {
            if (error) {
                NSString *msg = [NSString stringWithFormat:@"In-app message button background color must be a hex string. Invalid value: %@", backgroundColorHex];
                *error =  [NSError errorWithDomain:UAInAppMessageButtonInfoDomain
                                              code:UAInAppMessageButtonInfoErrorCodeInvalidJSON
                                          userInfo:@{NSLocalizedDescriptionKey:msg}];
            }
            
            return nil;
        }
        builder.backgroundColor = [UAColorUtils colorWithHexString:backgroundColorHex];
    }

    id borderColorHex = json[UAInAppMessageButtonInfoBorderColorKey];
    if (borderColorHex) {
        if (![borderColorHex isKindOfClass:[NSString class]]) {
            if (error) {
                NSString *msg = [NSString stringWithFormat:@"In-app message button border color must be a hex string. Invalid value: %@", borderColorHex];
                *error =  [NSError errorWithDomain:UAInAppMessageButtonInfoDomain
                                              code:UAInAppMessageButtonInfoErrorCodeInvalidJSON
                                          userInfo:@{NSLocalizedDescriptionKey:msg}];
            }
            
            return nil;
        }
        builder.borderColor = [UAColorUtils colorWithHexString:borderColorHex];
    }

    id borderRadius = json[UAInAppMessageButtonInfoBorderRadiusKey];
    if (borderRadius) {
        if (![borderRadius isKindOfClass:[NSNumber class]]) {
            if (error) {
                NSString *msg = [NSString stringWithFormat:@"Button border radius must be a number. Invalid value: %@", borderRadius];
                *error =  [NSError errorWithDomain:UAInAppMessageButtonInfoDomain
                                              code:UAInAppMessageButtonInfoErrorCodeInvalidJSON
                                          userInfo:@{NSLocalizedDescriptionKey:msg}];
            }
            return nil;
        }
        builder.borderRadius = [borderRadius unsignedIntegerValue];
    }

    // Actions
    id actions = json[UAInAppMessageButtonInfoActionsKey];
    if (actions) {
        if (![actions isKindOfClass:[NSDictionary class]]) {
            if (error) {
                NSString *msg = [NSString stringWithFormat:@"Button actions payload must be a dictionary. Invalid value: %@", actions];
                *error =  [NSError errorWithDomain:UAInAppMessageButtonInfoDomain
                                              code:UAInAppMessageButtonInfoErrorCodeInvalidJSON
                                          userInfo:@{NSLocalizedDescriptionKey:msg}];
            }
            
            return nil;
        }
        builder.actions = actions;
    }

    if (![builder isValid]) {
        if (error) {
            NSString *msg = [NSString stringWithFormat:@"Invalid button info: %@", json];
            *error =  [NSError errorWithDomain:UAInAppMessageButtonInfoDomain
                                          code:UAInAppMessageButtonInfoErrorCodeInvalidJSON
                                      userInfo:@{NSLocalizedDescriptionKey:msg}];
        }

        return nil;
    }

    return [[UAInAppMessageButtonInfo alloc] initWithBuilder:builder];
}

- (NSDictionary *)toJSON {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];

    [json setValue:[self.label toJSON] forKey:UAInAppMessageButtonInfoLabelKey];
    [json setValue:self.identifier forKey:UAInAppMessageButtonInfoIdentifierKey];
    [json setValue:@(self.borderRadius) forKey:UAInAppMessageButtonInfoBorderRadiusKey];

    switch (self.behavior) {
        case UAInAppMessageButtonInfoBehaviorCancel:
            [json setValue:UAInAppMessageButtonInfoBehaviorCancelValue forKey:UAInAppMessageButtonInfoBehaviorKey];
            break;

        case UAInAppMessageButtonInfoBehaviorDismiss:
        default:
            [json setValue:UAInAppMessageButtonInfoBehaviorDismissValue forKey:UAInAppMessageButtonInfoBehaviorKey];
            break;
    }

    [json setValue:[UAColorUtils hexStringWithColor:self.borderColor] forKey:UAInAppMessageButtonInfoBorderColorKey];

    [json setValue:[UAColorUtils hexStringWithColor:self.backgroundColor] forKey:UAInAppMessageButtonInfoBackgroundColorKey];

    [json setValue:self.actions forKey:UAInAppMessageButtonInfoActionsKey];

    return [json copy];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[UAInAppMessageButtonInfo class]]) {
        return NO;
    }

    return [self isEqualToInAppMessageButtonInfo:(UAInAppMessageButtonInfo *)object];
}

- (BOOL)isEqualToInAppMessageButtonInfo:(UAInAppMessageButtonInfo *)info {

    if (self.label != info.label && ![self.label isEqual:info.label]) {
        return NO;
    }

    if (self.identifier != info.identifier && ![self.identifier isEqualToString:info.identifier]) {
        return NO;
    }

    if (self.behavior != info.behavior) {
        return NO;
    }

    if (self.backgroundColor != info.backgroundColor && ![[UAColorUtils hexStringWithColor:self.backgroundColor] isEqualToString:[UAColorUtils hexStringWithColor:info.backgroundColor]]) {
        return NO;
    }

    if (self.borderColor != info.borderColor && ![[UAColorUtils hexStringWithColor:self.borderColor] isEqualToString:[UAColorUtils hexStringWithColor:info.borderColor]]) {
        return NO;
    }

    if (self.actions != info.actions && ![self.actions isEqualToDictionary:info.actions]) {
        return NO;
    }

    return YES;
}

- (NSUInteger)hash {
    NSUInteger result = 1;
    result = 31 * result + [self.label hash];
    result = 31 * result + [self.identifier hash];
    result = 31 * result + self.behavior;
    result = 31 * result + [self.backgroundColor hash];
    result = 31 * result + [self.borderColor hash];
    result = 31 * result + [self.actions hash];

    return result;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<UAInAppMessageButtonInfo: %@>", [self toJSON]];
}

@end

NS_ASSUME_NONNULL_END

