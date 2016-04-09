//
//  PJNavigationbar.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "PJNavigationbar.h"

@interface PJNavigationbar ()
{
    BOOL _hasFirst;
}
@end
@implementation PJNavigationbar


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.barTintColor = [VariableStore getSystemBackgroundColor];
        self.translucent = NO;
        [[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        self.tintColor = [UIColor whiteColor];
        NSDictionary * dict = [NSDictionary dictionaryWithObject:self.tintColor forKey:NSForegroundColorAttributeName];
        self.titleTextAttributes = dict;

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        self.barTintColor = [VariableStore getSystemBackgroundColor];
        self.translucent = NO;
        [[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        self.tintColor = [UIColor whiteColor];
        NSDictionary * dict = [NSDictionary dictionaryWithObject:self.tintColor forKey:NSForegroundColorAttributeName];
        self.titleTextAttributes = dict;
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    if (!_hasFirst) {
        [self getShadowOffset:CGSizeMake(1, 2) shadowRadius:1 shadowColor:CustomGray shadowOpacity:.7 cornerRadius:1 masksToBounds:NO];
        _hasFirst = YES;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
