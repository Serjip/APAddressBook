//
//  APContact.h
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "APTypes.h"

@interface APContact : NSObject

@property (nonatomic, assign, readonly) APContactField fieldMask;
@property (nonatomic, strong, readonly) NSString *firstName;
@property (nonatomic, strong, readonly) NSString *middleName;
@property (nonatomic, strong, readonly) NSString *lastName;
@property (nonatomic, strong, readonly) NSString *compositeName;
@property (nonatomic, strong, readonly) NSString *company;
@property (nonatomic, strong, readonly) NSArray *phones;
@property (nonatomic, strong, readonly) NSArray *phonesWithLabels;
@property (nonatomic, strong, readonly) NSArray *emails;
@property (nonatomic, strong, readonly) NSArray *addresses;
@property (nonatomic, strong, readonly) UIImage *photo;
@property (nonatomic, strong, readonly) UIImage *thumbnail;
@property (nonatomic, strong, readonly) NSNumber *recordID;
@property (nonatomic, strong, readonly) NSDate *creationDate;
@property (nonatomic, strong, readonly) NSDate *modificationDate;
@property (nonatomic, strong, readonly) NSArray *socialProfiles;
@property (nonatomic, strong, readonly) NSString *note;
@property (nonatomic, strong, readonly) NSArray *URLsWithLabels;

- (instancetype)initWithRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask;
- (void)mergeLinkedRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask;

@end
