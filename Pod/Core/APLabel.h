//
//  APLabel.h
//  AddressBook
//
//  Created by Sergey P on 16.01.16.
//  Copyright © 2016 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APLabel : NSObject <NSSecureCoding, NSCopying>

@property (nonatomic, strong, readonly) NSString *label;
@property (nonatomic, strong, readonly) NSString *localizedLabel;

@end
