//
//  APPhone.h
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPhone : NSObject

@property (nonatomic, strong, readonly) NSString *phone;
@property (nonatomic, strong, readonly) NSString *label;

- (instancetype)initWithPhone:(NSString *)phone label:(NSString *)label;

@end
