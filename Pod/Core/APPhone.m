//
//  APPhone.m
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APPhone.h"

@implementation APPhone

- (instancetype)initWithPhone:(NSString *)phone label:(NSString *)label
{
    self = [super init];
    if(self)
    {
        _phone = phone;
        _label = label;
    }
    return self;
}

- (BOOL)isEqualToPhoneWithLabel:(APPhone *)phoneWithLabel
{
    return ([phoneWithLabel.phone isEqualToString:self.phone] && [phoneWithLabel.label isEqualToString:self.label]);
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    
    if (! [object isKindOfClass:[APPhone class]])
    {
        return NO;
    }
    
    return [self isEqualToPhoneWithLabel:object];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@)", self.phone, self.label];
}

@end
