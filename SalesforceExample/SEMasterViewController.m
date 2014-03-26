//
//  SEMasterViewController.m
//  SalesforceExample
//
//  Created by pomu0325 on 2014/03/26.
//  Copyright (c) 2014年 pomu0325. All rights reserved.
//

#import "SEMasterViewController.h"

#import "SEDetailViewController.h"

@interface SEMasterViewController ()

@end

@implementation SEMasterViewController

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        default:
            return 2;
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

@end
