//
//  APPhone.m
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APPhone_Private.h"

@implementation APPhone

#pragma mark - Lifecycle

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if(self)
    {
        _phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, index);
        
        CFStringRef label = ABMultiValueCopyLabelAtIndex(multiValue, index);
        if (label)
        {
            _label = (__bridge NSString *)label;
            _localizedLabel = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel(label);
            CFRelease(label);
        }
    }
    return self;
}

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _phone = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(phone))];
        _label = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(label))];
        _localizedLabel = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(localizedLabel))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_phone forKey:NSStringFromSelector(@selector(phone))];
    [aCoder encodeObject:_label forKey:NSStringFromSelector(@selector(label))];
    [aCoder encodeObject:_localizedLabel forKey:NSStringFromSelector(@selector(localizedLabel))];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    APPhone *copy = [[[self class] alloc] init];
    if (copy)
    {
        copy->_phone = [self.phone copyWithZone:zone];
        copy->_label = [self.label copyWithZone:zone];
        copy->_localizedLabel = [self.localizedLabel copyWithZone:zone];
    }
    return copy;
}

#pragma mark - Equality

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

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@)", self.phone, self.label];
}

@end
