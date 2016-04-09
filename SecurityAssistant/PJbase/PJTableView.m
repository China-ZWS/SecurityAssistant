//
//  PJTableView.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/4/7.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "PJTableView.h"

@interface PJTableView ()
<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _row;
}
@end

@implementation PJTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if ((self = [super initWithFrame:frame style:style])) {
        self.delegate = self;
        self.dataSource = self;
        
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44 - 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = Font(15);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 40, 44 - 14);
        [btn addTarget:self action:@selector(eventWithTouches:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"详情" forState:UIControlStateNormal];
        [btn setTitleColor:NavColor forState:UIControlStateNormal];
        cell.accessoryView = btn;
        
    };
    
    cell.textLabel.text = _datas[indexPath.row];
    return cell;
}

- (void)eventWithTouches:(UIButton *)btn
{
    
    UITableViewCell *cell = [self getCell:btn];
    _row = [self indexPathForCell:cell].row;
 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描信息" message:_datas[_row] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
   
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0);
{
    if (buttonIndex == alertView.firstOtherButtonIndex)
    {
        [_datas removeObjectAtIndex:_row];
        [self reloadData];
        _deleteDatas(_datas);
    }
}

- (UITableViewCell *)getCell:(UIView *)view
{
    for (UIView* next = view; next; next =
         next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UITableViewCell
                                          class]])
        {
            return (UITableViewCell *)nextResponder;
        }
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
