
//
//  PJViewController.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "PJViewController.h"
#import "PJNavigationbar.h"
@interface PJViewController ()

@end

@implementation PJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(235, 235, 235, 1);
    // Do any additional setup after loading the view.
}

- (void)addNavigationWithPresentViewController:(UIViewController *)viewcontroller;
{
    UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[PJNavigationbar class] toolbarClass:nil];
    nav.viewControllers = @[viewcontroller];
    [self presentViewController:nav];
    
}
- (void)addNavigationWithPushController:(UIViewController *)viewcontroller;
{
    UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[PJNavigationbar class] toolbarClass:nil];
    nav.viewControllers = @[viewcontroller];
    
    [self pushViewController:nav];
    
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
