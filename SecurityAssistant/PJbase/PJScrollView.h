//
//  PJScrollView.h
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "BaseScrollView.h"
#include "PJTextField.h"

#define topY  7
#define leftX ScaleX(8)
#define lineHeight 44

@interface PJScrollView : BaseScrollView
{
    BOOL _hasFirst;
}
@end

@interface PJScrollView (private)

/**
 *  @brief  通化键盘
 *
 *  @param frame       键盘frame
 *  @param font        键盘font
 *  @param placeholder 键盘placeholder
 *  @param borderType  键盘边框类型
 *  @param borderColor 键盘边框颜色
 *  @param borderwidth 键盘边框粗细
 *
 *  @return 返回实例化好的键盘键盘
 */
- (PJTextField *)_createFieldFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder  borderType:(BorderType)borderType borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 *  @brief  通化label
 *
 *  @param font     label font
 *  @param text      label text
 *  @param textColor label textColor
 *  @param minX      label 最小x轴
 *  @param minY      label 最小y轴
 *
 *  @return 返回实例化好的label
 */
- (UILabel *)_createLabelFont:(UIFont *)font text:(NSString *)text textColor:(UIColor *)textColor minX:(CGFloat)minX minY:(CGFloat)minY;

/**
 *  @brief  通化键盘右边按钮
 *
 *  @param origin    按钮origin
 *  @param imageName 按钮背景图片
 *  @param action    按钮事件
 *
 *  @return 返回实例化好的按钮
 */
- (UIButton *)_setRightViewWithOrigin:(CGPoint)origin imageName:(NSString *)imageName action:(SEL)action;

@end
