//
//  APPhone.m
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APPhone.h"
#import "APLabel_Private.h"

@implementation APPhone

#pragma mark - Lifecycle

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super initWithMultiValue:multiValue index:index];
    if(self)
    {
        _phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, index);
    }
    return self;
}

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _phone = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(phone))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_phone forKey:NSStringFromSelector(@selector(phone))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    APPhone *copy = [super copyWithZone:zone];
    if (copy)
    {
        copy->_phone = [self.phone copyWithZone:zone];
    }
    return copy;
}

#pragma mark - Equality

- (BOOL)isEqualToPhone:(APPhone *)phone
{
    return ([phone.phone isEqualToString:self.phone] && [phone.originalLabel isEqual:self.originalLabel]);
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
    
    return [self isEqualToPhone:object];
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@)", self.phone, self.originalLabel];
}

@end
