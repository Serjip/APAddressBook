//
//  APAddress.m
//  AddressBook
//
//  Created by Alexey Belkevich on 4/19/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "APAddress.h"

@implementation APAddress

#pragma mark - Lifecycle

- (instancetype)initWithAddressDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _street = dictionary[(__bridge NSString *)kABPersonAddressStreetKey];
        _city = dictionary[(__bridge NSString *)kABPersonAddressCityKey];
        _state = dictionary[(__bridge NSString *)kABPersonAddressStateKey];
        _zip = dictionary[(__bridge NSString *)kABPersonAddressZIPKey];
        _country = dictionary[(__bridge NSString *)kABPersonAddressCountryKey];
        _countryCode = dictionary[(__bridge NSString *)kABPersonAddressCountryCodeKey];
    }
    return self;
}

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _street = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(street))];
        _city = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(city))];
        _state = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(state))];
        _zip = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(zip))];
        _country = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(country))];
        _countryCode = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(countryCode))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_street forKey:NSStringFromSelector(@selector(street))];
    [aCoder encodeObject:_city forKey:NSStringFromSelector(@selector(city))];
    [aCoder encodeObject:_state forKey:NSStringFromSelector(@selector(state))];
    [aCoder encodeObject:_zip forKey:NSStringFromSelector(@selector(zip))];
    [aCoder encodeObject:_country forKey:NSStringFromSelector(@selector(country))];
    [aCoder encodeObject:_countryCode forKey:NSStringFromSelector(@selector(countryCode))];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - Equality

- (BOOL)isEqualToAddress:(APAddress *)address
{
    if (! [self.street isEqualToString:address.street])
    {
        return NO;
    }
    if (! [self.city isEqualToString:address.city])
    {
        return NO;
    }
    if (! [self.state isEqualToString:address.state])
    {
        return NO;
    }
    if (! [self.zip isEqualToString:address.zip])
    {
        return NO;
    }
    if (! [self.country isEqualToString:address.country])
    {
        return NO;
    }
    if (! [self.countryCode isEqualToString:address.countryCode])
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
    
    if (! [object isKindOfClass:[APAddress class]])
    {
        return NO;
    }
    
    return [self isEqualToAddress:object];
}

@end
