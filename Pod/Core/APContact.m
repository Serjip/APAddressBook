//
//  APContact.m
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APContact_Private.h"

#import "APLabel_Private.h"

#import "APAddress_Private.h"
#import "APSocialProfile_Private.h"

#import "APURL.h"
#import "APPhone.h"
#import "APEmail.h"

#import <Contacts/CNContact.h>

@implementation APContact

#pragma mark - Lifecycle

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


- (instancetype)initWithContact:(CNContact *)contact fieldMask:(APContactField)fieldMask
{
    self = [super init];
    if (self)
    {
        _fieldMask = fieldMask;
        
        if (fieldMask & APContactFieldFirstName)
        {
            _firstName = contact.givenName;
        }
        if (fieldMask & APContactFieldMiddleName)
        {
            _middleName = contact.middleName;
        }
        if (fieldMask & APContactFieldLastName)
        {
            _lastName = contact.familyName;
        }
        if (fieldMask & APContactFieldCompositeName)
        {
#warning Composite name
            _compositeName = contact.givenName;
        }
        if (fieldMask & APContactFieldCompany)
        {
            _company = contact.organizationName;
        }
        if (fieldMask & APContactFieldJobTitle)
        {
            _jobTitle = contact.jobTitle;
        }
        if (fieldMask & APContactFieldPhones)
        {
            NSMutableArray *phones = [[NSMutableArray alloc] initWithCapacity:contact.phoneNumbers.count];
            for (CNPhoneNumber *phoneNumber in contact.phoneNumbers)
            {
                [phones addObject:[[APPhone alloc] initWithLabledValue:phoneNumber]];
            }
            _phones = phones;
        }
        if (fieldMask & APContactFieldEmails)
        {
            NSMutableArray *emails = [[NSMutableArray alloc] initWithCapacity:contact.emailAddresses.count];
            for (CNLabeledValue *email in contact.emailAddresses)
            {
#warning Emails
                [emails addObject:[[APEmail alloc] initWithLabledValue:email]];
            }
            _emails = emails;
        }
        if (fieldMask & APContactFieldPhoto)
        {
            _photo = [UIImage imageWithData:contact.imageData scale:[UIScreen mainScreen].scale];
        }
        if (fieldMask & APContactFieldThumbnail)
        {
            _thumbnail = [UIImage imageWithData:contact.thumbnailImageData scale:[UIScreen mainScreen].scale];
        }
        if (fieldMask & APContactFieldAddresses)
        {
            NSMutableArray *addresses = [[NSMutableArray alloc] initWithCapacity:contact.postalAddresses.count];
            for (CNPostalAddress *addr in contact.postalAddresses)
            {
                [addresses addObject:[[APAddress alloc] initWithPostalAddress:addr]];
            }
            _addresses = addresses;
        }
        if (fieldMask & APContactFieldRecordID)
        {
#warning Check the record id
            _recordID = @(contact.identifier.integerValue);
        }
        if (fieldMask & APContactFieldCreationDate)
        {
#warning Date
        }
        if (fieldMask & APContactFieldModificationDate)
        {
#warning Date
        }
        if (fieldMask & APContactFieldSocialProfiles)
        {
            NSMutableArray *profiles = [[NSMutableArray alloc] init];
            for (CNSocialProfile *profile in contact.socialProfiles)
            {
                [profiles addObject:[[APSocialProfile alloc] initWithSocialProfile:profile]];
            }
            _socialProfiles = profiles;
        }
        if (fieldMask & APContactFieldNote)
        {
            _note = contact.note;
        }
        if (fieldMask & APContactFieldURLs)
        {
            NSMutableArray *URLs = [[NSMutableArray alloc] initWithCapacity:contact.urlAddresses.count];
            for (CNLabeledValue *url in contact.postalAddresses)
            {
#warning URLs
                [URLs addObject:[[APURL alloc] initWithLabledValue:url]];
            }
            _URLs = URLs;
        }
    }
    return self;
}

- (void)mergeLinkedContact:(CNContact *)contact fieldMask:(APContactField)fieldMask
{
#warning Merge it
}

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _firstName = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(firstName))];
        _middleName = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(middleName))];
        _lastName = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(lastName))];
        _compositeName = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(compositeName))];
        _company = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(company))];
        _jobTitle = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(jobTitle))];
        _phones = [aDecoder decodeObjectOfClass:[NSArray class] forKey:NSStringFromSelector(@selector(phones))];
        _emails = [aDecoder decodeObjectOfClass:[NSArray class] forKey:NSStringFromSelector(@selector(emails))];
        _addresses = [aDecoder decodeObjectOfClass:[NSArray class] forKey:NSStringFromSelector(@selector(addresses))];
        _recordID = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(recordID))];
        _creationDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(creationDate))];
        _modificationDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(modificationDate))];
        _socialProfiles = [aDecoder decodeObjectOfClass:[NSArray class] forKey:NSStringFromSelector(@selector(socialProfiles))];
        _note = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(note))];
        _URLs = [aDecoder decodeObjectOfClass:[NSArray class] forKey:NSStringFromSelector(@selector(URLs))];
        
        NSData *thumbData = [aDecoder decodeObjectOfClass:[NSData class] forKey:NSStringFromSelector(@selector(thumbnail))];
        _thumbnail = [[UIImage alloc] initWithData:thumbData];
        
        NSData *photoData = [aDecoder decodeObjectOfClass:[NSData class] forKey:NSStringFromSelector(@selector(photo))];
        _photo = [[UIImage alloc] initWithData:photoData];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_firstName forKey:NSStringFromSelector(@selector(firstName))];
    [aCoder encodeObject:_middleName forKey:NSStringFromSelector(@selector(middleName))];
    [aCoder encodeObject:_lastName forKey:NSStringFromSelector(@selector(lastName))];
    [aCoder encodeObject:_compositeName forKey:NSStringFromSelector(@selector(compositeName))];
    [aCoder encodeObject:_company forKey:NSStringFromSelector(@selector(company))];
    [aCoder encodeObject:_jobTitle forKey:NSStringFromSelector(@selector(jobTitle))];
    [aCoder encodeObject:_phones forKey:NSStringFromSelector(@selector(phones))];
    [aCoder encodeObject:_emails forKey:NSStringFromSelector(@selector(emails))];
    [aCoder encodeObject:_addresses forKey:NSStringFromSelector(@selector(addresses))];
    [aCoder encodeObject:_recordID forKey:NSStringFromSelector(@selector(recordID))];
    [aCoder encodeObject:_creationDate forKey:NSStringFromSelector(@selector(creationDate))];
    [aCoder encodeObject:_modificationDate forKey:NSStringFromSelector(@selector(modificationDate))];
    [aCoder encodeObject:_socialProfiles forKey:NSStringFromSelector(@selector(socialProfiles))];
    [aCoder encodeObject:_note forKey:NSStringFromSelector(@selector(note))];
    [aCoder encodeObject:_URLs forKey:NSStringFromSelector(@selector(URLs))];

    [aCoder encodeObject:UIImagePNGRepresentation(_thumbnail) forKey:NSStringFromSelector(@selector(thumbnail))];
    [aCoder encodeObject:UIImagePNGRepresentation(_photo) forKey:NSStringFromSelector(@selector(photo))];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    APContact *copy = [[[self class] alloc] init];
    if (copy)
    {
        copy->_firstName = [self.firstName copyWithZone:zone];
        copy->_middleName = [self.middleName copyWithZone:zone];
        copy->_lastName = [self.lastName copyWithZone:zone];
        copy->_compositeName = [self.compositeName copyWithZone:zone];
        copy->_company = [self.company copyWithZone:zone];
        copy->_jobTitle = [self.jobTitle copyWithZone:zone];
        copy->_phones = [self.phones copyWithZone:zone];
        copy->_emails = [self.emails copyWithZone:zone];
        copy->_addresses = [self.addresses copyWithZone:zone];
        copy->_recordID = [self.recordID copyWithZone:zone];
        copy->_creationDate = [self.creationDate copyWithZone:zone];
        copy->_modificationDate = [self.modificationDate copyWithZone:zone];
        copy->_socialProfiles = [self.socialProfiles copyWithZone:zone];
        copy->_note = [self.note copyWithZone:zone];
        copy->_URLs = [self.URLs copyWithZone:zone];
        
        // Dont copy the images
        copy->_thumbnail = self.thumbnail;
        copy->_photo = self.photo;
    }
    return copy;
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
    ABPersonImageFormat format = isFullSize ? kABPersonImageFormatOriginalSize : kABPersonImageFormatThumbnail;
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
