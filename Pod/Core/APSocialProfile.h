//
//  APSocialContact.h
//  SyncBook
//
//  Created by David on 2014-08-01.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, APSocialProfileService)
{
    APSocialProfileServiceUnknown  = 0,
    APSocialProfileServiceFacebook = 1,
    APSocialProfileServiceTwitter  = 2,
    APSocialProfileServiceLinkedIn = 3,
    APSocialProfileServiceFlickr   = 4,
    APSocialProfileServiceMyspace  = 5,
};

@interface APSocialProfile : NSObject <NSCopying, NSSecureCoding>

@property (nonatomic, strong, readonly) NSURL *URL;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *userIdentifier;
@property (nonatomic, strong, readonly) NSString *service;
@property (nonatomic, assign, readonly) APSocialProfileService serviceType;

@end
