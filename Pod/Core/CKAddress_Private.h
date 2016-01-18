//
//  APAddress_Private.h
//  AddressBook
//
//  Created by Sergey P on 16.01.16.
//  Copyright © 2016 alterplay. All rights reserved.
//

#import "APAddress.h"

@class CNPostalAddress;

@interface APAddress ()

- (instancetype)initWithAddressDictionary:(NSDictionary *)dictionary NS_DEPRECATED(10_6, 10_10, 6_0, 9_0);
- (instancetype)initWithPostalAddress:(CNPostalAddress *)address NS_AVAILABLE(10_10, 9_0);

@end
