//
//  DetailTaskWebViewController.m
//  SecurityAssistant
//
//  Created by kevin on 16/3/10.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "DetailTaskWebViewController.h"
#import "NetDown.h"
#import "VariableStore.h"

@interface DetailTaskWebViewController ()

@end

@implementation DetailTaskWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlString= [[NSString alloc]initWithFormat:@"http://%@:%@/TWPASS/mobile/errinfo/errdetail.html?errid=%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"preference_ip"],[[NSUserDefaults standardUserDefaults] stringForKey:@"preference_port"],_recpString];
    [self.DetailDangerWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
   [self.DetailDangerWebview setScalesPageToFit:YES];
    // Do any additional setup after loading the view.
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
