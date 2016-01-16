//
//  APLabel_Private.h
//  AddressBook
//
//  Created by Sergey P on 16.01.16.
//  Copyright © 2016 alterplay. All rights reserved.
//

#import "APLabel.h"
#import <AddressBook/AddressBook.h>

@class CNLabeledValue;

@interface APLabel ()

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index NS_DEPRECATED(10_6, 10_10, 6_0, 9_0);
- (instancetype)initWithLabledValue:(CNLabeledValue *)labledValue NS_AVAILABLE(10_10, 9_0);

@end
