//
//  CjsContack.m
//  ZFCAddressBook
//
//  Created by 周福昌 on 15/10/29.
//  Copyright © 2015年 ZFC. All rights reserved.
//

#import "CjsContack.h"

@implementation CjsContack

#pragma mark - NSObject - Creating, Copying, and Deallocating Objects

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:attributes];
    }
    
    return self;
}

#pragma mark - NSKeyValueCoding Protocol

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.recordId = [value integerValue];
    } else if ([key isEqualToString:@"firstName"]) {
        self.firstName = value;
    } else if ([key isEqualToString:@"lastName"]) {
        self.lastName = value;
    } else if ([key isEqualToString:@"phone"]) {
        self.phone = value;
    }else if ([key isEqualToString:@"email"]) {
        self.email = value;
    }else if ([key isEqualToString:@"image"]) {
        self.image = value;
    }else if ([key isEqualToString:@"isSelected"]) {
        self.selected = [value boolValue];
    }else if ([key isEqualToString:@"date"]) {
        // TODO: Fix
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        self.date = [dateFormatter dateFromString:value];
    } else if ([key isEqualToString:@"dateUpdated"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
        self.dateUpdated = [dateFormatter dateFromString:value];
    }
}

- (NSString *)fullName {
//    if (self.firstName == nil) {
//        self.firstName = @"";
//    }
//    if (self.lastName == nil) {
//        self.lastName = @"";
//    }
//    return [NSString stringWithFormat:@"%@%@", self.firstName, self.lastName];
    if(self.firstName != nil && self.lastName != nil) {
        return [NSString stringWithFormat:@"%@%@", self.lastName, self.firstName];
    } else if (self.lastName != nil) {
        return self.lastName;
    } else if (self.firstName != nil) {
        return self.firstName;
    } else {
        return @"";
    }
}

@end
