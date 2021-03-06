//
//  APSocialContact.m
//  SyncBook
//
//  Created by David on 2014-08-01.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import "APSocialProfile.h"
#import <AddressBook/AddressBook.h>

@implementation APSocialProfile

#pragma mark - life cycle

- (instancetype)initWithSocialDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        NSString *URLKey = (__bridge_transfer NSString *)kABPersonSocialProfileURLKey;
        NSString *usernameKey = (__bridge_transfer NSString *)kABPersonSocialProfileUsernameKey;
        NSString *userIdKey = (__bridge_transfer NSString *)kABPersonSocialProfileUserIdentifierKey;
        NSString *serviceKey = (__bridge_transfer NSString *)kABPersonSocialProfileServiceKey;
       
        _URL = [NSURL URLWithString:dictionary[URLKey]];
        _username = dictionary[usernameKey];
        _userIdentifier = dictionary[userIdKey];
        _socialNetwork = [self socialNetworkTypeFromString:dictionary[serviceKey]];
    }
    return self;
}

- (BOOL)isEqualToSocialProfile:(APSocialProfile *)socialProfile
{
    if (self.socialNetwork != socialProfile.socialNetwork)
    {
        return NO;
    }
    
    if (! [self.username isEqualToString:socialProfile.username])
    {
        return NO;
    }
    
    if (! [self.userIdentifier isEqualToString:socialProfile.userIdentifier])
    {
        return NO;
    }
    
    if (! [self.URL.absoluteString isEqualToString:socialProfile.URL.absoluteString])
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    
    if (! [object isKindOfClass:[APSocialProfile class]])
    {
        return NO;
    }
    
    return [self isEqualToSocialProfile:object];
}

#pragma mark - private

- (APSocialNetworkType)socialNetworkTypeFromString:(NSString *)string
{
    if ([string isEqualToString:@"facebook"])
    {
        return APSocialNetworkFacebook;
    }
    else if ([string isEqualToString:@"twitter"])
    {
        return APSocialNetworkTwitter;
    }
    else if ([string isEqualToString:@"linkedin"])
    {
        return APSocialNetworkLinkedIn;
    }
    else
    {
        return APSocialNetworkUnknown;
    }
}

@end
