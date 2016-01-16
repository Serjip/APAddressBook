//
//  APContact.m
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APContact_Private.h"

#import "APLabel_Private.h"

#import "APAddress.h"
#import "APSocialProfile.h"

#import "APURL.h"
#import "APPhone.h"
#import "APEmail.h"

@implementation APContact

#pragma mark - life cycle

- (instancetype)initWithRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask
{
    self = [super init];
    if (self)
    {
        _fieldMask = fieldMask;
        if (fieldMask & APContactFieldFirstName)
        {
            _firstName = [self stringProperty:kABPersonFirstNameProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldMiddleName)
        {
            _middleName = [self stringProperty:kABPersonMiddleNameProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldLastName)
        {
            _lastName = [self stringProperty:kABPersonLastNameProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldCompositeName)
        {
            _compositeName = (__bridge_transfer NSString *)ABRecordCopyCompositeName(recordRef);
        }
        if (fieldMask & APContactFieldCompany)
        {
            _company = [self stringProperty:kABPersonOrganizationProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldJobTitle)
        {
            _jobTitle = [self stringProperty:kABPersonJobTitleProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldPhones)
        {
            _phones = [self arrayObjectsOfClass:[APPhone class] ofProperty:kABPersonPhoneProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldEmails)
        {
            _emails = [self arrayObjectsOfClass:[APEmail class] ofProperty:kABPersonPhoneProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldPhoto)
        {
            _photo = [self imagePropertyFullSize:YES fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldThumbnail)
        {
            _thumbnail = [self imagePropertyFullSize:NO fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldAddresses)
        {
            NSMutableArray *addresses = [[NSMutableArray alloc] init];
            NSArray *array = [self arrayProperty:kABPersonAddressProperty fromRecord:recordRef];
            for (NSDictionary *dictionary in array)
            {
                APAddress *address = [[APAddress alloc] initWithAddressDictionary:dictionary];
                [addresses addObject:address];
            }
            _addresses = addresses;
        }
        if (fieldMask & APContactFieldRecordID)
        {
            _recordID = [NSNumber numberWithInteger:ABRecordGetRecordID(recordRef)];
        }
        if (fieldMask & APContactFieldCreationDate)
        {
            _creationDate = [self dateProperty:kABPersonCreationDateProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldModificationDate)
        {
            _modificationDate = [self dateProperty:kABPersonModificationDateProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldSocialProfiles)
        {
            NSMutableArray *profiles = [[NSMutableArray alloc] init];
            NSArray *array = [self arrayProperty:kABPersonSocialProfileProperty fromRecord:recordRef];
            for (NSDictionary *dictionary in array)
            {
                APSocialProfile *profile = [[APSocialProfile alloc] initWithSocialDictionary:dictionary];
                [profiles addObject:profile];
            }
            
            _socialProfiles = profiles;
        }
        if (fieldMask & APContactFieldNote)
        {
            _note = [self stringProperty:kABPersonNoteProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldURLs)
        {
            _URLs = [self arrayObjectsOfClass:[APURL class] ofProperty:kABPersonURLProperty fromRecord:recordRef];
        }
    }
    return self;
}

- (void)mergeLinkedRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask
{
    if (fieldMask & APContactFieldFirstName)
    {
        if (! self.firstName)
        {
            _firstName = [self stringProperty:kABPersonFirstNameProperty fromRecord:recordRef];
        }
    }
    
    if (fieldMask & APContactFieldMiddleName)
    {
        if (! self.middleName)
        {
            _middleName = [self stringProperty:kABPersonMiddleNameProperty fromRecord:recordRef];
        }
    }
    
    if (fieldMask & APContactFieldLastName)
    {
        if (! self.lastName)
        {
            _lastName = [self stringProperty:kABPersonLastNameProperty fromRecord:recordRef];
        }
    }
    
    if (fieldMask & APContactFieldCompositeName)
    {
        if (! self.compositeName)
        {
            _compositeName = (__bridge_transfer NSString *)ABRecordCopyCompositeName(recordRef);
        }
    }
    
    if (fieldMask & APContactFieldCompany)
    {
        if (! self.company ||! self.company.length)
        {
            _company = [self stringProperty:kABPersonOrganizationProperty fromRecord:recordRef];
        }
    }
    
    if (fieldMask & APContactFieldJobTitle)
    {
        if (! self.jobTitle ||! self.jobTitle.length)
        {
            _jobTitle = [self stringProperty:kABPersonJobTitleProperty fromRecord:recordRef];
        }
    }
    
    if (fieldMask & APContactFieldPhones)
    {
        NSMutableArray *phones = [NSMutableArray arrayWithArray:self.phones];
        NSArray *phonesToMerge = [self arrayObjectsOfClass:[APPhone class] ofProperty:kABPersonPhoneProperty fromRecord:recordRef];
        
        for (APPhone *p in phonesToMerge)
        {
            if ([self.phones containsObject:p])
            {
                continue;
            }
            [phones addObject:p];
        }
        
        _phones = phones;
    }
    
    if (fieldMask & APContactFieldEmails)
    {
        NSMutableArray *emails = [NSMutableArray arrayWithArray:self.emails];
        NSArray *emailsToMerge =  [self arrayObjectsOfClass:[APEmail class] ofProperty:kABPersonEmailProperty fromRecord:recordRef];
        
        for (APEmail *email in emailsToMerge)
        {
            if ([self.emails containsObject:email])
            {
                continue;
            }
            
            [emails addObject:email];
        }
        
        _emails = emails;
    }

    if (fieldMask & APContactFieldPhoto)
    {
        if (! self.photo)
        {
            _photo = [self imagePropertyFullSize:YES fromRecord:recordRef];
        }
    }
    
    if (fieldMask & APContactFieldThumbnail)
    {
        if (! self.thumbnail)
        {
            _thumbnail = [self imagePropertyFullSize:NO fromRecord:recordRef];
        }
    }
    
    if (fieldMask & APContactFieldAddresses)
    {
        NSMutableArray *addresses = [NSMutableArray arrayWithArray:self.addresses];
        NSArray *array = [self arrayProperty:kABPersonAddressProperty fromRecord:recordRef];
        for (NSDictionary *dictionary in array)
        {
            APAddress *address = [[APAddress alloc] initWithAddressDictionary:dictionary];
            
            if ([self.addresses containsObject:address])
            {
                continue;
            }
            
            [addresses addObject:address];
        }
        _addresses = addresses;
    }

    if (fieldMask & APContactFieldSocialProfiles)
    {
        NSMutableArray *profiles = [NSMutableArray arrayWithArray:self.socialProfiles];
        NSArray *array = [self arrayProperty:kABPersonSocialProfileProperty fromRecord:recordRef];
        for (NSDictionary *dictionary in array)
        {
            APSocialProfile *profile = [[APSocialProfile alloc] initWithSocialDictionary:dictionary];
            
            if ([self.socialProfiles containsObject:profile])
            {
                continue;
            }
            
            [profiles addObject:profile];
        }
        
        _socialProfiles = profiles;
    }

    if (fieldMask & APContactFieldNote)
    {
        if (! self.note || ! self.note.length)
        {
            _note = [self stringProperty:kABPersonNoteProperty fromRecord:recordRef];
        }
    }
    
    if (fieldMask & APContactFieldURLs)
    {
        NSMutableArray *URLs = [NSMutableArray arrayWithArray:self.URLs];
        
        NSArray *URLsToMerge = [self arrayObjectsOfClass:[APURL class] ofProperty:kABPersonURLProperty fromRecord:recordRef];
        
        for (APURL *Uwl in URLsToMerge)
        {
            if ([self.URLs containsObject:Uwl])
            {
                continue;
            }
            [URLs addObject:Uwl];
        }
        
        _URLs = URLs;
    }
}

#pragma mark - Private

- (NSString *)stringProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    CFTypeRef valueRef = (ABRecordCopyValue(recordRef, property));
    return (__bridge_transfer NSString *)valueRef;
}

- (NSArray *)arrayProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self enumerateMultiValueOfProperty:property fromRecord:recordRef
                              withBlock:^(ABMultiValueRef multiValue, CFIndex index)
    {
        id value = (__bridge_transfer id)ABMultiValueCopyValueAtIndex(multiValue, index);
        if (value)
        {
            [array addObject:value];
        }
    }];
    return [NSArray arrayWithArray:array];
}

- (NSDate *)dateProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    CFDateRef dateRef = (ABRecordCopyValue(recordRef, property));
    return (__bridge_transfer NSDate *)dateRef;
}

- (UIImage *)imagePropertyFullSize:(BOOL)isFullSize fromRecord:(ABRecordRef)recordRef
{
    ABPersonImageFormat format = isFullSize ? kABPersonImageFormatOriginalSize :
                                 kABPersonImageFormatThumbnail;
    NSData *data = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(recordRef, format);
    return [UIImage imageWithData:data scale:UIScreen.mainScreen.scale];
}

- (void)enumerateMultiValueOfProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
                            withBlock:(void (^)(ABMultiValueRef multiValue, CFIndex index))block
{
    ABMultiValueRef multiValue = ABRecordCopyValue(recordRef, property);
    if (multiValue)
    {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++)
        {
            block(multiValue, i);
        }
        CFRelease(multiValue);
    }
}

- (NSArray *)arrayObjectsOfClass:(Class)class ofProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    NSMutableArray *objects = [NSMutableArray array];
    [self enumerateMultiValueOfProperty:kABPersonPhoneProperty fromRecord:recordRef withBlock:^(ABMultiValueRef multiValue, CFIndex index) {
        id obj = [[class alloc] initWithMultiValue:multiValue index:index];
        if (obj)
        {
            [objects addObject:obj];
        }
    }];
    return [NSArray arrayWithArray:objects];
}

@end
