//
//  UIView+CGQuartz.m
//  BabyStory
//
//  Created by 周文松 on 14-11-10.
//  Copyright (c) 2014年 com.talkweb.BabyStory. All rights reserved.
//

#import "UIView+CGQuartz.h"
@implementation UIView (CGQuartz)


- (void)drawRectWithLine:(CGRect)rect start:(CGPoint)start end:(CGPoint)end lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineWidth(context,lineWidth);
    CGContextSetStrokeColorWithColor(context,lineColor.CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,start.x, start.y );
    CGContextAddLineToPoint(context,end.x, end.y);
    
    CGContextDrawPath(context,kCGPathFillStroke);

}




#pragma mark 绘制文本
- (void)drawTextWithText:(NSString *)text rect:(CGRect)frame color:(UIColor *)color font:(UIFont *)font
{
    
    [text drawInRect:text.length?frame:CGRectZero withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
}

#pragma mark 绘制圆形
-(void)drawCircleWithCenter:(CGPoint)center radius:(float)radius width:(CGFloat)width widthColor:(UIColor *)widthColor fillColor:(UIColor *)fillColor shadowSize:(CGSize)shadowSize
{
    
    
    CGContextRef     context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CGPathAddArc(pathRef,
                 &CGAffineTransformIdentity,
                 center.x,
                 center.y,
                 radius,
                 M_PI/2,
                 radius*2*M_PI-M_PI/2,
                 NO);
//    CGPathCloseSubpath(pathRef);
    CGContextSetStrokeColorWithColor(context, widthColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextSetShadowWithColor(context, shadowSize, 1, widthColor.CGColor);
    CGContextAddPath(context, pathRef);
    CGPathCloseSubpath(pathRef);

    CGContextDrawPath(context,kCGPathFillStroke);
    
    CGPathRelease(pathRef);
    
}



- (void)drawWithChamferOfRectangle:(CGRect)rect inset:(UIEdgeInsets)inset  radius:(float)radius lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor backgroundColor:(UIColor *)backgroundColor ;
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGFloat minX = rect.origin.x + inset.left;
    CGFloat minY = rect.origin.y + inset.top;
    CGFloat maxX = CGRectGetMaxX(rect) - inset.right;
    CGFloat maxY = CGRectGetMaxY(rect) - inset.bottom;
    
    CGPoint x1,x2,x3,x4 ; // 为4个定点
    CGPoint y1,y2,y3,y4,y5,y6,y7,y8; //8个控制点
    
    x1 = CGPointMake(minX, minY);
    x2 = CGPointMake(maxX, minY);
    x3 = CGPointMake(maxX, maxY);
    x4 = CGPointMake(minX, maxY);
    
    y1 = CGPointMake(minX + radius, minY);
    y2 = CGPointMake(maxX - radius, minY);
    y3 = CGPointMake(maxX, minY + radius);
    y4 = CGPointMake(maxX, maxY - radius);
    y5 = CGPointMake(maxX - radius, maxY);
    y6 = CGPointMake(minX + radius, maxY);
    y7 = CGPointMake(minX, maxY - radius);
    y8 = CGPointMake(minX, minY + radius);
    
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextMoveToPoint(context, y1.x, y1.y);
    CGContextAddArcToPoint(context, x2.x, x2.y, y3.x, y3.y, radius);
    CGContextAddArcToPoint(context, x3.x, x3.y, y5.x, y5.y, radius);
    CGContextAddArcToPoint(context, x4.x, x4.y, y7.x, y7.y, radius);
    CGContextAddArcToPoint(context, x1.x, x1.y, y1.x, y1.y, radius);
//    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 1, CustomlightGray.CGColor);
    CGContextDrawPath(context,kCGPathFillStroke);
}



#pragma mark - 绘制Cell 背景
- (void)drawCellWithRound:(CGRect)rect cellStyle:(CellStyle)cellStyle inset:(UIEdgeInsets)inset radius:(float)radius lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor backgroundColor:(UIColor *)backgroundColor;
{
//    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat minX, minY, maxX, maxY;   
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineWidth(context,lineWidth);
    CGContextSetStrokeColorWithColor(context,lineColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);

    UIBezierPath *path;

    switch (cellStyle) {
        case kUpCell:
        {
            minX = CGRectGetMinX(rect) + inset.left;
            minY = CGRectGetMinY(rect) + inset.top;
            maxX = CGRectGetWidth(rect) - inset.right;
            maxY = CGRectGetHeight(rect);
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(minX, minY, maxX - minX, maxY - minY) byRoundingCorners:(UIRectCornerTopLeft |UIRectCornerTopRight) cornerRadii:CGSizeMake(radius, radius)];
        }
            break;
        case kCenterCell:
        {
            minX = CGRectGetMinX(rect) + inset.left;
            minY = CGRectGetMinY(rect);
            maxX = CGRectGetMaxX(rect) - inset.right;
            maxY = CGRectGetMaxY(rect);
            path = [UIBezierPath bezierPathWithRect:CGRectMake(minX, minY, maxX - minX, maxY - minY)];

        }
            break;
        case kDownCell:
        {
            minX = CGRectGetMinX(rect) + inset.left;
            minY = CGRectGetMinY(rect);
            maxX = CGRectGetWidth(rect) - inset.right;
            maxY = CGRectGetHeight(rect) - inset.bottom;
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(minX, minY, maxX - minX, maxY - minY) byRoundingCorners:(UIRectCornerBottomLeft |UIRectCornerBottomRight) cornerRadii:CGSizeMake(radius, radius)];
        }
            break;
        case kRoundCell:
        {
            minX = CGRectGetMinX(rect) + inset.left;
            minY = CGRectGetMinY(rect) + inset.top;
            maxX = CGRectGetWidth(rect) - inset.right;
            maxY = CGRectGetHeight(rect) - inset.bottom;
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(minX, minY, maxX - minX, maxY - minY) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
            
        }
            break;
        default:
            break;
    }
    
    
    [path stroke];
    [path fill];
    [path closePath];
}



@end
