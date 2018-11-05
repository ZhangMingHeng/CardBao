//
//  ContactData.m
//  CardBao
//
//  Created by zhangmingheng on 2018/10/15.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "ContactData.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface ContactData()<CNContactPickerDelegate>

// 当前的viewController
@property (nonatomic, strong) UIViewController *parentViewController;

// block
@property (nonatomic) void (^requestContact)(ContactData * _Nonnull manage, NSInteger code ,NSDictionary *_Nonnull result);
@property (nonatomic) void (^requestPhoneNum)(ContactData * _Nonnull manage, NSInteger code ,NSString *_Nonnull result);

@end

@implementation ContactData

+(instancetype)shareInstance {
    static ContactData *manage =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage =[[ContactData alloc]init];
    });
    return manage;
}
#pragma mark 请求通讯录权限
- (void)requestContactAuthorAfter:(UIViewController* _Nonnull) viewController
                                    resultBlock:(requestContact _Nonnull) requestContact {
    
    // 判断当前设备的系统是否支持
    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0){
        
        self.parentViewController = viewController;
        self.requestContact       = requestContact;
        
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusNotDetermined) {
            CNContactStore *store = [[CNContactStore alloc] init];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
                if (granted) {
                    NSLog(@"成功授权");
                    //有通讯录权限-- 进行下一步操作
                    [self openContact:requestContact];
                }else {
                    NSLog(@"授权失败");
                    [viewController.navigationController popViewControllerAnimated:YES];
                }
            }];
        } else if(status == CNAuthorizationStatusRestricted) {
            NSLog(@"用户拒绝");
            [self showAlertViewAboutNotAuthorAccessContact];
        } else if (status == CNAuthorizationStatusDenied) {
            NSLog(@"用户拒绝");
            [self showAlertViewAboutNotAuthorAccessContact];
        } else if (status == CNAuthorizationStatusAuthorized) {//已经授权
            //有通讯录权限-- 进行下一步操作
            [self openContact:requestContact];
        }
    } else {
        [Helper alertMessage:@"请升级iOS系统至9.0及以上" addToView:self.parentViewController.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [viewController.navigationController popViewControllerAnimated:YES];
        });
        
    }
    
    
}
- (void)requestContactUI:(UIViewController* _Nonnull) viewController resultBlock:(requestPhoneNum _Nonnull) requestPhoneNum {
    // 判断当前设备的系统是否支持
    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0){
        
        self.parentViewController = viewController;
        self.requestPhoneNum      = requestPhoneNum;
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusNotDetermined) {
            CNContactStore *store = [[CNContactStore alloc] init];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
                if (granted) {
                    NSLog(@"成功授权");
                    //有通讯录权限-- 进行下一步操作
                    [self setUI];
                }else {
                    NSLog(@"授权失败");
                    [viewController.navigationController popViewControllerAnimated:YES];
                }
            }];
        } else if(status == CNAuthorizationStatusRestricted) {
            NSLog(@"用户拒绝");
            [self showAlertViewAboutNotAuthorAccessContact];
        } else if (status == CNAuthorizationStatusDenied) {
            NSLog(@"用户拒绝");
            [self showAlertViewAboutNotAuthorAccessContact];
        } else if (status == CNAuthorizationStatusAuthorized) {//已经授权
            //有通讯录权限-- 进行下一步操作
            [self setUI];
        }
    } else {
        [Helper alertMessage:@"请升级iOS系统至9.0及以上" addToView:self.parentViewController.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [viewController.navigationController popViewControllerAnimated:YES];
        });
        
    }
}
-(void)setUI {
    CNContactPickerViewController * picker = [CNContactPickerViewController new];
    picker.delegate = self;
    picker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
    [self.parentViewController presentViewController: picker animated:YES completion:nil];
}
/**
 逻辑:  在该代理方法中会调出手机通讯录界面, 选中联系人的手机号, 会将联系人姓名以及手机号赋值给界面上的TEXT1和TEXT2两个UITextFiled上.
 功能: 调用手机通讯录界面, 获取联系人姓名以及电话号码.
 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    
//    CNContact *contact = contactProperty.contact;
//    NSLog(@"%@",contactProperty);
//    NSLog(@"givenName: %@, familyName: %@", contact.givenName, contact.familyName);
    
//    self.TEXT1.text = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
    if (![contactProperty.value isKindOfClass:[CNPhoneNumber class]]) {
        NSLog(@"提示用户选择11位的手机号");
        self.requestPhoneNum(self, 1, @"");
        return;
    }
    
    CNPhoneNumber *phoneNumber = contactProperty.value;
    NSString * string = phoneNumber.stringValue;
    string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
//    NSString *phoneStr = [[string componentsSeparatedByCharactersInSet:setToRemove]componentsJoinedByString:@""];
    if (![Helper justMobile:string]) {
        
        NSLog(@"提示用户选择11位的手机号");
        self.requestPhoneNum(self, 1, string);
        return;
    }
    self.requestPhoneNum(self, 0, string);
    NSLog(@"-=-=%@",string);
}
- (void)openContact:(requestContact _Nonnull) requestContact{
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
//    NSMutableArray *contactArray = [NSMutableArray new];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
//        NSLog(@"-------------------------------------------------------");
        
        //拼接姓名
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        
        NSArray *phoneNumbers = contact.phoneNumbers;
        
        //        CNPhoneNumber  * cnphoneNumber = contact.phoneNumbers[0];
        
        //        NSString * phoneNumber = cnphoneNumber.stringValue;
        
        for (CNLabeledValue *labelValue in phoneNumbers) {
            //遍历一个人名下的多个电话号码
//            NSString *label = labelValue.label;
//            NSString *    phoneNumber = labelValue.value;
            CNPhoneNumber *phoneNumber = labelValue.value;
            
            NSString * string = phoneNumber.stringValue ;
            
            //去掉电话中的特殊字符
            string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSLog(@"姓名=%@, 电话号码是=%@", nameStr, string);
            
            requestContact(self, 0, @{@"name":nameStr,@"phone":string,@"relationship":@"朋友"});
        }
        
            *stop = YES; // 停止循环，相当于break；

        
    }];
    
}




//提示没有通讯录权限
- (void)showAlertViewAboutNotAuthorAccessContact{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请授权通讯录权限"
                                          message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许App访问你的通讯录"
                                          preferredStyle: UIAlertControllerStyleAlert];

    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.parentViewController.navigationController popViewControllerAnimated:YES];
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] openURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    [alertController addAction:OKAction];
    [alertController addAction:[UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.parentViewController.navigationController popViewControllerAnimated:YES];
    }]];
    [self.parentViewController presentViewController:alertController animated:YES completion:nil];
}

@end
