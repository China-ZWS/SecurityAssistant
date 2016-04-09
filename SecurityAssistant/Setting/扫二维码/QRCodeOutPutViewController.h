//
//  QRCodeOutPutViewController.h
//  SecurityAssistant
//
//  Created by kevin on 16/3/4.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeOutPutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *ouputText;
@property(nonatomic,strong) NSString *recipeString;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
