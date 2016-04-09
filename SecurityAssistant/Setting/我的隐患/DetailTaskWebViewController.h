//
//  DetailTaskWebViewController.h
//  SecurityAssistant
//
//  Created by kevin on 16/3/10.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTaskWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *DetailDangerWebview;

@property(strong,nonatomic) NSString *recpString;
@end
