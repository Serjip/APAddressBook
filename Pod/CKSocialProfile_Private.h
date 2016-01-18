//
//  APSocialProfile_Private.h
//  AddressBook
//
//  Created by Sergey P on 16.01.16.
//  Copyright © 2016 alterplay. All rights reserved.
//

#import "APSocialProfile.h"

@class CNSocialProfile;

@interface APSocialProfile ()

- (instancetype)initWithSocialDictionary:(NSDictionary *)dictionary  NS_DEPRECATED(10_6, 10_9, 6_0, 9_0);
- (instancetype)initWithSocialProfile:(CNSocialProfile *)socialProfile NS_AVAILABLE(10_10, 9_0);

@end
