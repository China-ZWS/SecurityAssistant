//
//  KeyboardExtendHandling.m
//  CMCCMarketing
//
//  Created by talkweb on 15-5-18.
//  Copyright (c) 2015年 talkweb. All rights reserved.
//

#import "KeyboardExtendHandling.h"
#import "DaiDodgeKeyboard.h"

@implementation UIView (FindFirstResponder)

- (UIView *)findFirstResponder
{
	if (self.isFirstResponder) return self;
	for (UIView *subView in self.subviews) {
		UIView *firstResponder = [subView findFirstResponder];
		if (firstResponder != nil) return firstResponder;
	}
	return nil;
}

@end

@implementation KeyboardExtendHandling

- (UIToolbar *)createToolbar
{
	UIToolbar *toolBar = [UIToolbar new];
	UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(textFieldDone)];
	toolBar.items = @[space, done];
    [toolBar sizeToFit];
	return toolBar;
}
- (void)textFieldDone
{
	[[self.view findFirstResponder] resignFirstResponder];
}

-(id)initKeyboardHangling:(UIView*)view{
    self = [super init];
    if (self) {
        self.view=view;
        UIToolbar *toolBar = [self createToolbar];
        for (UIView *v in self.view.subviews) {
            if ([v respondsToSelector:@selector(setText:)] && ![v isKindOfClass:[UILabel class]]) {
                [v performSelector:@selector(setDelegate:) withObject:self];
                [v performSelector:@selector(setInputAccessoryView:) withObject:toolBar];
            }
        }
        [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
    }
    return self;
}
-(void)removeKeyboardHandling{
    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
}
@end
