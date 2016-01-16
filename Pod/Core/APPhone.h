//
//  APPhone.h
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPhone : NSObject <NSSecureCoding, NSCopying>

@property (nonatomic, strong, readonly) NSString *phone;
@property (nonatomic, strong, readonly) NSString *label;
@property (nonatomic, strong, readonly) NSString *localizedLabel;

@end
