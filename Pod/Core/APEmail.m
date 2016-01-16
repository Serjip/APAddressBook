//
//  APEmail.m
//  AddressBook
//
//  Created by Sergey P on 16.01.16.
//  Copyright © 2016 alterplay. All rights reserved.
//

#import "APEmail.h"
#import "APLabel_Private.h"

@implementation APEmail

#pragma mark - Lifecycle

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super initWithMultiValue:multiValue index:index];
    if(self)
    {
        _address = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, index);
    }
    return self;
}

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _address = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(address))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_address forKey:NSStringFromSelector(@selector(address))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    APEmail *copy = [super copyWithZone:zone];
    if (copy)
    {
        copy->_address = [self.address copyWithZone:zone];
    }
    return copy;
}

#pragma mark - Equality

- (BOOL)isEqualToAddress:(APEmail *)email
{
    return ([email.address isEqualToString:self.address] && [email.originalLabel isEqualToString:self.originalLabel]);
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    
    if (! [object isKindOfClass:[APEmail class]])
    {
        return NO;
    }
    
    return [self isEqualToAddress:object];
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@)", self.address, self.originalLabel];
}

@end
