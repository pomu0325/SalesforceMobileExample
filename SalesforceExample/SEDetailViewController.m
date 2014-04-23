//
//  SEDetailViewController.m
//  SalesforceExample
//
//  Created by pomu0325 on 2014/03/26.
//  Copyright (c) 2014年 pomu0325. All rights reserved.
//

#import "SEDetailViewController.h"
#import "SEMasterViewController.h"
#import "SEAppDelegate.h"

@interface SEDetailViewController ()
@end

@implementation SEDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // OAuthの認証画面を初期表示(User-Agent Flow)
    NSString *authorizeURL = @"https://login.salesforce.com/services/oauth2/authorize?response_type=token&client_id=3MVG9I1kFE5Iul2Cbahhzus9WVFyGSQGrQ3gTYeMzkJGbA_43hAg0fb57FTxZkWASpInGI4lSg3gpzlL4WErb&redirect_uri=test%3A%2F%2Fcallback&display=touch";
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:authorizeURL]];

    _webview.delegate = self;
    [_webview loadRequest:req];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *absoluteURL = request.URL.absoluteString;
    
    // callback先以外の場合は通常のページ遷移
    if ([absoluteURL rangeOfString:@"test://callback"].location == NSNotFound) return YES;

    // #以降のパラメータをバラす
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"(\\w+)=([^&]+)" options:0 error:nil];
    NSArray *matches = [re matchesInString:absoluteURL options:0 range:NSMakeRange(0, absoluteURL.length)];
    NSMutableDictionary *authInfo = @{}.mutableCopy;
    
    for (NSTextCheckingResult *r in matches) {
        NSString *k = [absoluteURL substringWithRange:[r rangeAtIndex:1]];
        NSString *v = [absoluteURL substringWithRange:[r rangeAtIndex:2]];
        authInfo[k] = [v stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    
    // User-Agent Flowなのでaccess_tokenが直接返ってくる
    NSString *accessToken = authInfo[@"access_token"];

    // 取得したaccess_tokenを使ってidサービスに接続。ユーザ情報を取得する
    
    // access_tokenをAuthorizationヘッダへ
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Authorization": [NSString stringWithFormat:@"Bearer %@", accessToken]};
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // idサービスのURLは'id'パラメータで返ってくる
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:authInfo[@"id"]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // 取得したユーザ情報をMain Viewに渡して画面戻る
        NSDictionary *idInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // メインスレッドで実行
            [self performSegueWithIdentifier:@"oauthSuccess" sender:@{@"authInfo":authInfo, @"idInfo":idInfo}];
        }];
    }];
    [task resume];
    
    // プッシュ通知用のtokenを登録
    SEAppDelegate *app = (SEAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *url = [authInfo[@"instance_url"] stringByAppendingString:@"/services/data/v29.0/sobjects/MobilePushServiceDevice"];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    req.HTTPMethod = @"POST";
    req.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{@"ConnectionToken":app.deviceToken, @"ServiceType":@"Apple"} options:0 error:nil];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *registerToken = [session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error.localizedDescription);
        }
    }];
    [registerToken resume];
    
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"oauthSuccess"]) {
        NSDictionary *params = sender;
        
        // 画面戻る前にプロパティに認証用の情報とユーザ情報をセット
        SEMasterViewController *master = segue.destinationViewController;
        master.authInfo = params[@"authInfo"];
        master.idInfo = params[@"idInfo"];
    }
}

@end
