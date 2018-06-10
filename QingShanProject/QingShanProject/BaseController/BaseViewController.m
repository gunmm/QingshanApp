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
#import "DriverOnWayController.h"
#import "DriverMainPageController.h"
#import "StandLeftPageController.h"
#import "EBBannerView.h"
#import "OrderFinshController.h"
#import "DriverOrderDetailController.h"
#import "ShortSoundPlay.h"



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
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy/MM/dd HH:mm";
    NSString *dateStr = [format stringFromDate:[NSDate new]];
    
    if ([notfiModel.notifyType isEqualToString:@"newOrderNotify"]) {
        NSString *typeStr = @"";
        NSString *msgStr = @"";
        if([notfiModel.type isEqualToString:@"1"]){
            typeStr = @"实时";
            msgStr = [NSString stringWithFormat:@"订单类型：%@\n创建时间：%@\n联系人：%@\n车辆类型：%@\n发货地址：%@\n收货地址：%@\n备注：%@\n距离：%.2f公里\n费用：%.2f元",typeStr, notfiModel.createTime, notfiModel.linkMan ,notfiModel.carTypeName, notfiModel.sendAddress, notfiModel.receiveAddress, notfiModel.note.length > 0 ? notfiModel.note: @"无", notfiModel.distance, notfiModel.price];
            [ShortSoundPlay playSoundWithPath:@"voice_now" withType:@"m4a"];
        }else{
            typeStr = @"预约";
            msgStr = [NSString stringWithFormat:@"订单类型：%@\n创建时间：%@\n预约时间：%@\n联系人：%@\n车辆类型：%@\n发货地址：%@\n收货地址：%@\n备注：%@\n距离：%.2f公里\n费用：%.2f元",typeStr, notfiModel.createTime, notfiModel.appointTime, notfiModel.linkMan, notfiModel.carTypeName, notfiModel.sendAddress, notfiModel.receiveAddress, notfiModel.note.length > 0 ? notfiModel.note: @"无", notfiModel.distance, notfiModel.price];
            [ShortSoundPlay playSoundWithPath:@"voice_booking" withType:@"m4a"];

        }
        [AlertView alertViewWithTitle:notfiModel.aps.alert withMessage:msgStr withConfirmTitle:@"抢单" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            
            [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
            [param setObject:notfiModel.orderId forKey:@"orderId"];
            
            [NetWorking postDataWithParameters:param withUrl:@"robOrder" withBlock:^(id result) {
                [HUDClass showHUDWithText:@"抢单成功！"];
                [ShortSoundPlay playSoundWithPath:@"grab_successed" withType:@"m4a"];

                DriverOrderDetailController *driverOrderDetailController = [[DriverOrderDetailController alloc] init];
                driverOrderDetailController.orderId = notfiModel.orderId;
                [[NavBgImage getCurrentVC].view endEditing:YES];
                if ([NavBgImage judgeCurrentVCIspresented]) {
                    [[NavBgImage getCurrentVC] dismissViewControllerAnimated:YES completion:^{
                        [[NavBgImage getCurrentVC].navigationController pushViewController:driverOrderDetailController animated:YES];
                    }];
                }else if ([[NavBgImage getCurrentVC] isMemberOfClass:[StandLeftPageController class]]){
                    StandLeftPageController *standLeftPageController = (StandLeftPageController *)[NavBgImage getCurrentVC];
                    if (standLeftPageController.standLeftCloseBlock) {
                        standLeftPageController.standLeftCloseBlock();
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NavBgImage getCurrentVC].navigationController pushViewController:driverOrderDetailController animated:YES];
                    });
                }else{
                    [[NavBgImage getCurrentVC].navigationController pushViewController:driverOrderDetailController animated:YES];
                }
            } withFailedBlock:^(NSString *errorResult) {
                [ShortSoundPlay playSoundWithPath:@"grab_failed" withType:@"m4a"];
            }];
            
            param = [NSMutableDictionary dictionary];
            [param setObject:notfiModel.messageId forKey:@"messageId"];
            [NetWorking bgPostDataWithParameters:param withUrl:@"setMessageRead" withBlock:^(id result) {
            } withFailedBlock:^(NSString *errorResult) {
            }];
        } withCancelBlock:^{
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:notfiModel.messageId forKey:@"messageId"];
            [NetWorking bgPostDataWithParameters:param withUrl:@"setMessageRead" withBlock:^(id result) {
            } withFailedBlock:^(NSString *errorResult) {
            }];
            
        }];

    }else if ([notfiModel.notifyType isEqualToString:@"OrderBeCanceledNotify"]) {
        //订单被取消
        NSString *typeStr = @"";
        NSString *msgStr = @"";
        if([notfiModel.type isEqualToString:@"1"]){
            typeStr = @"实时";
            msgStr = [NSString stringWithFormat:@"订单类型：%@\n创建时间：%@\n联系人：%@\n发货地址：%@\n收货地址：%@",typeStr,notfiModel.createTime ,notfiModel.linkMan ,notfiModel.sendAddress, notfiModel.receiveAddress];
            
        }else{
            typeStr = @"预约";
            msgStr = [NSString stringWithFormat:@"订单类型：%@\n创建时间：%@\n预约时间：%@\n联系人：%@\n发货地址：%@\n收货地址：%@",typeStr, notfiModel.createTime, notfiModel.appointTime, notfiModel.linkMan, notfiModel.sendAddress, notfiModel.receiveAddress];
        }
        
        if ([[NavBgImage getCurrentVC] isMemberOfClass:[DriverOrderDetailController class]]) {
            DriverOrderDetailController *driverOrderDetailController = (DriverOrderDetailController *)[NavBgImage getCurrentVC];
            if ([driverOrderDetailController.orderId isEqualToString:notfiModel.orderId]) {
                [driverOrderDetailController loadData];
                EBBannerView *banner = [EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
                    make.style = EBBannerViewStyleiOS9;
                    make.icon = [UIImage imageNamed:@"chengkeface"];
                    make.title = notfiModel.aps.alert;
                    make.content = msgStr;
                    make.stayDuration = 8;
                    make.date = dateStr;
                    make.soundName = @"order_short_tip.m4a";

                }];
                [ShortSoundPlay playSoundWithPath:@"order_cancel" withType:@"m4a"];

                [banner show];
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:notfiModel.messageId forKey:@"messageId"];
                [NetWorking bgPostDataWithParameters:param withUrl:@"setMessageRead" withBlock:^(id result) {
                } withFailedBlock:^(NSString *errorResult) {
                }];
                return;
            }
        }
        
        
        
        EBBannerView *banner = [EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
            make.style = EBBannerViewStyleiOS9;
            make.icon = [UIImage imageNamed:@"chengkeface"];
            make.title = notfiModel.aps.alert;
            make.content = msgStr;
            make.stayDuration = 8;
            make.date = dateStr;
            make.soundName = @"order_short_tip.m4a";

        }];
        [ShortSoundPlay playSoundWithPath:@"order_short_tip" withType:@"m4a"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ShortSoundPlay playSoundWithPath:@"order_cancel" withType:@"m4a"];
        });
        
        [banner show];
        banner.tapActBlock = ^{
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:notfiModel.messageId forKey:@"messageId"];
            [NetWorking bgPostDataWithParameters:param withUrl:@"setMessageRead" withBlock:^(id result) {
            } withFailedBlock:^(NSString *errorResult) {
            }];
            
            DriverOrderDetailController *driverOrderDetailController = [[DriverOrderDetailController alloc] init];
            driverOrderDetailController.orderId = notfiModel.orderId;
            [[NavBgImage getCurrentVC].view endEditing:YES];
            if ([NavBgImage judgeCurrentVCIspresented]) {
                [[NavBgImage getCurrentVC] dismissViewControllerAnimated:YES completion:^{
                    [[NavBgImage getCurrentVC].navigationController pushViewController:driverOrderDetailController animated:YES];
                }];
            }else if ([[NavBgImage getCurrentVC] isMemberOfClass:[StandLeftPageController class]]){
                StandLeftPageController *standLeftPageController = (StandLeftPageController *)[NavBgImage getCurrentVC];
                if (standLeftPageController.standLeftCloseBlock) {
                    standLeftPageController.standLeftCloseBlock();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NavBgImage getCurrentVC].navigationController pushViewController:driverOrderDetailController animated:YES];
                });
            }else{
                [[NavBgImage getCurrentVC].navigationController pushViewController:driverOrderDetailController animated:YES];
            }
        };
        
    }else if ([notfiModel.notifyType isEqualToString:@"OrderBeReceivedNotify"]) {
        //订单状态更新
        NSString *alertStr = @"";
        if ([notfiModel.status isEqualToString:@"1"]) {
            alertStr = @"订单被接单";
        }else if ([notfiModel.status isEqualToString:@"2"]) {
            alertStr = @"司机接到货物";
        }else if ([notfiModel.status isEqualToString:@"3"]) {
            alertStr = @"订单已完成";
        }
        NSString *msgStr = [NSString stringWithFormat:@"%@\n创建时间：%@\n司机姓名：%@\n司机电话：%@\n车牌号：%@\n发货地址：%@\n收货地址：%@", alertStr,notfiModel.createTime, notfiModel.driverName, notfiModel.driverPhone, notfiModel.plateNumber, notfiModel.sendAddress, notfiModel.receiveAddress];
        
        if ([[NavBgImage getCurrentVC] isMemberOfClass:[SeekViewController class]]) {
            SeekViewController *seekVc = (SeekViewController *)[NavBgImage getCurrentVC];
            if ([seekVc.orderId isEqualToString:notfiModel.orderId]) {
                [seekVc popActWithOrderType:notfiModel.type];
                EBBannerView *banner = [EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
                    make.style = EBBannerViewStyleiOS9;
                    make.icon = [UIImage imageNamed:@"driver_head_default"];
                    make.title = notfiModel.aps.alert;
                    make.content = msgStr;
                    make.stayDuration = 8;
                    make.date = dateStr;
                }];
                [banner show];
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:notfiModel.messageId forKey:@"messageId"];
                [NetWorking bgPostDataWithParameters:param withUrl:@"setMessageRead" withBlock:^(id result) {
                } withFailedBlock:^(NSString *errorResult) {
                }];
                return;
            }
        }
        
        if ([[NavBgImage getCurrentVC] isMemberOfClass:[DriverOnWayController class]]) {
            DriverOnWayController *onWayVc = (DriverOnWayController *)[NavBgImage getCurrentVC];
            if ([onWayVc.orderId isEqualToString:notfiModel.orderId]) {
                [onWayVc loadData];
                EBBannerView *banner = [EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
                    make.style = EBBannerViewStyleiOS9;
                    make.icon = [UIImage imageNamed:@"driver_head_default"];
                    make.title = notfiModel.aps.alert;
                    make.content = msgStr;
                    make.stayDuration = 8;
                    make.date = dateStr;
                }];
                [banner show];
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:notfiModel.messageId forKey:@"messageId"];
                [NetWorking bgPostDataWithParameters:param withUrl:@"setMessageRead" withBlock:^(id result) {
                } withFailedBlock:^(NSString *errorResult) {
                }];
                return;
            }
        }
        
        EBBannerView *banner = [EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
            make.style = EBBannerViewStyleiOS9;
            make.icon = [UIImage imageNamed:@"driver_head_default"];
            make.title = notfiModel.aps.alert;
            make.content = msgStr;
            make.stayDuration = 8;
            make.date = dateStr;
        }];
        [banner show];
        banner.tapActBlock = ^{
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:notfiModel.messageId forKey:@"messageId"];
            [NetWorking bgPostDataWithParameters:param withUrl:@"setMessageRead" withBlock:^(id result) {
            } withFailedBlock:^(NSString *errorResult) {
            }];
            
            UIViewController *vc;
            DriverOnWayController *onwayVc = [[DriverOnWayController alloc] init];
            onwayVc.orderId = notfiModel.orderId;
            vc = onwayVc;
            
           
            [[NavBgImage getCurrentVC].view endEditing:YES];
            if ([NavBgImage judgeCurrentVCIspresented]) {
                [[NavBgImage getCurrentVC] dismissViewControllerAnimated:YES completion:^{
                    [[NavBgImage getCurrentVC].navigationController pushViewController:vc animated:YES];
                }];
            }else if ([[NavBgImage getCurrentVC] isMemberOfClass:[StandLeftPageController class]]){
                StandLeftPageController *standLeftPageController = (StandLeftPageController *)[NavBgImage getCurrentVC];
                if (standLeftPageController.standLeftCloseBlock) {
                    standLeftPageController.standLeftCloseBlock();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NavBgImage getCurrentVC].navigationController pushViewController:vc animated:YES];
                });
            }else{
                [[NavBgImage getCurrentVC].navigationController pushViewController:vc animated:YES];
            }
        };
        
    }else if ([notfiModel.notifyType isEqualToString:@"AppointOrderBeginNotify"]) {
        //司机开始执行预约订单
        NSString *typeStr = @"预约";
        NSString *msgStr = [NSString stringWithFormat:@"司机开始执行预约订单\n订单类型：%@\n创建时间：%@\n预约时间：%@\n司机姓名：%@\n司机电话：%@\n车牌号：%@\n发货地址：%@\n收货地址：%@",typeStr, notfiModel.createTime, notfiModel.appointTime, notfiModel.driverName, notfiModel.driverPhone, notfiModel.plateNumber, notfiModel.sendAddress, notfiModel.receiveAddress];
        
        if ([[NavBgImage getCurrentVC] isMemberOfClass:[DriverOnWayController class]]) {
            DriverOnWayController *onWayVc = (DriverOnWayController *)[NavBgImage getCurrentVC];
            if ([onWayVc.orderId isEqualToString:notfiModel.orderId]) {
                [onWayVc loadData];
                EBBannerView *banner = [EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
                    make.style = EBBannerViewStyleiOS9;
                    make.icon = [UIImage imageNamed:@"driver_head_default"];
                    make.title = notfiModel.aps.alert;
                    make.content = msgStr;
                    make.stayDuration = 8;
                    make.date = dateStr;
                }];
                [banner show];
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:notfiModel.messageId forKey:@"messageId"];
                [NetWorking bgPostDataWithParameters:param withUrl:@"setMessageRead" withBlock:^(id result) {
                } withFailedBlock:^(NSString *errorResult) {
                }];
                return;
            }
        }
        
        
        
        EBBannerView *banner = [EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
            make.style = EBBannerViewStyleiOS9;
            make.icon = [UIImage imageNamed:@"driver_head_default"];
            make.title = notfiModel.aps.alert;
            make.content = msgStr;
            make.stayDuration = 8;
            make.date = dateStr;
        }];
        [banner show];
        banner.tapActBlock = ^{
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:notfiModel.messageId forKey:@"messageId"];
            [NetWorking bgPostDataWithParameters:param withUrl:@"setMessageRead" withBlock:^(id result) {
            } withFailedBlock:^(NSString *errorResult) {
            }];
            
            DriverOnWayController *onwayVc = [[DriverOnWayController alloc] init];
            onwayVc.orderId = notfiModel.orderId;
            
            [[NavBgImage getCurrentVC].view endEditing:YES];
            if ([NavBgImage judgeCurrentVCIspresented]) {
                [[NavBgImage getCurrentVC] dismissViewControllerAnimated:YES completion:^{
                    [[NavBgImage getCurrentVC].navigationController pushViewController:onwayVc animated:YES];
                }];
            }else if ([[NavBgImage getCurrentVC] isMemberOfClass:[StandLeftPageController class]]){
                StandLeftPageController *standLeftPageController = (StandLeftPageController *)[NavBgImage getCurrentVC];
                if (standLeftPageController.standLeftCloseBlock) {
                    standLeftPageController.standLeftCloseBlock();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NavBgImage getCurrentVC].navigationController pushViewController:onwayVc animated:YES];
                });
            }else{
                [[NavBgImage getCurrentVC].navigationController pushViewController:onwayVc animated:YES];
            }
        };
        
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
