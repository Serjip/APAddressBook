//
//  APLabel_Private.h
//  AddressBook
//
//  Created by Sergey P on 16.01.16.
//  Copyright © 2016 alterplay. All rights reserved.
//

#import "APLabel.h"
#import <AddressBook/AddressBook.h>

@interface APLabel ()

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index;

@end
