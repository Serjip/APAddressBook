//
//  APSocialContact.m
//  SyncBook
//
//  Created by David on 2014-08-01.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import "APSocialProfile_Private.h"
#import <AddressBook/AddressBook.h>

@implementation APSocialProfile

#pragma mark - Lifecycle

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

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _URL = [aDecoder decodeObjectOfClass:[NSURL class] forKey:NSStringFromSelector(@selector(URL))];
        _username = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(username))];
        _userIdentifier = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(userIdentifier))];
        _socialNetwork = (NSUInteger)[aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(socialNetwork))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_URL forKey:NSStringFromSelector(@selector(URL))];
    [aCoder encodeObject:_username forKey:NSStringFromSelector(@selector(username))];
    [aCoder encodeObject:_userIdentifier forKey:NSStringFromSelector(@selector(userIdentifier))];
    [aCoder encodeInteger:_socialNetwork forKey:NSStringFromSelector(@selector(socialNetwork))];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - Equality

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

#pragma mark - Private

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
