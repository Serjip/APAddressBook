//
//  APURL.m
//  AddressBook
//
//  Created by Sergey Popov on 24.08.15.
//  Copyright (c) 2015 alterplay. All rights reserved.
//

#import "APURL.h"

@implementation APURL

- (instancetype)initWithURL:(NSString *)URL label:(NSString *)label
{
    self = [super init];
    if(self)
    {
        _URL = URL;
        _label = label;
    }
    return self;
}

- (BOOL)isEqualToURLWithLabel:(APURL *)URLWithLabel
{
    return ([URLWithLabel.URL isEqualToString:self.URL] && [URLWithLabel.label isEqualToString:self.label]);
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
    
    return [self isEqualToURLWithLabel:object];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@)", self.URL, self.label];
}

@end
