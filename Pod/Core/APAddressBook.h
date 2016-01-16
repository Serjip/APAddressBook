//
//  APAddressBook.h
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APTypes.h"

@protocol APAddressBookDelegate;

@interface APAddressBook : NSObject

@property (nonatomic, readonly) APAddressBookAccess access;
@property (nonatomic, assign) APContactField fieldsMask;
@property (nonatomic, assign) APContactField mergeFieldsMask;
@property (nonatomic, strong) NSArray<NSSortDescriptor *> *sortDescriptors;
@property (nonatomic, weak) id<APAddressBookDelegate> delegate;

+ (APAddressBookAccess)access;

- (void)loadContacts;

- (void)startObserveChanges;
- (void)stopObserveChanges;

@end

@protocol APAddressBookDelegate <NSObject>

@optional
- (void)addressBookDidChnage:(APAddressBook *)addressBook;
- (void)addressBook:(APAddressBook *)addressBook didLoadContacts:(NSArray<APContact *> *)contacts;
- (void)addressBook:(APAddressBook *)addressBook didFailLoadContacts:(NSError *)error;
- (BOOL)addressBook:(APAddressBook *)addressBook shouldAddContact:(APContact *)contact;

@end
