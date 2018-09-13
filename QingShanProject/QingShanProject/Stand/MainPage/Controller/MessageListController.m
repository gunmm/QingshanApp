//
//  MessageListController.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/4.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "MessageListController.h"
#import "MessageListRes.h"
#import "MessageModel.h"
#import "MessageListCell.h"
#import "DriverOrderDetailController.h"
#import "OrderFinshController.h"
#import "DriverOnWayController.h"
#import "RobOrderController.h"
#import "SeekViewController.h"
#import "FinishOrderRes.h"

@interface MessageListController () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSMutableArray <MessageModel *> *dataList;

@property (nonatomic, strong) NotHaveDataView *notHaveView;
@property (nonatomic, assign) NSInteger currentpage;

@end

@implementation MessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataWithAppear];
}

- (void)initNavBar {
    self.title = @"消息记录";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)loadDataWithAppear {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    [param setObject:@"0" forKey:@"page"];
    [param setObject:[NSString stringWithFormat:@"%ld",(_currentpage + 1)*10] forKey:@"rows"];


    [NetWorking postDataWithParameters:param withUrl:@"getMessageList" withBlock:^(id result) {

        [self.theTableView.mj_header endRefreshing];

        [MessageListRes mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"object" : @"MessageModel",
                     };
        }];
        MessageListRes *messageListRes = [MessageListRes mj_objectWithKeyValues:result];
        self.dataList = [messageListRes.object mutableCopy];

        if (self.dataList.count > 0) {
            [self.notHaveView removeFromSuperview];
        }else{
            [self.notHaveView removeFromSuperview];
            self.notHaveView = [[NotHaveDataView alloc] init];
            self.notHaveView.contentLabel.text = @"暂未收到消息";
            [NavBgImage showIconFontForView:self.notHaveView.iconLabel iconName:@"\U0000e610" color:[UIColor colorWithRed:66/255.0 green:67/255.0 blue:81/255.0 alpha:0.7] font:60];
            self.notHaveView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT);

            [self.theTableView addSubview:self.notHaveView];
        }


        [self.theTableView reloadData];

    } withFailedBlock:^(NSString *errorResult) {

    }];
}

- (void)loadDataWithType:(NSString *)loadType {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    [param setObject:[NSString stringWithFormat:@"%ld",_currentpage] forKey:@"page"];
    [param setObject:@"10" forKey:@"rows"];

    [NetWorking postDataWithParameters:param withUrl:@"getMessageList" withBlock:^(id result) {

        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshing];

        [MessageListRes mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"object" : @"MessageModel",
                     };
        }];
        MessageListRes *messageListRes = [MessageListRes mj_objectWithKeyValues:result];
        
        if ([loadType isEqualToString:@"1"]) {
            self.dataList = [messageListRes.object mutableCopy];
        }else {
            if ((messageListRes.object.count > 0)) {
                [self.dataList addObjectsFromArray:messageListRes.object];
            }else{
                [HUDClass showHUDWithText:@"没有更多数据！"];
            }
        }
        

        if (self.dataList.count > 0) {
            [self.notHaveView removeFromSuperview];
        }else{
            [self.notHaveView removeFromSuperview];
            self.notHaveView = [[NotHaveDataView alloc] init];
            self.notHaveView.contentLabel.text = @"暂无订单";
            [NavBgImage showIconFontForView:self.notHaveView.iconLabel iconName:@"\U0000e610" color:[UIColor colorWithRed:66/255.0 green:67/255.0 blue:81/255.0 alpha:0.7] font:60];
            self.notHaveView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT);

            [self.theTableView addSubview:self.notHaveView];
        }

        [self.theTableView reloadData];

    } withFailedBlock:^(NSString *errorResult) {

    }];
}

- (void)initView {
    [self initTableView];
}



- (void)initTableView {
    _theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - STATUS_AND_NAVBAR_HEIGHT) style:UITableViewStylePlain];
    _theTableView.delegate = self;
    _theTableView.dataSource = self;
    _theTableView.rowHeight = 122;
    _theTableView.estimatedRowHeight = 0;
    _theTableView.tableFooterView = [UIView new];
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_theTableView];
    
    _theTableView.backgroundColor = bgColor;
    
    __weak typeof(self) weakSelf = self;
    _theTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentpage = 0;
        [weakSelf performSelector:@selector(loadDataWithType:) withObject:@"1" afterDelay:1];
    }];
    
    _theTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentpage++;
        [weakSelf performSelector:@selector(loadDataWithType:) withObject:@"2" afterDelay:1];
    }];
}



#pragma mark -------<UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MessageListCell";
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageListCell" owner:nil options:nil] lastObject];
    }
    cell.model = _dataList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_dataList[indexPath.row].messageId forKey:@"messageId"];
    [NetWorking bgPostDataWithParameters:param withUrl:@"setMessageRead" withBlock:^(id result) {
    } withFailedBlock:^(NSString *errorResult) {
    }];
    
    
    if ([[[Config shareConfig] getType] isEqualToString:@"5"]) {
        MessageModel *model = _dataList[indexPath.row];
        if ([model.orderStatus isEqualToString:@"0"] || [model.orderStatus isEqualToString:@"1"]) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:model.orderId forKey:@"orderId"];
            [NetWorking bgPostDataWithParameters:param withUrl:@"getBigOrderInfo" withBlock:^(id result) {
                FinishOrderRes *finishOrderRes = [FinishOrderRes mj_objectWithKeyValues:result];
                if ([finishOrderRes.object.status isEqualToString:@"0"] || [finishOrderRes.object.status isEqualToString:@"1"]) {
                    SeekViewController *seekViewController = [[SeekViewController alloc] init];
                    seekViewController.sendPt = CLLocationCoordinate2DMake(finishOrderRes.object.sendLatitude, finishOrderRes.object.sendLongitude);;
                    seekViewController.createTime = finishOrderRes.object.createTime;
                    seekViewController.orderId = model.orderId;
                    [self.navigationController pushViewController:seekViewController animated:YES];
                }else{
                    DriverOnWayController *onwayVc = [[DriverOnWayController alloc] init];
                    onwayVc.orderId = model.orderId;
                    [self.navigationController pushViewController:onwayVc animated:YES];
                }
                
                
               
            } withFailedBlock:^(NSString *errorResult) {
                
            }];
            
           
        }else {
            DriverOnWayController *onwayVc = [[DriverOnWayController alloc] init];
            onwayVc.orderId = model.orderId;
            [self.navigationController pushViewController:onwayVc animated:YES];
        }

    }else {
        if ([_dataList[indexPath.row].messageType isEqualToString:@"newOrderNotify"]) {
            RobOrderController *robVc = [[RobOrderController alloc] init];
            robVc.orderId = _dataList[indexPath.row].orderId;
            [self.navigationController pushViewController:robVc animated:YES];
            __weak typeof(self) weakSelf = self;

            robVc.robSuccessBlock = ^(NSString *orderId) {
                DriverOrderDetailController *driverOrderDetailController = [[DriverOrderDetailController alloc] init];
                driverOrderDetailController.orderId = orderId;
                [weakSelf.navigationController pushViewController:driverOrderDetailController animated:YES];
            };
        }else {
            DriverOrderDetailController *driverOrderDetailController = [[DriverOrderDetailController alloc] init];
            driverOrderDetailController.orderId = _dataList[indexPath.row].orderId;
            [self.navigationController pushViewController:driverOrderDetailController animated:YES];
        }
    }
}


@end
