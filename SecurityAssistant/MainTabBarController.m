//
//  MainTabBarController.m
//  SecurityAssistant
//
//  Created by talkweb on 16/2/24.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[VariableStore hexStringToColor:@"#a7a7aa"], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:[VariableStore getSystemBackgroundColor],NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    
    UIStoryboard *waitHandledStoryboard=[UIStoryboard storyboardWithName:@"WaitHandled" bundle:nil];
    UINavigationController *nav1=[waitHandledStoryboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    nav1.tabBarItem.title = @"待 办";
//    nav1.tabBarItem.image = [UIImage imageNamed:@"tabbar_01"];
    
    nav1.tabBarItem.image = [[UIImage imageNamed:@"tabbar_01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    nav1.tabBarItem.imageInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    nav1.tabBarItem.selectedImage =[[UIImage imageNamed:@"tabbar_01_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UIStoryboard *launchStoryboard=[UIStoryboard storyboardWithName:@"LaunchHandled" bundle:nil];
    UINavigationController *nav2 = [launchStoryboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    nav2.tabBarItem.title = @"发 起";
    nav2.tabBarItem.image = [[UIImage imageNamed:@"tabbar_02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem.selectedImage =[[UIImage imageNamed:@"tabbar_02_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIStoryboard *settingStoryboard=[UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    UINavigationController *nav3 = [settingStoryboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    nav3.tabBarItem.title = @"我";
    nav3.tabBarItem.image = [[UIImage imageNamed:@"tabbar_03"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem.selectedImage =[[UIImage imageNamed:@"tabbar_03_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSArray *controllers = [NSArray arrayWithObjects:nav1,nav2,nav3, nil];
    self.viewControllers = controllers;
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
