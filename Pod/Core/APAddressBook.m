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

@implementation APAddressBook {
@private
    ABAddressBookRef _addressBookRef;
    dispatch_queue_t _addressBookQueue;
}

#pragma mark - Properties

- (APAddressBookAccess)access
{
    return [APAddressBook access];
}

#pragma mark - Lifecycle

- (instancetype)init
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
        _addressBookQueue = dispatch_queue_create([name cStringUsingEncoding:NSUTF8StringEncoding], NULL);
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
    dispatch_release(_addressBookQueue);
#endif
}

#pragma mark - Public

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

- (void)loadContacts
{
    APContactField fieldMask = self.fieldsMask;
    APContactField mergeFieldMask = self.mergeFieldsMask;
    NSArray *descriptors = [self.sortDescriptors copy];
    
    ABAddressBookRequestAccessWithCompletion(_addressBookRef, ^(bool granted, CFErrorRef errorRef) {
        dispatch_async(_addressBookQueue, ^{
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
                    
                    // Checking already added contacts
                    if ([linkedContactsIDs containsObject:@(ABRecordGetRecordID(recordRef))])
                    {
                        continue;
                    }
                    
                    APContact *contact = [[APContact alloc] initWithRecordRef:recordRef fieldMask:fieldMask];
                    if (! [self.delegate respondsToSelector:@selector(addressBook:shouldAddContact:)] || [self.delegate addressBook:self shouldAddContact:contact])
                    {
                        [contacts addObject:contact];
                    }
                    
                    CFArrayRef linkedPeopleArrayRef = ABPersonCopyArrayOfAllLinkedPeople(recordRef);
                    NSUInteger linkedCount = (NSUInteger)CFArrayGetCount(linkedPeopleArrayRef);
                    
                    if (linkedCount > 1)
                    {
                        // Merge linked contact info
                        for (NSUInteger j = 0; j < linkedCount; j++)
                        {
                            ABRecordRef linkedRecordRef = CFArrayGetValueAtIndex(linkedPeopleArrayRef, j);
                            
                            // Don't merge the same contact
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
                array = [NSArray arrayWithArray:contacts];
                CFRelease(peopleArrayRef);
            }
            else if (errorRef)
            {
                error = (__bridge NSError *)errorRef;
            }
            
            if (error)
            {
                if ([self.delegate respondsToSelector:@selector(addressBook:didFailLoadContacts:)])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate addressBook:self didFailLoadContacts:error];
                    });
                }
            }
            else
            {
                if ([self.delegate respondsToSelector:@selector(addressBook:didLoadContacts:)])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate addressBook:self didLoadContacts:array];
                    });
                }
            }
        });
    });
}

- (void)startObserveChanges
{
    [self stopObserveChanges];
    
    ABAddressBookRegisterExternalChangeCallback(_addressBookRef, APAddressBookExternalChangeCallback, (__bridge void *)(self));
}

- (void)stopObserveChanges
{
    ABAddressBookUnregisterExternalChangeCallback(_addressBookRef, APAddressBookExternalChangeCallback, (__bridge void *)(self));
}

#pragma mark - external change callback

static void APAddressBookExternalChangeCallback(ABAddressBookRef addressBookRef, CFDictionaryRef __unused info, void *context)
{
    ABAddressBookRevert(addressBookRef);
    APAddressBook *addressBook = (__bridge APAddressBook *)(context);
    
    if ([addressBook.delegate respondsToSelector:@selector(addressBookDidChnage:)])
    {
        [addressBook.delegate addressBookDidChnage:addressBook];
    }
}

@end
