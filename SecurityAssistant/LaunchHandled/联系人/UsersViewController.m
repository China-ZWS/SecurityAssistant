//
//  UsersViewController.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/9.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "UsersViewController.h"
#import "BasicViewModel.h"
#import "OrganizationsViewController.h"
@interface UsersViewController ()
{
    NSMutableArray *_selecteds;
    void(^_selectedBlock)(id);
    NSMutableArray *_tmpSelecteds;

}
@end

@implementation UsersViewController

- (id)initWithParameters:(id)parameters caches:(NSMutableArray *)caches selected:(void(^)(id datas))selected;
{
    if ((self = [super initWithParameters:parameters]))
    {
        self.title = parameters[@"orgname"];

        [self.navigationItem setRightItemWithTarget:self title:@"重选" action:@selector(eventWithreSelect) image:nil];
        _tmpSelecteds = [NSMutableArray array];
        if (caches.count) {
            _selecteds = caches;
        }
        else
        {
            _selecteds = [NSMutableArray array];

        }
        _selectedBlock = selected;
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (void)eventWithreSelect
{
    
    [_selecteds removeAllObjects];
    [_tmpSelecteds removeAllObjects];
    _selectedBlock(_selecteds);
    [self reloadTabData];
    [self addNavigationWithPresentViewController:[[OrganizationsViewController alloc] initWithParameters:[BasicViewModel recombineForOrganizations]]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self footerView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = _datas[indexPath.row][@"displayname"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tmpSelecteds addObject:_datas[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [_tmpSelecteds removeObject:_datas[indexPath.row]];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_table setEditing:YES];
    // Do any additional setup after loading the view.
}

#pragma mark - init footerView
- (UIView *)footerView
{
    return ({
        UIToolbar *footerView = [UIToolbar new];
        footerView.frame = CGRectMake(0, 0, self.view.width, 50);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScaleW(10), 5, footerView.width - ScaleW(20), 40);
        btn.backgroundColor = [VariableStore getSystemBackgroundColor];
        [btn setTitle:@"完 成" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn getCornerRadius:ScaleW(5) borderColor:[UIColor clearColor] borderWidth:0 masksToBounds:YES];
        [btn addTarget:self action:@selector(eventWithFinished) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btn];
        footerView;
    });
}

- (void)setUpDatas
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        _datas = [BasicViewModel filtrateWithUsersOrgid:[_parameters[@"orgid"] integerValue]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /*刷新UI*/
            [self reloadTabData];
            for (NSDictionary *dic in _selecteds)
            {
                NSInteger index = [_datas indexOfObject:dic];
                [_table selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        });
    });
}

- (void)refreshWithViews:(NSNotification *)aNotification
{
    _datas = aNotification.object;
    [self reloadTabData];

}

- (void)eventWithFinished
{
    _selecteds = _tmpSelecteds;
    _selectedBlock(_selecteds);
    [self back];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
