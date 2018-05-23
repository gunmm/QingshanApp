//
//  BaseViewController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/2.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    NSString *typeStr = @"";
    if([notification.userInfo[@"type"] isEqualToString:@"1"]){
        typeStr = @"实时";
    }else{
        typeStr = @"预约";
    }
    NSString *msgStr = [NSString stringWithFormat:@"订单类型：%@\n联系人：%@\n车辆类型：%@\n备注：%@\n发货地址：%@\n收货地址：%@",typeStr, notification.userInfo[@"linkMan"], notification.userInfo[@"carType"], notification.userInfo[@"note"], notification.userInfo[@"sendAddress"], notification.userInfo[@"receiveAddress"]];
    [AlertView alertViewWithTitle:alertMsg withMessage:msgStr withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
       
        [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
        [param setObject:notification.userInfo[@"orderId"] forKey:@"orderId"];
        
        
        [NetWorking postDataWithParameters:param withUrl:@"robOrder" withBlock:^(id result) {
            [HUDClass showHUDWithText:@"抢单成功！"];
            
        } withFailedBlock:^(NSString *errorResult) {
            
        }];
        
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
