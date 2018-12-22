//
//  FindOrderController.m
//  QingShanProject
//
//  Created by gunmm on 2018/12/22.
//  Copyright © 2018 gunmm. All rights reserved.
//

#import "FindOrderController.h"
#import "OrderModel.h"
#import "OrderListRes.h"
#import "OrderListCell.h"
#import "RobOrderController.h"
#import "DriverOrderDetailController.h"

@interface FindOrderController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSMutableArray <OrderModel *> *dataList;

@property (nonatomic, strong) NotHaveDataView *notHaveView;

@property (nonatomic, assign) NSInteger currentpage;

@end

@implementation FindOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentpage = 0;

    [self initNavBar];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataWithAppear];
}

- (void)initNavBar {
    self.title = @"货源列表";
}

- (void)initTableView {
    _theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - STATUS_AND_NAVBAR_HEIGHT - TABBAR_BOTTOM_HEIGHT) style:UITableViewStylePlain];
    _theTableView.delegate = self;
    _theTableView.dataSource = self;
    _theTableView.tableFooterView = [UIView new];
    _theTableView.estimatedRowHeight = 0;
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

- (void)loadDataWithAppear {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    
    [param setObject:@"0" forKey:@"page"];
    [param setObject:[NSString stringWithFormat:@"%ld",(_currentpage + 1)*10] forKey:@"rows"];
    
    
    [NetWorking postDataWithParameters:param withUrl:@"getFindOrderList" withBlock:^(id result) {
        
        [self.theTableView.mj_header endRefreshing];
        
        [OrderListRes mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"object" : @"OrderModel",
                     };
        }];
        OrderListRes *orderListRes = [OrderListRes mj_objectWithKeyValues:result];
        self.dataList = [orderListRes.object mutableCopy];
        
        
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
    
    [NetWorking postDataWithParameters:param withUrl:@"getFindOrderList" withBlock:^(id result) {
        
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshing];
        
        [OrderListRes mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"object" : @"OrderModel",
                     };
        }];
        OrderListRes *orderListRes = [OrderListRes mj_objectWithKeyValues:result];
        if ([loadType isEqualToString:@"1"]) {
            self.dataList = [orderListRes.object mutableCopy];
        }else {
            if ((orderListRes.object.count > 0)) {
                [self.dataList addObjectsFromArray:orderListRes.object];
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
            [NavBgImage showIconFontForView:self.notHaveView.iconLabel iconName:@"\U0000e61f" color:[UIColor colorWithRed:66/255.0 green:67/255.0 blue:81/255.0 alpha:0.7] font:60];
            self.notHaveView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT);
            
            [self.theTableView addSubview:self.notHaveView];
        }
        
        [self.theTableView reloadData];
        
    } withFailedBlock:^(NSString *errorResult) {
        
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
    cell.statusLabel.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *model = _dataList[indexPath.row];
    if ([model.type isEqualToString:@"1"]) {
        return 125;
    }
    return 145;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RobOrderController *robVc = [[RobOrderController alloc] init];
    robVc.orderId = _dataList[indexPath.row].orderId;
    [self.navigationController pushViewController:robVc animated:YES];
    
    __weak typeof(self) weakSelf = self;
    robVc.robSuccessBlock = ^(NSString *orderId) {
        DriverOrderDetailController *driverOrderDetailController = [[DriverOrderDetailController alloc] init];
        driverOrderDetailController.orderId = orderId;
        [weakSelf.navigationController pushViewController:driverOrderDetailController animated:YES];
    };
}

@end
