//
//  PJTextField.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/2.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "PJTextField.h"

@implementation PJTextField

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *v=[[UIView alloc] init];
        CGRect rect=v.frame;
        rect.size.height=20;
        [v setFrame:rect];
        
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setImage:[UIImage imageNamed:@"jianpan.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"jianpan_action.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btn];
        
        self.inputAccessoryView = v;
    }
    return self;
}

-(void)hideKeyBoard
{
    [super hideKeyBoard];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
