//
//  ComplainDetailController.m
//  QingShanProject
//
//  Created by gunmm on 2018/9/8.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "ComplainDetailController.h"
#import "ComplainModel.h"

@interface ComplainDetailController ()

@property (nonatomic, strong) ComplainModel *model;

@end

@implementation ComplainDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self loadData];
}

- (void)initView {
    self.title = @"投诉详情";
    self.view.backgroundColor = bgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.complainId forKey:@"complainId"];
    [param setObject:self.type forKey:@"type"];
    [NetWorking postDataWithParameters:param withUrl:@"getComplainDetailById" withBlock:^(id result) {
        NSDictionary *objDic = [result objectForKey:@"object"];
        self.model = [ComplainModel mj_objectWithKeyValues:objDic];
        [self setView];
        [self.tableView reloadData];
    } withFailedBlock:^(NSString *errorResult) {

    }];
}

- (void)setView {
    _complainStatusLabel.text = [_model.manageStatus isEqualToString:@"0"] ?@"待处理":@"已处理";
    _createTimeLabel.text = [Utils formatDate:[NSDate dateWithTimeIntervalSince1970:_model.createTime/1000]];
    _complainDetailLabel.text = _model.note;
    
    _manageManLabel.text = _model.manageManName;
    _manageTimeLabel.text = [Utils formatDate:[NSDate dateWithTimeIntervalSince1970:_model.updateTime/1000]];
    _manageDetailLabel.text = _model.manageDetail;
    
    if ([_model.manageDriver isEqualToString:@"0"]) {
        _manageDriverLabel.text = @"不作处理";
    }else if ([_model.manageDriver isEqualToString:@"1"]) {
        _manageDriverLabel.text = @"大幅度降低评分值";
    }else {
        _manageDriverLabel.text = @"拉黑司机，拉黑征信";
    }
    
    if ([_model.manageMaster isEqualToString:@"0"]) {
        _manageMasterLabel.text = @"不作处理";
    }else if ([_model.manageMaster isEqualToString:@"1"]) {
        _manageMasterLabel.text = @"大幅度降低评分值";
    }else {
        _manageMasterLabel.text = @"拉黑货主，拉黑征信";
    }
    
    if ([_model.manageOrder isEqualToString:@"0"]) {
        _manageOrderStatusLabel.text = @"不作处理";
    }else if ([_model.manageOrder isEqualToString:@"1"]) {
        _manageOrderStatusLabel.text = @"取消订单，相对应退款";
    }else {
        _manageOrderStatusLabel.text = @"订单置为异常，相对应退款";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_model.manageStatus isEqualToString:@"0"]) {
        return 2;
    }
    return [super numberOfSectionsInTableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_model) {
        if (indexPath.section == 1) {
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth - 119, 0)];
            label1.font = [UIFont boldSystemFontOfSize:15];
            label1.text = _model.note;
            
            label1.numberOfLines = 0;
            [label1 sizeToFit];
            
            return 51.5 + label1.height;
        }else if (indexPath.section == 2) {
            if ([_model.manageStatus isEqualToString:@"0"]) {
                return 0;
            }
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth - 119, 0)];
            label1.font = [UIFont boldSystemFontOfSize:15];
            label1.text = _model.manageDetail;
            
            label1.numberOfLines = 0;
            [label1 sizeToFit];
            
            return 167 + label1.height;
        }
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 20)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kDeviceWidth-20, 20)];
    if (section == 0) {
        titleLabel.text = @"状态";
    }else if (section == 1){
        titleLabel.text = @"投诉详情";
    }else if (section == 2){
        titleLabel.text = @"处理详情";
    }
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = mainColor;
    [headView addSubview:titleLabel];
    headView.backgroundColor = bgColor;
    return headView;
}

@end
