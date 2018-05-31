//
//  BaseViewController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/2.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseViewController.h"
#import "NotfiModel.h"
#import "SeekViewController.h"

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
    NotfiModel *notfiModel = [NotfiModel mj_objectWithKeyValues:notification.userInfo];

    if ([notfiModel.notifyType isEqualToString:@"newOrderNotify"]) {
        NSString *typeStr = @"";
        NSString *msgStr = @"";
        if([notfiModel.type isEqualToString:@"1"]){
            typeStr = @"实时";
            msgStr = [NSString stringWithFormat:@"订单类型：%@\n创建时间：%@\n联系人：%@\n车辆类型：%@\n发货地址：%@\n收货地址：%@",typeStr, notfiModel.createTime, notfiModel.linkMan ,notfiModel.carTypeName, notfiModel.sendAddress, notfiModel.receiveAddress];
        }else{
            typeStr = @"预约";
            msgStr = [NSString stringWithFormat:@"订单类型：%@\n创建时间：%@\n预约时间：%@\n联系人：%@\n车辆类型：%@\n发货地址：%@\n收货地址：%@",typeStr, notfiModel.createTime, notfiModel.appointTime, notfiModel.linkMan, notfiModel.carTypeName, notfiModel.sendAddress, notfiModel.receiveAddress];
        }
        [AlertView alertViewWithTitle:notfiModel.aps.alert withMessage:msgStr withType:UIAlertControllerStyleAlert withConfirmBlock:^{
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            
            [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
            [param setObject:notfiModel.orderId forKey:@"orderId"];
            
            
            [NetWorking postDataWithParameters:param withUrl:@"robOrder" withBlock:^(id result) {
                [HUDClass showHUDWithText:@"抢单成功！"];
                
            } withFailedBlock:^(NSString *errorResult) {
                
            }];
        } withCancelBlock:^{
            
        }];

    }else if ([notfiModel.notifyType isEqualToString:@"OrderBeReceivedNotify"]) {
        NSString *msgStr = [NSString stringWithFormat:@"创建时间：%@\n司机姓名：%@\n司机电话：%@\n车牌号：%@\n发货地址：%@\n收货地址：%@",notfiModel.createTime, notfiModel.driverName, notfiModel.driverPhone, notfiModel.plateNumber, notfiModel.sendAddress, notfiModel.receiveAddress];
        
        if ([[NavBgImage getCurrentVC] isMemberOfClass:[SeekViewController class]]) {
            SeekViewController *seekVc = (SeekViewController *)[NavBgImage getCurrentVC];
            if ([seekVc.orderId isEqualToString:notfiModel.orderId]) {
                [seekVc popActWithOrderType:notfiModel.type];
            }
        }
        [AlertView alertViewWithTitle:notfiModel.aps.alert withMessage:msgStr withType:UIAlertControllerStyleAlert withConfirmBlock:^{
            
        }];
        
    }else if ([notfiModel.notifyType isEqualToString:@"OrderBeCanceledNotify"]) {
        NSString *typeStr = @"";
        NSString *msgStr = @"";
        if([notfiModel.type isEqualToString:@"1"]){
            typeStr = @"实时";
            msgStr = [NSString stringWithFormat:@"订单类型：%@\n创建时间：%@\n联系人：%@\n发货地址：%@\n收货地址：%@",typeStr,notfiModel.createTime ,notfiModel.linkMan ,notfiModel.sendAddress, notfiModel.receiveAddress];

        }else{
            typeStr = @"预约";
            msgStr = [NSString stringWithFormat:@"订单类型：%@\n创建时间：%@\n预约时间：%@\n联系人：%@\n发货地址：%@\n收货地址：%@",typeStr, notfiModel.createTime, notfiModel.appointTime, notfiModel.linkMan, notfiModel.sendAddress, notfiModel.receiveAddress];

        }
        [AlertView alertViewWithTitle:notfiModel.aps.alert withMessage:msgStr withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        
        }];
        
    }
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
