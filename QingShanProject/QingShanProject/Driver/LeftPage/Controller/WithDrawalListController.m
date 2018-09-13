//
//  WithDrawalListController.m
//  QingShanProject
//
//  Created by gunmm on 2018/8/26.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "WithDrawalListController.h"
#import "DriverWithdrawalListModel.h"
#import "DriverWithdrawalRes.h"
#import "WithdrawalListCell.h"
#import "WalletController.h"

@interface WithDrawalListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSMutableArray <DriverWithdrawalListModel *> *dataList;

@property (nonatomic, strong) NotHaveDataView *notHaveView;

@property (nonatomic, assign) NSInteger currentpage;

@end

@implementation WithDrawalListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
    [self initData];
    [self loadDataWithAppear];
}

- (void)initNavBar {
    self.title = @"申请提现列表";
}

- (void)initData {
    _currentpage = 0;
}

- (void)loadDataWithAppear {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
    [param setObject:@"0" forKey:@"page"];
    [param setObject:[NSString stringWithFormat:@"%ld",(_currentpage + 1)*10] forKey:@"rows"];
    
    
    [NetWorking postDataWithParameters:param withUrl:@"queryMobileDriverWithDrawalList" withBlock:^(id result) {
        
        [self.theTableView.mj_header endRefreshing];
        
        [DriverWithdrawalRes mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"object" : @"DriverWithdrawalListModel",
                     };
        }];
        DriverWithdrawalRes *driverWithdrawalRes = [DriverWithdrawalRes mj_objectWithKeyValues:result];
        self.dataList = [driverWithdrawalRes.object mutableCopy];
        
        
        if (self.dataList.count > 0) {
            [self.notHaveView removeFromSuperview];
        }else{
            [self.notHaveView removeFromSuperview];
            self.notHaveView = [[NotHaveDataView alloc] init];
            self.notHaveView.contentLabel.text = @"暂无记录";
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
    [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
    [param setObject:[NSString stringWithFormat:@"%ld",_currentpage] forKey:@"page"];
    [param setObject:@"10" forKey:@"rows"];
    
    [NetWorking postDataWithParameters:param withUrl:@"queryMobileDriverWithDrawalList" withBlock:^(id result) {
        
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshing];
        
        [DriverWithdrawalRes mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"object" : @"DriverWithdrawalListModel",
                     };
        }];
        DriverWithdrawalRes *driverWithdrawalRes = [DriverWithdrawalRes mj_objectWithKeyValues:result];
        if ([loadType isEqualToString:@"1"]) {
            self.dataList = [driverWithdrawalRes.object mutableCopy];
        }else {
            if ((driverWithdrawalRes.object.count > 0)) {
                [self.dataList addObjectsFromArray:driverWithdrawalRes.object];
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

- (void)initView {
    _theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - STATUS_AND_NAVBAR_HEIGHT) style:UITableViewStylePlain];
    _theTableView.delegate = self;
    _theTableView.dataSource = self;
    _theTableView.tableFooterView = [UIView new];
    _theTableView.rowHeight = 125;
    _theTableView.estimatedRowHeight = 0;
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    static NSString *identifier = @"WithdrawalListCell";
    WithdrawalListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WithdrawalListCell" owner:nil options:nil] lastObject];
    }
    cell.model = _dataList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WalletController *walletController = [[WalletController alloc] init];
    walletController.driverWithdrawalId = _dataList[indexPath.row].driverWithdrawalId;
    walletController.driverWithdrawalAmount = _dataList[indexPath.row].driverWithdrawalAmount;
    walletController.driverWithdrawalStatus = _dataList[indexPath.row].driverWithdrawalStatus;


    [self.navigationController pushViewController:walletController animated:YES];
    
}



@end
