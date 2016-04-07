//
//  CjsContactVC.h
//  ZFCAddressBook
//
//  Created by 周福昌 on 15/10/29.
//  Copyright © 2015年 ZFC. All rights reserved.
//

/****************
 15/10/29
 自定义通讯录 1.0版 需导入<AddressBook>系统库
 CjsContactVC *vc =[[CjsContactVC alloc] init];
 [vc showOnViewController:self];
 [vc getTheContactInfo:^(NSString *name, NSString *telephone) {
 NSLog(@"%@%@",name,telephone);
 }];
 1.1版 给联系人按姓首字母排序 添加右边索引
 1.2版 优化了排序方法 兼容了姓名首字母是其他特殊字符的崩溃问题 特殊字符同意归#组
 1.3版 过滤返回时手机号特殊字符 +86  -
 15/11/10
 1.4版 修复了重组排序时姓名为空的bug 避免了循环添加多次相同的没名字联系人 设置头像圆角
****************/

#import <UIKit/UIKit.h>

typedef void (^contactMessage)(NSString *name,NSString *telephone);

@interface CjsContactVC : UIViewController

///弹出通讯录
-(void)showOnViewController:(UIViewController *)target;
///获取联系人姓名 手机号码
-(void)getTheContactInfo:(contactMessage)contactInfo;

@end
