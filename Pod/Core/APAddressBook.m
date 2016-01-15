//
//  APAddressBook.m
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "APAddressBook.h"
#import "APContact.h"

@interface APAddressBook ()

@property (nonatomic, readonly) dispatch_queue_t localQueue;
@property (nonatomic, copy) void (^changeCallback)();

@end

@implementation APAddressBook {
@private
    ABAddressBookRef _addressBookRef;
}

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        CFErrorRef errorRef = NULL;
        _addressBookRef = ABAddressBookCreateWithOptions(NULL, &errorRef);
        if (errorRef)
        {
            NSLog(@"%@", (__bridge_transfer NSString *)CFErrorCopyFailureReason(errorRef));
            return nil;
        }
        NSString *name = [NSString stringWithFormat:@"com.alterplay.addressbook.%ld", (long)self.hash];
        _localQueue = dispatch_queue_create([name cStringUsingEncoding:NSUTF8StringEncoding], NULL);
        self.fieldsMask = APContactFieldDefault;
    }
    return self;
}

- (void)dealloc
{
    [self stopObserveChanges];
    if (_addressBookRef)
    {
        CFRelease(_addressBookRef);
    }
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_localQueue);
#endif
}

#pragma mark - public

+ (APAddressBookAccess)access
{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status)
    {
        case kABAuthorizationStatusDenied:
        case kABAuthorizationStatusRestricted:
            return APAddressBookAccessDenied;

        case kABAuthorizationStatusAuthorized:
            return APAddressBookAccessGranted;

        default:
            return APAddressBookAccessUnknown;
    }
}

- (void)loadContacts:(void (^)(NSArray *contacts, NSError *error))callbackBlock
{
    [self loadContactsOnQueue:dispatch_get_main_queue() completion:callbackBlock];
}

- (void)loadContactsOnQueue:(dispatch_queue_t)queue completion:(void (^)(NSArray *contacts, NSError *error))completionBlock
{
    APContactField fieldMask = self.fieldsMask;
    APContactField mergeFieldMask = self.mergeFieldsMask;
    NSArray *descriptors = self.sortDescriptors;
    APContactFilterBlock filterBlock = self.filterBlock;

	ABAddressBookRequestAccessWithCompletion(_addressBookRef, ^(bool granted, CFErrorRef errorRef)
	{
	    dispatch_async(self.localQueue, ^
        {
	        NSArray *array = nil;
	        NSError *error = nil;
            if (granted)
            {
                CFArrayRef peopleArrayRef = ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
                NSUInteger contactCount = (NSUInteger)CFArrayGetCount(peopleArrayRef);
                NSMutableArray *contacts = [NSMutableArray arrayWithCapacity:contactCount];
                NSMutableSet *linkedContactsIDs = [NSMutableSet set];
                
                for (NSUInteger i = 0; i < contactCount; i++)
                {
                    ABRecordRef recordRef = CFArrayGetValueAtIndex(peopleArrayRef, i);
                    
                    //
                    // Checking already added contacts
                    //
                    if ([linkedContactsIDs containsObject:@(ABRecordGetRecordID(recordRef))])
                    {
                        continue;
                    }
                    
                    APContact *contact = [[APContact alloc] initWithRecordRef:recordRef fieldMask:fieldMask];
                    if (!filterBlock || filterBlock(contact))
                    {
                        [contacts addObject:contact];
                    }
                    
                    CFArrayRef linkedPeopleArrayRef = ABPersonCopyArrayOfAllLinkedPeople(recordRef);
                    NSUInteger linkedCount = (NSUInteger)CFArrayGetCount(linkedPeopleArrayRef);
                    
                    if (linkedCount > 1)
                    {
                        // Merge linked contact info
                        //
                        for (NSUInteger j = 0; j < linkedCount; j++)
                        {
                            ABRecordRef linkedRecordRef = CFArrayGetValueAtIndex(linkedPeopleArrayRef, j);
                            
                            // Don't merge the same contact
                            //
                            if (linkedRecordRef == recordRef)
                            {
                                continue;
                            }
                            
                            if (mergeFieldMask)
                            {
                                [contact mergeLinkedRecordRef:linkedRecordRef fieldMask:mergeFieldMask];
                                [linkedContactsIDs addObject:@(ABRecordGetRecordID(linkedRecordRef))];
                            }
                        }
                    }
                    
                    CFRelease(linkedPeopleArrayRef);
                }
                [contacts sortUsingDescriptors:descriptors];
                array = contacts.copy;
                CFRelease(peopleArrayRef);
            }
            else if (errorRef)
            {
                error = (__bridge NSError *)errorRef;
            }

            dispatch_async(queue, ^
            {
                if (completionBlock)
                {
                    completionBlock(array, error);
                }
            });
		});
	});
}

- (void)startObserveChangesWithCallback:(void (^)())callback
{
    NSParameterAssert(callback);
    if (callback)
    {
        if (!self.changeCallback)
        {
            ABAddressBookRegisterExternalChangeCallback(_addressBookRef, APAddressBookExternalChangeCallback, (__bridge void *)(self));
        }
        self.changeCallback = callback;
    }
}

- (void)stopObserveChanges
{
    if (self.changeCallback)
    {
        self.changeCallback = nil;
        ABAddressBookUnregisterExternalChangeCallback(_addressBookRef, APAddressBookExternalChangeCallback, (__bridge void *)(self));
    }
}

#pragma mark - external change callback

static void APAddressBookExternalChangeCallback(ABAddressBookRef __unused addressBookRef, CFDictionaryRef __unused info, void *context)
{
    ABAddressBookRevert(addressBookRef);
    APAddressBook *addressBook = (__bridge APAddressBook *)(context);
    addressBook.changeCallback ? addressBook.changeCallback() : nil;
}

@end
