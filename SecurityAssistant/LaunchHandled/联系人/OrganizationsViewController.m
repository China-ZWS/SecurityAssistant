//
//  OrganizationsViewController.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/10.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "OrganizationsViewController.h"
#import "BasicViewModel.h"

@interface OrganizationsViewController ()

@end

@implementation OrganizationsViewController

- (id)initWithParameters:(id)parameters
{
    if ((self = [super initWithParameters:parameters])) {
        self.title = @"机构";
        [self.navigationItem setRightItemWithTarget:self title:@"取 消" action:@selector(cancel) image:nil];
    }
    return self;
}

- (void)cancel
{
    [self dismissViewController];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%d",self.navigationController.viewControllers.count);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_parameters count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = _parameters[indexPath.row][@"shortname"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [_parameters[indexPath.row][@"childDatas"] count];
    if (row) {
        [self pushViewController:[[OrganizationsViewController alloc] initWithParameters:_parameters[indexPath.row][@"childDatas"]]];
    }
    else
    {
        NSArray *datas = [BasicViewModel filtrateWithUsersOrgid:[_parameters[indexPath.row][@"orgid"] integerValue]];
        if (datas.count) {
            NSNotificationPost(RefreshWithViews,datas, nil);
            [self cancel];
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"没有数据"];
        }
        
    }
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
