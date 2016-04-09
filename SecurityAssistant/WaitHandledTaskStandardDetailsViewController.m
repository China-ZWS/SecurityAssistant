//
//  WaitHandledTaskStandardDetailsViewController.m
//  SecurityAssistant
//
//  Created by talkweb on 16/3/21.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "WaitHandledTaskStandardDetailsViewController.h"

@interface WaitHandledTaskStandardDetailsViewController (){
    __weak IBOutlet UIWebView *textContent;
}

@end

@implementation WaitHandledTaskStandardDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [textContent loadHTMLString:_tt baseURL:nil];
//    _textContent.text = _tt;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    _textContent.font = [UIFont systemFontOfSize:17];
//    _textContent.textColor = [UIColor darkGrayColor];
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
