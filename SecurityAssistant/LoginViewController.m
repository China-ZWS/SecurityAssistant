//
//  LoginViewController.m
//  SecurityAssistant
//
//  Created by talkweb on 16/2/24.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "LoginViewController.h"
#import "NetDown.h"
#import "KeyboardToolBar.h"

@interface LoginViewController ()<UITextFieldDelegate>{
    __weak IBOutlet UITextField *txtUserName;
    __weak IBOutlet UITextField *txtPassword;
    __weak IBOutlet UIImageView *imgSelected;
}
@end

@implementation LoginViewController

static NSString * const KEY_PASSWORD = @"com.talkweb.SecurityAssistant.Password";

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *userImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 15, 15)];
    userImageView.image = [UIImage imageNamed:@"login_user"];
    [bgView1 addSubview:userImageView];
    txtUserName.leftViewMode=UITextFieldViewModeAlways;
    txtUserName.leftView=bgView1;
    
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *passImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 15, 15)];
    passImageView.image = [UIImage imageNamed:@"login_pass"];
    [bgView2 addSubview:passImageView];
    txtPassword.leftViewMode=UITextFieldViewModeAlways;
    txtPassword.leftView=bgView2;
   
    txtUserName.delegate=self;
    txtPassword.delegate=self;
    
    [KeyboardToolBar registerKeyboardToolBarWithTextField:txtUserName];
    [KeyboardToolBar registerKeyboardToolBarWithTextField:txtPassword];
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //7001 1206
//    txtUserName.text = @"7001";
//    txtPassword.text = @"888888";
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //apple service key:1052176895
    
    [KeyboardToolBar unregisterKeyboardToolBarWithTextField:txtUserName];
    [KeyboardToolBar unregisterKeyboardToolBarWithTextField:txtPassword];
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}
- (IBAction)rememberPasswordSelectChange:(id)sender {
    imgSelected.hidden = !imgSelected.hidden;
    
}
- (IBAction)login:(id)sender {
    BOOL state = [[NetDown shareTaskDataMgr] doLogin:txtUserName.text password:txtPassword.text];
    if(!state){
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"错 误" message:@"账户名或密码错误！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确 定", nil];
        [alertView show];
    }
    else{
        //refresh data
        [self rememberPassword];
        [self performSegueWithIdentifier:@"mainSegue" sender:self];
    }
    
//    [self performSegueWithIdentifier:@"mainSegue" sender:self];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.tag == 10){
        NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[LoginViewController load:textField.text];
        txtPassword.text = [usernamepasswordKVPair objectForKey:KEY_PASSWORD];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
-(void)rememberPassword{
    if(!imgSelected.hidden){
        NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
        [usernamepasswordKVPairs setObject:txtPassword.text forKey:KEY_PASSWORD];
        [LoginViewController save:txtUserName.text data:usernamepasswordKVPairs];
    }
    else{
        [LoginViewController delete:txtUserName.text];
    }
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}

@end
