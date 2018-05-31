//
//  OrderListController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/27.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "OrderListController.h"
#import "OrderListCell.h"
#import "OrderListRes.h"
#import "OrderModel.h"
#import "SeekViewController.h"
#import "DriverOnWayController.h"
#import "OrderFinshController.h"

@interface OrderListController () <UITableViewDelegate, UITableViewDataSource>
{

}

@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSMutableArray <OrderModel *> *dataList;

@property (nonatomic, strong) NotHaveDataView *notHaveView;


@property (nonatomic, assign) NSInteger currentpage;



@end

@implementation OrderListController

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
    self.title = @"我的订单";
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

    
    [NetWorking postDataWithParameters:param withUrl:@"getOrderList" withBlock:^(id result) {
    
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
    
    [NetWorking postDataWithParameters:param withUrl:@"getOrderList" withBlock:^(id result) {
        
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
    _theTableView.rowHeight = 125;
    [self.view addSubview:_theTableView];
    
    __weak OrderListController *weakSelf = self;
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
    static NSString *identifier = @"OrderListCell";
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderListCell" owner:nil options:nil] lastObject];
    }
    cell.model = _dataList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *model = _dataList[indexPath.row];
    if ([model.status isEqualToString:@"0"]) {
        SeekViewController *seekViewController = [[SeekViewController alloc] init];
        seekViewController.sendPt = CLLocationCoordinate2DMake(model.sendLatitude, model.sendLongitude);;
        seekViewController.createTime = model.createTime;
        seekViewController.orderId = model.orderId;
        [self.navigationController pushViewController:seekViewController animated:YES];
        __weak OrderListController *weakSelf = self;

        seekViewController.seekPopBlock = ^(NSString *orderId, NSString *orderType) {
            if ([orderType isEqualToString:@"1"]) {
                DriverOnWayController *onwayVc = [[DriverOnWayController alloc] init];
                onwayVc.orderId = orderId;
                [weakSelf.navigationController pushViewController:onwayVc animated:YES];
            }
        };
    }else if ([model.status isEqualToString:@"1"]) {
        DriverOnWayController *onwayVc = [[DriverOnWayController alloc] init];
        onwayVc.orderId = model.orderId;
        [self.navigationController pushViewController:onwayVc animated:YES];
        
    }else if ([model.status isEqualToString:@"2"]) {
        DriverOnWayController *onwayVc = [[DriverOnWayController alloc] init];
        onwayVc.orderId = model.orderId;
        [self.navigationController pushViewController:onwayVc animated:YES];
    }else if ([model.status isEqualToString:@"3"]) {
        OrderFinshController *orderFinshController = [[OrderFinshController alloc] init];
        orderFinshController.model = model;
        [self.navigationController pushViewController:orderFinshController animated:YES];
    }
}



@end
