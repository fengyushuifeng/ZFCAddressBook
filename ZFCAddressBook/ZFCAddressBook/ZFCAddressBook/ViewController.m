//
//  ViewController.m
//  ZFCAddressBook
//
//  Created by 周福昌 on 15/10/29.
//  Copyright © 2015年 ZFC. All rights reserved.
//

#import "ViewController.h"
#import "CjsContactVC.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)push:(id)sender {
    CjsContactVC *vc =[[CjsContactVC alloc] init];
    [vc showOnViewController:self];
    [vc getTheContactInfo:^(NSString *name, NSString *telephone) {
        NSLog(@"%@%@",name,telephone);
    }];
    
//    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
//    peoplePicker.peoplePickerDelegate = self;
//    [self presentViewController:peoplePicker animated:YES completion:nil];
//    [peoplePicker release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
