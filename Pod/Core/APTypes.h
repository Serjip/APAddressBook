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

typedef NS_OPTIONS(NSUInteger , APContactField)
{
    APContactFieldFirstName        = 1 << 0,
    APContactFieldLastName         = 1 << 1,
    APContactFieldCompany          = 1 << 2,
    APContactFieldJobTitle         = 1 << 3,
    APContactFieldPhones           = 1 << 4,
    APContactFieldEmails           = 1 << 5,
    APContactFieldPhoto            = 1 << 6,
    APContactFieldThumbnail        = 1 << 7,
    APContactFieldCompositeName    = 1 << 8,
    APContactFieldAddresses        = 1 << 9,
    APContactFieldRecordID         = 1 << 10,
    APContactFieldCreationDate     = 1 << 11,
    APContactFieldModificationDate = 1 << 12,
    APContactFieldMiddleName       = 1 << 13,
    APContactFieldSocialProfiles   = 1 << 14,
    APContactFieldNote             = 1 << 15,
    APContactFieldURLs             = 1 << 16,
    APContactFieldDefault          = APContactFieldFirstName | APContactFieldLastName |
                                     APContactFieldPhones,
    APContactFieldAll              = NSUIntegerMax
};

#endif
