//
//  APAddress.h
//  AddressBook
//
//  Created by Alexey Belkevich on 4/19/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APAddress : NSObject <NSSecureCoding>

@property (nonatomic, strong, readonly) NSString *street;
@property (nonatomic, strong, readonly) NSString *city;
@property (nonatomic, strong, readonly) NSString *state;
@property (nonatomic, strong, readonly) NSString *zip;
@property (nonatomic, strong, readonly) NSString *country;
@property (nonatomic, strong, readonly) NSString *countryCode;

@end
