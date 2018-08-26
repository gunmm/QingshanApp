//
//  WalletController.m
//  QingShanProject
//
//  Created by gunmm on 2018/8/26.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "WalletController.h"
#import "OrderModel.h"
#import "WalletListCell.h"
#import "DriverOrderDetailController.h"
#import "WalletListRes.h"
#import "WalletListHeadView.h"
#import "WithDrawalListController.h"
#import "DriverWithdrawalRes.h"

@interface WalletController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSArray <OrderModel *> *dataList;

@property (nonatomic, strong) NotHaveDataView *notHaveView;

@property (nonatomic, strong) WalletListHeadView *walletListHeadView;

@property (nonatomic, strong) WalletListRes *walletListRes;


@end

@implementation WalletController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavBar];
    [self initView];
    [self loadData];
}

- (void)initNavBar {
    self.title = @"钱包";
    UIBarButtonItem *listBtn = [[UIBarButtonItem alloc]initWithTitle:@"提现列表" style:UIBarButtonItemStylePlain target:self action:@selector(listBtnClicked)];
    [listBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self.navigationItem setRightBarButtonItem:listBtn];
}

- (void)listBtnClicked {
    WithDrawalListController *withDrawalListController = [[WithDrawalListController alloc] init];
    [self.navigationController pushViewController:withDrawalListController animated:YES];
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *urlStr = @"";
    if (_driverWithdrawalId) {
        [param setObject:_driverWithdrawalId forKey:@"driverWithdrawalId"];
        urlStr = @"getMobileDriverWithdrawalOrderList";
    }else{
        [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
        urlStr = @"queryDriverWithDrawalOrderListAndAmount";
    }
    
    
    [NetWorking postDataWithParameters:param withUrl:urlStr withBlock:^(id result) {
        
        [self.theTableView.mj_header endRefreshing];
        
        if (self.driverWithdrawalId) {
            [DriverWithdrawalRes mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"object" : @"OrderModel",
                         };
            }];
            DriverWithdrawalRes *driverWithdrawalRes = [DriverWithdrawalRes mj_objectWithKeyValues:result];
            self.dataList = [driverWithdrawalRes.object mutableCopy];
            
            self.walletListHeadView.totalAmountLabel.text = [NSString stringWithFormat:@"¥ %@", self.driverWithdrawalAmount];
            [self.walletListHeadView.withdrawalBtn setBackgroundColor:[UIColor grayColor]];
            [self.walletListHeadView.withdrawalBtn setTitleColor:bgColor forState:UIControlStateNormal];
            self.walletListHeadView.withdrawalBtn.enabled = NO;
            if ([self.driverWithdrawalStatus isEqualToString:@"0"]) {
                [self.walletListHeadView.withdrawalBtn setTitle:@"已提交" forState:UIControlStateNormal];
            }else {
                [self.walletListHeadView.withdrawalBtn setTitle:@"已打款" forState:UIControlStateNormal];
            }
            
        }else{
            [WalletListRes mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"orderList" : @"OrderModel",
                         };
            }];
            self.walletListRes = [WalletListRes mj_objectWithKeyValues:[result objectForKey:@"object"]];
            self.dataList = [self.walletListRes.orderList mutableCopy];
            
            self.walletListHeadView.totalAmountLabel.text = [NSString stringWithFormat:@"¥ %.2f", self.walletListRes.orderAmount];
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
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_theTableView];
    
    __weak typeof(self) weakSelf = self;
    _theTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:1];
    }];
    
    
    _walletListHeadView = [[[NSBundle mainBundle] loadNibNamed:@"WalletListHeadView" owner:nil options:nil] lastObject];
    _walletListHeadView.frame = CGRectMake(0, 0, kDeviceWidth, 180);
    _theTableView.tableHeaderView = _walletListHeadView;
    
    _walletListHeadView.withdrawalActBlock = ^{
        [weakSelf withdrawalAct];
    };
    
}

- (void)withdrawalAct {
    if ([[Config shareConfig] getBankCardNumber].length == 0) {
        [AlertView alertViewWithTitle:@"提示" withMessage:@"银行卡未绑定！ 请先到个人信息设置页面绑定银行卡" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        }];
        return;
    }
    
    if (self.walletListRes.orderAmount == 0) {
        [HUDClass showHUDWithText:@"暂无提现额度！"];
        return;
    }
    [AlertView alertViewWithTitle:@"提示" withMessage:@"提现操作后七个工作日内系统会汇款到您绑定的银行卡内" withConfirmTitle:@"确认提现" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
        NSMutableDictionary *driverWithdrawal = [NSMutableDictionary dictionary];
        [driverWithdrawal setObject:[NSString stringWithFormat:@"%.2f", self.walletListRes.orderAmount] forKey:@"driverWithdrawalAmount"];
        [driverWithdrawal setObject:[[Config shareConfig] getBankCardNumber] forKey:@"toBankNumber"];
        [driverWithdrawal setObject:[[Config shareConfig] getUserId] forKey:@"toUserId"];
        [driverWithdrawal setObject:@"0" forKey:@"driverWithdrawalStatus"];
        
        NSDate *date = [NSDate new];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [driverWithdrawal setObject:[dateFormatter stringFromDate:date] forKey:@"driverWithdrawalTime"];

        [param setObject:driverWithdrawal forKey:@"driverWithdrawal"];
        
        [NetWorking postDataWithParameters:param withUrl:@"addDriverWithdrawal" withBlock:^(id result) {
            [HUDClass showHUDWithText:@"操作成功！"];
            [self loadData];
        } withFailedBlock:^(NSString *errorResult) {
            
        }];
    } withCancelBlock:^{
        
    }];
    
}

#pragma mark -------<UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"WalletListCell";
    WalletListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WalletListCell" owner:nil options:nil] lastObject];
    }
    cell.model = _dataList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth - 20, 0)];
    label1.font = [UIFont boldSystemFontOfSize:17];
    OrderModel *model = _dataList[indexPath.row];
    label1.text = model.orderId;

    label1.numberOfLines = 0;
    [label1 sizeToFit];
   
    return 135 + label1.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DriverOrderDetailController *driverOrderDetailController = [[DriverOrderDetailController alloc] init];
    driverOrderDetailController.orderId = _dataList[indexPath.row].orderId;
    [self.navigationController pushViewController:driverOrderDetailController animated:YES];
    
}



@end
