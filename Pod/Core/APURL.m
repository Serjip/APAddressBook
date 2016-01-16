//
//  APURL.m
//  AddressBook
//
//  Created by Sergey Popov on 24.08.15.
//  Copyright (c) 2015 alterplay. All rights reserved.
//

#import "APURL.h"
#import "APLabel_Private.h"

@implementation APURL

#pragma mark - Lifecycle

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super initWithMultiValue:multiValue index:index];
    if(self)
    {
        _URLString = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, index);
    }
    return self;
}

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _URLString = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(URLString))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_URLString forKey:NSStringFromSelector(@selector(URLString))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    APURL *copy = [super copyWithZone:zone];
    if (copy)
    {
        copy->_URLString = [self.URLString copyWithZone:zone];
    }
    return copy;
}

#pragma mark - Equality

- (BOOL)isEqualToURL:(APURL *)URL
{
    return ([URL.URLString isEqualToString:self.URLString] && [URL.label isEqualToString:self.label]);
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    
    if (! [object isKindOfClass:[APURL class]])
    {
        return NO;
    }
    
    return [self isEqualToURL:object];
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@)", self.URLString, self.label];
}

@end
