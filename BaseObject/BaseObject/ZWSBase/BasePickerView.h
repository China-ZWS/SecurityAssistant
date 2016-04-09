//
//  BasePickerView.h
//  BaseObject
//
//  Created by 周文松 on 16/3/2.
//  Copyright © 2016年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePickerView : UIView
+ (id)showInView:(void(^)(id))showInView  success:(void (^)(id))success cancel:(void(^)())cancel;
- (BasePickerView *(^)(UIView *contentView))addContentView;
@end
