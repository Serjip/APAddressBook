//
//  APContact_Private.h
//  AddressBook
//
//  Created by Sergey P on 16.01.16.
//  Copyright © 2016 alterplay. All rights reserved.
//

#import "APContact.h"
#import <AddressBook/AddressBook.h>

@class CNContact;

@interface APContact ()

@property (nonatomic, assign, readonly) APContactField fieldMask;

- (instancetype)initWithRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask NS_DEPRECATED(10_6, 10_10, 6_0, 9_0);
- (void)mergeLinkedRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask NS_DEPRECATED(10_6, 10_10, 6_0, 9_0);

- (instancetype)initWithContact:(CNContact *)contact fieldMask:(APContactField)fieldMask NS_AVAILABLE(10_10, 9_0);
- (void)mergeLinkedContact:(CNContact *)contact fieldMask:(APContactField)fieldMask NS_AVAILABLE(10_10, 9_0);

@end
