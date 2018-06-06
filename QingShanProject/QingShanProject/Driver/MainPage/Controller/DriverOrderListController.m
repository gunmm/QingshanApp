//
//  DriverOrderListController.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/4.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverOrderListController.h"
#import "OrderListRes.h"
#import "OrderModel.h"
#import "DriverOrderListCell.h"
#import "DriverOrderDetailController.h"

@interface DriverOrderListController () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSMutableArray <OrderModel *> *dataList;

@property (nonatomic, strong) NotHaveDataView *notHaveView;

@property (nonatomic, assign) NSInteger currentpage;

@end

@implementation DriverOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavBar];
    [self initData];
    [self initView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataWithAppear];
}

- (void)initNavBar {
    self.title = @"订单列表";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initData {
    _currentpage = 0;
}

- (void)loadDataWithAppear {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    [param setObject:@"0" forKey:@"page"];
    [param setObject:[NSString stringWithFormat:@"%ld",(_currentpage + 1)*10] forKey:@"rows"];
    
    
    [NetWorking postDataWithParameters:param withUrl:@"getDriverOrderList" withBlock:^(id result) {
        
        [self.theTableView.mj_header endRefreshing];
        
        [OrderListRes mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"object" : @"OrderModel",
                     };
        }];
        OrderListRes *orderListRes = [OrderListRes mj_objectWithKeyValues:result];
        if (orderListRes.object.count > 0) {
            self.dataList = [orderListRes.object mutableCopy];
        }else {
            [HUDClass showHUDWithText:@"没有更多数据！"];
        }
        
        if (self.dataList.count > 0) {
            [self.notHaveView removeFromSuperview];
        }else{
            [self.notHaveView removeFromSuperview];
            self.notHaveView = [[NotHaveDataView alloc] init];
            self.notHaveView.contentLabel.text = @"暂无订单";
            [NavBgImage showIconFontForView:self.notHaveView.iconLabel iconName:@"\U0000e61f" color:[UIColor colorWithRed:66/255.0 green:67/255.0 blue:81/255.0 alpha:0.7] font:60];
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
    
    [NetWorking postDataWithParameters:param withUrl:@"getDriverOrderList" withBlock:^(id result) {
        
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshing];
        
        [OrderListRes mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"object" : @"OrderModel",
                     };
        }];
        OrderListRes *orderListRes = [OrderListRes mj_objectWithKeyValues:result];
        if (orderListRes.object.count > 0) {
            if ([loadType isEqualToString:@"1"]) {
                self.dataList = [orderListRes.object mutableCopy];
            }else{
                [self.dataList addObjectsFromArray:orderListRes.object];
            }
            
        }else {
            [HUDClass showHUDWithText:@"没有更多数据！"];
        }
        
        if (self.dataList.count > 0) {
            [self.notHaveView removeFromSuperview];
        }else{
            [self.notHaveView removeFromSuperview];
            self.notHaveView = [[NotHaveDataView alloc] init];
            self.notHaveView.contentLabel.text = @"暂无订单";
            [NavBgImage showIconFontForView:self.notHaveView.iconLabel iconName:@"\U0000e61f" color:[UIColor colorWithRed:66/255.0 green:67/255.0 blue:81/255.0 alpha:0.7] font:60];
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
    _theTableView.tableFooterView = [UIView new];
    [self.view addSubview:_theTableView];
    
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
    static NSString *identifier = @"DriverOrderListCell";
    DriverOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DriverOrderListCell" owner:nil options:nil] lastObject];
    }
    cell.model = _dataList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak typeof(self) weakSelf = self;
    
    
    cell.beginAppointOrderBlock = ^(OrderModel *model) {
        [weakSelf beginAppointOrderWithModel:model];
    };
    
    
    cell.reciverGoodsBlock = ^(OrderModel *model) {
        [weakSelf updateOrderWithModel:model withStatus:@"2"];
    };
    
    cell.finishOrderBlock = ^(OrderModel *model) {
        [weakSelf updateOrderWithModel:model withStatus:@"3"];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *model = _dataList[indexPath.row];
    if ([model.type isEqualToString:@"1"]) {
        return 204;
    }
    return 226;
}


- (void)beginAppointOrderWithModel:(OrderModel *)model {
    [AlertView alertViewWithTitle:@"提示" withMessage:@"确认开始执行该预约订单" withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
        [param setObject:model.orderId forKey:@"orderId"];
        
        [NetWorking postDataWithParameters:param withUrl:@"setAppointOrderBegin" withBlock:^(id result) {
            [self loadDataWithAppear];
        } withFailedBlock:^(NSString *errorResult) {
            
        }];
    } withCancelBlock:^{
        
    }];
    
}


- (void)updateOrderWithModel:(OrderModel *)model withStatus:(NSString *)status {
    
    [AlertView alertViewWithTitle:@"提示" withMessage:[NSString stringWithFormat:@"%@", [status isEqualToString:@"2"] ? @"确认接到货物" : @"确认订单完成"] withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:model.orderId forKey:@"orderId"];
        [param setObject:status forKey:@"status"];
        
        [NetWorking postDataWithParameters:param withUrl:@"updateOrderStatus" withBlock:^(id result) {
            [self loadDataWithAppear];
            
        } withFailedBlock:^(NSString *errorResult) {
            
        }];
    } withCancelBlock:^{
        
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DriverOrderDetailController *driverOrderDetailController = [[DriverOrderDetailController alloc] init];
    driverOrderDetailController.orderId = _dataList[indexPath.row].orderId;
    [self.navigationController pushViewController:driverOrderDetailController animated:YES];
    
}



@end
