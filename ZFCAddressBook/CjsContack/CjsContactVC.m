//
//  CjsContactVC.m
//  ZFCAddressBook
//
//  Created by 周福昌 on 15/10/29.
//  Copyright © 2015年 ZFC. All rights reserved.
//

#import "CjsContactVC.h"
#import <AddressBook/AddressBook.h>
#import "CjsContack.h"
#import "CjsContackCell.h"
#import "pinyin.h"
#import "NSArray+FirstLetterArray.h"

@interface CjsContactVC ()<UITableViewDataSource,UITableViewDelegate>
{
    contactMessage _contactInfo;
}
@property (nonatomic, assign) ABAddressBookRef addressBookRef;
@property (nonatomic, retain) NSMutableArray *contacts;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *indexArray;

@end

@implementation CjsContactVC

-(NSMutableArray *)contacts
{
    if (!_contacts) {
        _contacts =[[NSMutableArray alloc] init];
    }
    return _contacts;
}

-(void)showOnViewController:(UIViewController *)target
{
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:self];
    [target presentViewController:nav animated:YES completion:nil];
}

-(void)setNav
{
    self.title  =@"手机联系人";
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor],NSForegroundColorAttributeName,
                                                                     [UIFont systemFontOfSize:20],NSFontAttributeName,nil]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:118/255.0 green:179/255.0 blue:183/255.0 alpha:1];
    [self setBack];
}

- (void)setBack
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:[UIImage imageNamed:@"nav_normal_back"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_select_back"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftItem:btn];
}

- (void)setLeftItem:(UIView *)view
{
    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //返回按钮加上一个空白按钮，适配titleview
    UIBarButtonItem * sepceItem =[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 29, 40)]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItems = @[leftItem,sepceItem];
}

-(void)back
{
//    if (self.navigationController.navigationController) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    [self createMainTableView];
    [self getContackData];
    [self setNav];
}

-(void)createMainTableView
{
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [self.view addSubview:_tableView];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.indexArray objectAtIndex:section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    lab.backgroundColor = [UIColor grayColor];
    lab.text = [self.indexArray objectAtIndex:section];
    lab.textColor = [UIColor whiteColor];
    return lab;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contacts[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden =@"CjsContackCell";
    CjsContackCell *cell =[tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"CjsContackCell" owner:self options:nil] lastObject];
    }
    CjsContack *contact = [self.contacts[indexPath.section] objectAtIndex:indexPath.row];
    cell.nameLabel.text =contact.fullName;
    cell.teleLabel.text =contact.phone;
    cell.headImageView.image = contact.image;
    return cell;
}

-(void)getTheContactInfo:(contactMessage)contactInfo
{
    _contactInfo =[contactInfo copy];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CjsContack *contact = [self.contacts[indexPath.section] objectAtIndex:indexPath.row];
    if (_contactInfo) {
        //过滤特殊字符
        NSString * phone = nil;
        if (contact.phone) {
            phone =[self RemoveSpecialCharacter:contact.phone];
        }
        //过滤开头是86的固定存法
        if ([phone hasPrefix:@"86"]) {
            phone = [phone substringFromIndex:2];
        }
        _contactInfo(contact.fullName,phone);
        [self back];
    }
}

//过滤指定字符串   里面的指定字符根据自己的需要添加
-(NSString*)RemoveSpecialCharacter: (NSString *)str {
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"+-"]];
    if (urgentRange.location != NSNotFound)
    {
        return [self RemoveSpecialCharacter:[str stringByReplacingCharactersInRange:urgentRange withString:@""]];
    }
    return str;
}

-(void)getContackData
{
    CFErrorRef error;
    _addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    
    ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getContactsFromAddressBook];
            });
        } else {
            // TODO: Show alert
        }
    });
}

-(void)getContactsFromAddressBook
{
    CFErrorRef error = NULL;
    self.contacts = [[NSMutableArray alloc]init];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBook) {
        NSArray *allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSMutableArray *mutableContacts = [NSMutableArray arrayWithCapacity:allContacts.count];
        
        NSUInteger i = 0;
        for (i = 0; i<[allContacts count]; i++)
        {
            CjsContack *contact = [[CjsContack alloc] init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            contact.recordId = ABRecordGetRecordID(contactPerson);
            
            // Get first and last names
            NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            // Set Contact properties
            contact.firstName = firstName;
            contact.lastName = lastName;
            
            // Get mobile number
            ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            contact.phone = [self getMobilePhoneProperty:phonesRef];
            if(phonesRef) {
                CFRelease(phonesRef);
            }
            
            // Get image if it exists
            NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
            contact.image = [UIImage imageWithData:imgData];
            if (!contact.image) {
                contact.image = [UIImage imageNamed:@"my_head"];
            }
            
            [mutableContacts addObject:contact];
        }
        
        if(addressBook) {
            CFRelease(addressBook);
        }
    
        [self sequenceTheAdressNameWithContacts:mutableContacts];
        
        [self.tableView reloadData];
    }
    else
    {
        NSLog(@"Error");
        
    }
}

- (NSString *)getMobilePhoneProperty:(ABMultiValueRef)phonesRef
{
    for (int i=0; i < ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if(currentPhoneLabel) {
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
            
            if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
        }
        if(currentPhoneLabel) {
            CFRelease(currentPhoneLabel);
        }
        if(currentPhoneValue) {
            CFRelease(currentPhoneValue);
        }
    }
    
    return nil;
}


#pragma mark - 按名字首字母排序(核心算法 可适用于所有其他model汉字首字母排序 替换数据源)
-(void)sequenceTheAdressNameWithContacts:(NSArray *)contacts
{
/*****************  排序算法 *****************************/
    //存储姓名数组
    NSMutableArray *nameArray =[[NSMutableArray alloc] initWithCapacity:contacts.count];
    for (CjsContack*contact in contacts) {
        [nameArray addObject:contact.fullName];
        }
    //存储排序后的姓名数组(二维数组)
    NSDictionary *sequenceName =[nameArray sortedArrayUsingFirstLetter];
    //因为字典是无须的 将所有的key取出来排序
    self.indexArray =[[sequenceName allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in self.indexArray) {
        NSLog(@"key -- >%@",key);
        //拿到每组字母开头的全名数组
        NSArray *array =[sequenceName objectForKey:key];
        //循环遍历匹配通讯录数组 重组排序整个通讯录
        //特殊字符开头的姓名首字母
        if ([key isEqualToString:@"#"]) {
            NSMutableArray *tmp =[NSMutableArray new];
            //先遍历添加一遍所有没名字的联系人
            for (CjsContack *contact in contacts) {
                if ([contact.fullName isEqualToString:@""]) {
                    [tmp addObject:contact];
                }
            }
            //再遍历匹配添加特殊字符名字首字母的联系人
            for (NSString *fullName in array) {
                if (![fullName isEqualToString:@""]) {
                    for (CjsContack *contact in contacts) {
                        if ([fullName isEqualToString:contact.fullName]) {
                            [tmp addObject:contact];
                        }
                    }
                }
            }
            [self.contacts addObject:tmp];
        }else{
            //A~Z开头的姓名首字符
            NSMutableArray *tmp =[NSMutableArray new];
            for (NSString *fullName in array) {
                for (CjsContack *contact in contacts) {
                    if ([fullName isEqualToString:contact.fullName]) {
                        [tmp addObject:contact];
                    }
                }
            }
            [self.contacts addObject:tmp];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
