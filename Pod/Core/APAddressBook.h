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

@property (nonatomic, weak) id<APAddressBookDelegate> delegate;
@property (nonatomic, assign) APContactField fieldsMask;
@property (nonatomic, assign) APContactField mergeFieldsMask;
@property (nonatomic, copy) APContactFilterBlock filterBlock;
@property (nonatomic, strong) NSArray *sortDescriptors;

+ (APAddressBookAccess)access;

- (void)loadContacts:(void (^)(NSArray *contacts, NSError *error))callbackBlock;
- (void)loadContactsOnQueue:(dispatch_queue_t)queue completion:(void (^)(NSArray *contacts, NSError *error))completionBlock;

- (void)startObserveChangesWithCallback:(void (^)())callback;
- (void)stopObserveChanges;

@end

@protocol APAddressBookDelegate <NSObject>

@optional
- (void)addressBookDidChnage:(APAddressBook *)addressBook;
- (void)addressBook:(APAddressBook *)addressBook didLoadContacts:(NSArray *)contacts;

@end
