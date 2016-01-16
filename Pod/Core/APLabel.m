//
//  APLabel.m
//  AddressBook
//
//  Created by Sergey P on 16.01.16.
//  Copyright © 2016 alterplay. All rights reserved.
//

#import "APLabel_Private.h"

@implementation APLabel

#pragma mark - Lifecycle

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if(self)
    {        
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
        _label = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(label))];
        _localizedLabel = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(localizedLabel))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
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
    APLabel *copy = [[[self class] alloc] init];
    if (copy)
    {
        copy->_label = [self.label copyWithZone:zone];
        copy->_localizedLabel = [self.localizedLabel copyWithZone:zone];
    }
    return copy;
}

#pragma mark - Equal

- (BOOL)isEqualToLabel:(APLabel *)label
{
    return [label.label isEqualToString:self.label];
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    
    if (! [object isKindOfClass:[APLabel class]])
    {
        return NO;
    }
    
    return [self isEqualToLabel:object];
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"%p %@", self, self.label];
}

@end
