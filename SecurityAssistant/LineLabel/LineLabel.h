//
//  LineLabel.h
//  LineLabel
//
//  Created by shadow on 2015/8/24.
//  Copyright (c) 2015年 shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LineType) {
    /**
     *  未畫線
     */
    LineTypeNone,
    /**
     *  上方畫線
     */
    LineTypeUp,
    /**
     *  中間畫線
     */
    LineTypeMiddle,
    /**
     *  下方畫線
     */
    LineTypeDown,
};

@interface LineLabel : UILabel

/**
 *  設定Label畫線的樣式
 */
@property (nonatomic, assign) LineType lineType;
/**
 *  設定Label畫線的顏色
 */
@property (nonatomic, assign) UIColor *lineColor;

@end
