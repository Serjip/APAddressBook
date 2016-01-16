//
//  APContact.h
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APTypes.h"

@class APURL, APPhone, APSocialProfile, APAddress, APEmail;

@interface APContact : NSObject

@property (nonatomic, strong, readonly) NSString *firstName;
@property (nonatomic, strong, readonly) NSString *middleName;
@property (nonatomic, strong, readonly) NSString *lastName;
@property (nonatomic, strong, readonly) NSString *compositeName;
@property (nonatomic, strong, readonly) NSString *company;
@property (nonatomic, strong, readonly) NSString *jobTitle;
@property (nonatomic, strong, readonly) NSArray<APPhone *> *phones;
@property (nonatomic, strong, readonly) NSArray<APEmail *> *emails;
@property (nonatomic, strong, readonly) NSArray<APAddress *> *addresses;
@property (nonatomic, strong, readonly) UIImage *photo;
@property (nonatomic, strong, readonly) UIImage *thumbnail;
@property (nonatomic, strong, readonly) NSNumber *recordID;
@property (nonatomic, strong, readonly) NSDate *creationDate;
@property (nonatomic, strong, readonly) NSDate *modificationDate;
@property (nonatomic, strong, readonly) NSArray<APSocialProfile *> *socialProfiles;
@property (nonatomic, strong, readonly) NSString *note;
@property (nonatomic, strong, readonly) NSArray<APURL *> *URLs;

@end
