//
//  APURLWithLabel.h
//  AddressBook
//
//  Created by Sergey Popov on 24.08.15.
//  Copyright (c) 2015 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APURLWithLabel : NSObject

@property (nonatomic, strong, readonly) NSString *URL;
@property (nonatomic, strong, readonly) NSString *label;

- (instancetype)initWithURL:(NSString *)URL label:(NSString *)label;

@end
