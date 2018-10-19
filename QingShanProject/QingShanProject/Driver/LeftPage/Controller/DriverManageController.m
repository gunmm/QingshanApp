//
//  DriverManageController.m
//  QingShanProject
//
//  Created by gunmm on 2018/10/14.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverManageController.h"
#import "DriverListController.h"
#import "UserModel.h"
#import "DriverManageListCell.h"
#import "DriverDetailController.h"

@interface DriverManageController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSArray <UserModel *> *dataList;

@property (nonatomic, strong) NotHaveDataView *notHaveView;




@end

@implementation DriverManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
    [self loadData];
    
}

- (void)initNavBar {
    self.title = @"我的司机";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *addBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addAct)];
    [addBtnItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:addBtnItem];
    
}

- (void)addAct {
    DriverListController *driverListController = [[DriverListController alloc] init];
    [self.navigationController pushViewController:driverListController animated:YES];
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
    
    [NetWorking postDataWithParameters:param withUrl:@"getDriverBindSmallDriverList" withBlock:^(id result) {
        
        [self.theTableView.mj_header endRefreshing];
        [CommonArrayRes mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"object" : @"UserModel",
                     };
        }];
        CommonArrayRes *commonArrayRes = [CommonArrayRes mj_objectWithKeyValues:result];
        self.dataList = commonArrayRes.object;
        
        
        if (self.dataList.count > 0) {
            [self.notHaveView removeFromSuperview];
        }else{
            [self.notHaveView removeFromSuperview];
            self.notHaveView = [[NotHaveDataView alloc] init];
            self.notHaveView.contentLabel.text = @"暂无司机";
            [NavBgImage showIconFontForView:self.notHaveView.iconLabel iconName:@"\U0000e604" color:[UIColor colorWithRed:66/255.0 green:67/255.0 blue:81/255.0 alpha:0.7] font:60];
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
    _theTableView.rowHeight = 72;
    _theTableView.tableFooterView = [UIView new];
    _theTableView.estimatedRowHeight = 0;
    [self.view addSubview:_theTableView];
    
    __weak typeof(self) weakSelf = self;
    _theTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf performSelector:@selector(loadData) withObject:@"1" afterDelay:1];
    }];
}
#pragma mark -------<UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DriverManageListCell";
    DriverManageListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DriverManageListCell" owner:nil options:nil] lastObject];
    }
    cell.model = _dataList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    __weak typeof(self) weakSelf = self;
    cell.pointBtnActBlock = ^(UserModel *pointUserModel) {
        [weakSelf pointDriver:pointUserModel];
    };
   
    return cell;
}

- (void)pointDriver:(UserModel *)pointUserModel {
    __weak typeof(self) weakSelf = self;
    [AlertView alertViewWithTitle:@"提示" withMessage:[NSString stringWithFormat:@"确认将司机切换为：%@", pointUserModel.nickname] withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
        [param setObject:pointUserModel.userId forKey:@"smallDriverId"];
        [NetWorking postDataWithParameters:param withUrl:@"pointDriverForVehicle" withBlock:^(id result) {
            [HUDClass showHUDWithText:@"切换成功！"];
            [weakSelf loadData];
        } withFailedBlock:^(NSString *errorResult) {
            [HUDClass showHUDWithText:@"切换失败！请重试"];
        }];
        
        
       
        
        
    } withCancelBlock:^{
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DriverInformation" bundle:nil];
    DriverDetailController *driverDetailController = [board instantiateViewControllerWithIdentifier:@"select_driver_info"];
    driverDetailController.model = _dataList[indexPath.row];
    [self.navigationController pushViewController:driverDetailController animated:YES];
    
    __weak typeof(self) weakSelf = self;
    driverDetailController.refreshDriverBlock = ^{
        [weakSelf loadData];
    };
    
}






@end
