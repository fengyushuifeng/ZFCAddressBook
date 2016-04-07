//
//  CjsContack.h
//  ZFCAddressBook
//
//  Created by 周福昌 on 15/10/29.
//  Copyright © 2015年 ZFC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CjsContack : NSObject

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (NSString *)fullName;

@property (nonatomic, assign) NSInteger recordId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, getter = isSelected) BOOL selected;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *dateUpdated;

@end
