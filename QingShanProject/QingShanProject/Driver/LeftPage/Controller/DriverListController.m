//
//  DriverListController.m
//  QingShanProject
//
//  Created by gunmm on 2018/10/14.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverListController.h"
#import "UserModel.h"
#import "DriverManageListCell.h"
#import "MapHeadView.h"
#import "DriverDetailController.h"

@interface DriverListController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, copy) NSString *filterDriverPhone;

@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSMutableArray <UserModel *> *dataList;
@property (nonatomic, strong) NSArray <UserModel *> *dataListAll;


@property (nonatomic, strong) NotHaveDataView *notHaveView;
@property (strong, nonatomic) MapHeadView *mapheadView;






@end

@implementation DriverListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavBar];
    [self initData];
    [self initView];
    [self loadData];

}




- (void)initNavBar {
    self.title = @"添加司机";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mapheadView = [[MapHeadView alloc]initWithFrame:CGRectMake(0, 7, kDeviceWidth-44, 30)];
    _mapheadView.addressLabel.userInteractionEnabled = YES;
    _mapheadView.addressLabel.placeholder = @"搜索手机号";
    _mapheadView.addressLabel.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mapheadView.addressLabel.delegate = self;
    _mapheadView.addressLabel.keyboardType = UIKeyboardTypeNumberPad;
    self.navigationItem.titleView = _mapheadView;
    
    
}

- (void)initData {
}


- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
    
    [NetWorking postDataWithParameters:param withUrl:@"getUnBindSmallDriverList" withBlock:^(id result) {
        
        [self.theTableView.mj_header endRefreshing];
        self.mapheadView.addressLabel.text = @"";
        [self.mapheadView.addressLabel resignFirstResponder];
        [CommonArrayRes mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"object" : @"UserModel",
                     };
        }];
        
        CommonArrayRes *commonArrayRes = [CommonArrayRes mj_objectWithKeyValues:result];
        self.dataListAll = commonArrayRes.object;
        self.dataList = [commonArrayRes.object mutableCopy];
        [self changeNoDataView];
        [self.theTableView reloadData];
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)changeNoDataView {
    if (self.dataList.count > 0) {
        [self.notHaveView removeFromSuperview];
    }else{
        [self.notHaveView removeFromSuperview];
        self.notHaveView = [[NotHaveDataView alloc] init];
        self.notHaveView.contentLabel.text = @"暂无司机";
        [NavBgImage showIconFontForView:self.notHaveView.iconLabel iconName:@"\U0000e61f" color:[UIColor colorWithRed:66/255.0 green:67/255.0 blue:81/255.0 alpha:0.7] font:60];
        self.notHaveView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT);
        
        [self.theTableView addSubview:self.notHaveView];
    }
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
        [weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:1];
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
    cell.isUnBindPage = YES;
    cell.model = _dataList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    __weak typeof(self) weakSelf = self;
    cell.pointBtnActBlock = ^(UserModel *pointUserModel) {
        [weakSelf addDriver:pointUserModel];
    };
    
    return cell;
}

- (void)addDriver:(UserModel *)pointUserModel {
    __weak typeof(self) weakSelf = self;
    [AlertView alertViewWithTitle:@"提示" withMessage:[NSString stringWithFormat:@"确认发送添加验证码给司机：%@ ", pointUserModel.nickname] withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        
        //发送验证码给目标司机
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:pointUserModel.phoneNumber forKey:@"phoneNumber"];
        
        [NetWorking postDataWithParameters:param withUrl:@"sendCodeToSmallDriver" withBlock:^(id result) {
            NSString *securityCode = [result objectForKey:@"object"];
            [HUDClass showHUDWithText:@"验证码发送成功！"];
            [AlertView alertViewWithTitle:@"提示" withMessage:@"验证码发送成功！请联系司机索要验证码" withPlaceholder:@"司机收到的验证码" withType:UIAlertControllerStyleAlert withKeykeyboardType:UIKeyboardTypeNumberPad withTextBlock:^(NSString *text) {
                if ([securityCode isEqualToString:text]) {
                    //车主绑定司机
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    [param setObject:[[Config shareConfig] getUserId] forKey:@"bigDriverId"];
                    [param setObject:pointUserModel.userId forKey:@"smallDriverId"];
                    [NetWorking postDataWithParameters:param withUrl:@"bigDriverBindSmallDriver" withBlock:^(id result) {
                        [HUDClass showHUDWithText:@"添加成功！"];
                        [weakSelf loadData];
                        if (weakSelf.manageListRefrenshBlock) {
                            weakSelf.manageListRefrenshBlock();
                        }
                    } withFailedBlock:^(NSString *errorResult) {
                        [HUDClass showHUDWithText:@"添加失败！请重试"];
                    }];
                }else{
                    [HUDClass showHUDWithText:@"验证码错误！"];
                }
            } withCancelBlock:^{
                
            }];
            
           
        } withFailedBlock:^(NSString *errorResult) {
        }];
      

    } withCancelBlock:^{

    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DriverInformation" bundle:nil];
    DriverDetailController *driverDetailController = [board instantiateViewControllerWithIdentifier:@"select_driver_info"];
    driverDetailController.isAddSmallDriver = YES;
    driverDetailController.model = _dataList[indexPath.row];
    [self.navigationController pushViewController:driverDetailController animated:YES];

    __weak typeof(self) weakSelf = self;
    driverDetailController.refreshDriverBlock = ^{
        [weakSelf loadData];
        if (weakSelf.manageListRefrenshBlock) {
            weakSelf.manageListRefrenshBlock();
        }
    };
    
}


#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self searchWithAddress:@""];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * new_text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];//变化后的字符串
    [self searchWithAddress:new_text_str];
    return YES;
}

- (void)searchWithAddress:(NSString *)phoneNumber
{
    if (phoneNumber.length == 0) {
        _dataList =  [_dataListAll mutableCopy];
        
    }else {
        NSPredicate *predicate= [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"phoneNumber CONTAINS '%@'", phoneNumber]];
        _dataList =  [[_dataListAll filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    [self changeNoDataView];
    
    [self.theTableView reloadData];
}


@end
