//
//  SEMasterViewController.h
//  SalesforceExample
//
//  Created by pomu0325 on 2014/03/26.
//  Copyright (c) 2014年 pomu0325. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEMasterViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;

@property NSDictionary *authInfo;

@property NSDictionary *idInfo;

@end
