//
//  PJScrollView.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "PJScrollView.h"
@implementation PJScrollView (private)
#pragma mark 键盘实例化组合

- (PJTextField *)_createFieldFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder  borderType:(BorderType)borderType borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    PJTextField *field = [PJTextField new];
    field.frame = frame;
    field.font = font;
    field.placeholder = placeholder;
    field.borderType = borderType;
    field.borderColor = borderColor;
    field.borderWidth = borderWidth;
    return field;
}

#pragma mark - Label实例化组合
- (UILabel *)_createLabelFont:(UIFont *)font text:(NSString *)text textColor:(UIColor *)textColor minX:(CGFloat)minX minY:(CGFloat)minY
{
    CGSize textSize = [NSObject getSizeWithText:text font:font maxSize:CGSizeMake(self.width, 44)];
    UILabel * label = [UILabel new];
    //    label.backgroundColor = [UIColor redColor];
    label.frame = CGRectMake(minX, minY, textSize.width, 44);
    label.font = font;
    label.text = text;
    label.textColor = textColor;
    return label;
}


#pragma mark - 实例化field右边按钮组合
- (UIButton *)_setRightViewWithOrigin:(CGPoint)origin imageName:(NSString *)imageName action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.origin = origin;
    btn.size = CGSizeMake(40, 40);
    if (imageName) {
        [btn setImage:[self getComImage:[UIImage imageNamed:imageName]] forState:UIControlStateNormal];
    }
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIImage *)getComImage:(UIImage *)originalImage ;
{
    UIGraphicsBeginImageContext(CGSizeMake(30, 30));
    [originalImage drawInRect:CGRectMake(0, 0, 30, 30)];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

@end

@implementation PJScrollView

- (void)dealloc
{
    NSLog(@"%@",self);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
