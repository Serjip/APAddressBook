//
//  APSocialContact.h
//  SyncBook
//
//  Created by David on 2014-08-01.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, APSocialNetworkType)
{
    APSocialNetworkUnknown =    0,
    APSocialNetworkFacebook =   1,
    APSocialNetworkTwitter =    2,
    APSocialNetworkLinkedIn =   3,
};

@interface APSocialProfile : NSObject

@property (nonatomic, assign, readonly) APSocialNetworkType socialNetwork;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *userIdentifier;
@property (nonatomic, strong, readonly) NSURL *URL;

- (instancetype)initWithSocialDictionary:(NSDictionary *)dictionary;

@end
