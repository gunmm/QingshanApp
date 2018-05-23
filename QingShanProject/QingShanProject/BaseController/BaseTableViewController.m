//
//  BaseTableViewController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/2.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(receivedMsg:) name:@"concrete_notify" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:@"concrete_notify" object:nil];
}

- (void)receivedMsg:(NSNotification *)notification
{
    NSString *alertMsg = [notification.userInfo[@"aps"] objectForKey:@"alert"];
    NSString *notifyType = notification.userInfo[@"notifyType"];
    //    if ([notifyType isEqualToString:@"supplierOrderProcessCreate"] || [notifyType isEqualToString:@"hzsOrderProcessFinish"]) {
    //
    //
    //    }
    [AlertView alertViewWithTitle:@"新消息" withMessage:alertMsg withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        //        @try{
        //            [[HttpClient shareClient] bgPost:READ_MESSAGE parameters:@{@"msgId":notification.userInfo[@"messageId"]} success:^(NSURLSessionDataTask *task, id responseObject) {
        //            } failure:^(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType) {
        //            }];            }
        //        @catch(NSException *exception){
        //            NSLog(@"%@",exception.reason);
        //        }
        
    }];
    //    else {
    //
    //    }
    
    
}

#pragma mark -- 设置状态栏字体为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
