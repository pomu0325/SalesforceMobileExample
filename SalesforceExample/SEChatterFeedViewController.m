//
//  SEChatterFeedViewController.m
//  SalesforceExample
//
//  Created by pomu0325 on 2014/03/27.
//  Copyright (c) 2014年 pomu0325. All rights reserved.
//

#import "SEChatterFeedViewController.h"

@interface SEChatterFeedViewController ()

@end

@implementation SEChatterFeedViewController
{
    NSArray *_feeditems;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 取得済みの認証情報からaccess_tokenとinstance_url
    NSString *accessToken = _authInfo[@"access_token"];
    NSString *instanceURL = _authInfo[@"instance_url"];
    
    // access_tokenをAuthorizationヘッダにセット
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Authorization": [NSString stringWithFormat:@"Bearer %@", accessToken]};
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // 呼び出すAPIのURL
    NSString *url = [instanceURL stringByAppendingPathComponent:@"/services/data/v29.0/chatter/feeds/people/me/feed-items"];
    
    // ChatterのFeedをAPIで取得
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (error) {
                // エラー表示
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                [alert show];
            } else {
                // 取得したFeedItem配列をセットしてテーブル再表示
                NSDictionary *feedItemPage = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                _feeditems = feedItemPage[@"items"];
                
                [self.tableView reloadData];
            }
        }];
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _feeditems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *feeditem = _feeditems[indexPath.row];
    
    cell.textLabel.text = feeditem[@"actor"][@"name"];
    cell.detailTextLabel.text = feeditem[@"body"][@"text"];
    
    return cell;
}

@end
