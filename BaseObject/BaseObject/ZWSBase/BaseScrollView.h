//
//  BaseScrollView.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-11.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseScrollView : UIScrollView

@property (nonatomic) UIView *scrollHeaderView;
@property (nonatomic) UIView *scrollFooterView;
@property (nonatomic) UITextField *textFieldDelegate;
@property (nonatomic) UITextView *textViewDelegate;
- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder

@end
