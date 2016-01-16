//
//  APSocialContact.m
//  SyncBook
//
//  Created by David on 2014-08-01.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import "APSocialProfile_Private.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/CNSocialProfile.h>

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
        _service = dictionary[serviceKey];
        _serviceType = [self socialNetworkTypeFromString:_service];
    }
    return self;
}

- (instancetype)initWithSocialProfile:(CNSocialProfile *)socialProfile
{
    self = [super init];
    if (self)
    {
        _URL = [NSURL URLWithString:socialProfile.urlString];
        _username = socialProfile.username;
        _userIdentifier = socialProfile.userIdentifier;
        _service = socialProfile.service;
        _serviceType = [self socialNetworkTypeFromString:socialProfile.service];
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
        _service = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(service))];
        _serviceType = (NSUInteger)[aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(serviceType))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_URL forKey:NSStringFromSelector(@selector(URL))];
    [aCoder encodeObject:_username forKey:NSStringFromSelector(@selector(username))];
    [aCoder encodeObject:_userIdentifier forKey:NSStringFromSelector(@selector(userIdentifier))];
    [aCoder encodeObject:_service forKey:NSStringFromSelector(@selector(service))];
    [aCoder encodeInteger:(NSInteger)_serviceType forKey:NSStringFromSelector(@selector(serviceType))];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    APSocialProfile *copy = [[[self class] alloc] init];
    if (copy)
    {
        copy->_URL = [self.URL copyWithZone:zone];
        copy->_username = [self.username copyWithZone:zone];
        copy->_userIdentifier = [self.userIdentifier copyWithZone:zone];
        copy->_service = [self.service copyWithZone:zone];
        copy->_serviceType = self.serviceType;
    }
    return copy;
}

#pragma mark - Equality

- (BOOL)isEqualToSocialProfile:(APSocialProfile *)socialProfile
{
    if (self.serviceType != socialProfile.serviceType)
    {
        return NO;
    }
    
    if (! [self.service isEqualToString:socialProfile.service])
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

- (APSocialProfileService)socialNetworkTypeFromString:(NSString *)string
{
    if ([string isEqualToString:@"facebook"])
    {
        return APSocialProfileServiceFacebook;
    }
    else if ([string isEqualToString:@"twitter"])
    {
        return APSocialProfileServiceTwitter;
    }
    else if ([string isEqualToString:@"linkedin"])
    {
        return APSocialProfileServiceLinkedIn;
    }
    else if ([string isEqualToString:@"flickr"])
    {
        return APSocialProfileServiceFlickr;
    }
    else if ([string isEqualToString:@"myspace"])
    {
        return APSocialProfileServiceMyspace;
    }
    else
    {
        return APSocialProfileServiceUnknown;
    }
}

@end
