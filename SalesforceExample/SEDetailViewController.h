//
//  SEDetailViewController.h
//  SalesforceExample
//
//  Created by pomu0325 on 2014/03/26.
//  Copyright (c) 2014年 pomu0325. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
