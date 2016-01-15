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

- (id)initWithAddressDictionary:(NSDictionary *)dictionary
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
