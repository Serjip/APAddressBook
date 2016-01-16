//
//  APContact_Private.h
//  AddressBook
//
//  Created by Sergey P on 16.01.16.
//  Copyright © 2016 alterplay. All rights reserved.
//

#import "APContact.h"
#import <AddressBook/AddressBook.h>

@interface APContact ()

@property (nonatomic, assign, readonly) APContactField fieldMask;

- (instancetype)initWithRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask;
- (void)mergeLinkedRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask;

@end
