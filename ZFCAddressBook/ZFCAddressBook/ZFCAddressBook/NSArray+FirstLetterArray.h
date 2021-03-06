//
//  NSArray+FirstLetterArray.h
//  ZFCAddressBook
//
//  Created by 周福昌 on 15/11/10.
//  Copyright © 2015年 ZFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FirstLetterArray)

/**
 *	通过需要按【首字母分类】的 【姓名数组】 调用此函数
 *
 *	@return	A：以a打头的姓名或者单词
 B：以b打头的姓名或者单词
 */

- (NSDictionary *)sortedArrayUsingFirstLetter;

@end
