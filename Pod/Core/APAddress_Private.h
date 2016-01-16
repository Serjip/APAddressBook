//
//  APAddress_Private.h
//  AddressBook
//
//  Created by Sergey P on 16.01.16.
//  Copyright © 2016 alterplay. All rights reserved.
//

#import "APAddress.h"
#import <Contacts/CNPostalAddress.h>

@interface APAddress ()

- (instancetype)initWithAddressDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithPostalAddress:(CNPostalAddress *)address NS_AVAILABLE(10_10, 9_0);

@end
