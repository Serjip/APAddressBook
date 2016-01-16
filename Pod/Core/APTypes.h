//
//  APTypes.h
//  AddressBook
//
//  Created by Alexey Belkevich on 1/11/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#ifndef AddressBook_APTypes_h
#define AddressBook_APTypes_h

@class APContact;

typedef NS_ENUM(NSUInteger, APAddressBookAccess)
{
    APAddressBookAccessUnknown = 0,
    APAddressBookAccessGranted = 1,
    APAddressBookAccessDenied  = 2
};

typedef BOOL(^APContactFilterBlock)(APContact *contact);

typedef NS_OPTIONS(NSUInteger , APContactField)
{
    APContactFieldFirstName        = 1 << 0,
    APContactFieldLastName         = 1 << 1,
    APContactFieldCompany          = 1 << 2,
    APContactFieldPhones           = 1 << 3,
    APContactFieldEmails           = 1 << 4,
    APContactFieldPhoto            = 1 << 5,
    APContactFieldThumbnail        = 1 << 6,
    APContactFieldCompositeName    = 1 << 7,
    APContactFieldAddresses        = 1 << 8,
    APContactFieldRecordID         = 1 << 9,
    APContactFieldCreationDate     = 1 << 10,
    APContactFieldModificationDate = 1 << 11,
    APContactFieldMiddleName       = 1 << 12,
    APContactFieldSocialProfiles   = 1 << 13,
    APContactFieldNote             = 1 << 14,
    APContactFieldURLs             = 1 << 15,
    APContactFieldDefault          = APContactFieldFirstName | APContactFieldLastName |
                                     APContactFieldPhones,
    APContactFieldAll              = NSUIntegerMax
};

#endif
