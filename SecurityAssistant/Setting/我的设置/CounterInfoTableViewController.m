//
//  CounterInfoTableViewController.m
//  SecurityAssistant
//
//  Created by kevin on 16/3/10.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "CounterInfoTableViewController.h"
#import "NetDown.h"
@interface CounterInfoTableViewController (){
    NSArray *tableArray;
}

@end

@implementation CounterInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tableArray=[[NSArray alloc] initWithObjects:@"用户名",@"岗位",@"部门", nil];
 //NSDictionary *infoData=[[NetDown shareTaskDataMgr] userInfo];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"counterinfo" forIndexPath:indexPath];
    cell.textLabel.text=[tableArray objectAtIndex:indexPath.row];
    //displayname posiname orgname

    if (indexPath.row==0) {
        cell.detailTextLabel.text=[[[NetDown shareTaskDataMgr] userInfo] objectForKey:@"displayname" ];
    }
    if (indexPath.row==1) {
        cell.detailTextLabel.text=[[[NetDown shareTaskDataMgr] userInfo] objectForKey:@"posiname" ];
    }
    if (indexPath.row==2) {
        cell.detailTextLabel.text=[[[NetDown shareTaskDataMgr] userInfo] objectForKey:@"orgname" ];
    }

        // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
