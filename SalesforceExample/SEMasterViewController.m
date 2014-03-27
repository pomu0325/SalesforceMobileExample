//
//  SEMasterViewController.m
//  SalesforceExample
//
//  Created by pomu0325 on 2014/03/26.
//  Copyright (c) 2014年 pomu0325. All rights reserved.
//

#import "SEMasterViewController.h"

#import "SEDetailViewController.h"
#import "SEChatterFeedViewController.h"

@interface SEMasterViewController ()

@end

@implementation SEMasterViewController

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return 2;
        default:
            return 1;
    }
}

/**
 * 認証後のUnwind Segue
 */
-(IBAction)oauthSuccess:(UIStoryboardSegue *)sender
{
    // 取得したユーザ情報を表示
    _usernameLabel.text = _idInfo[@"username"];
    _displayNameLabel.text = _idInfo[@"display_name"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"ChatterFeed"]) {
        // 遷移先のViewControllerに認証情報を渡す
        SEChatterFeedViewController *c = segue.destinationViewController;
        c.authInfo = _authInfo;
    }
}

@end
