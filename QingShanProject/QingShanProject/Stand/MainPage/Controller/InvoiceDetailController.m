//
//  InvoiceDetailController.m
//  QingShanProject
//
//  Created by gunmm on 2018/9/7.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "InvoiceDetailController.h"
#import "InvoiceModel.h"

@interface InvoiceDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) InvoiceModel *model;

@end

@implementation InvoiceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self loadData];
}

- (void)initView {
    self.title = @"发票详情";
    self.view.backgroundColor = bgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _copyyBtn.layer.cornerRadius = 4;
    _copyyBtn.layer.masksToBounds = YES;
    _copyyBtn.layer.borderWidth = 1;
    _copyyBtn.layer.borderColor = bgColor.CGColor;
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.invoiceId forKey:@"invoiceId"];
    [NetWorking postDataWithParameters:param withUrl:@"getInvoiceDetailById" withBlock:^(id result) {
        NSDictionary *objDic = [result objectForKey:@"object"];
        self.model = [InvoiceModel mj_objectWithKeyValues:objDic];
        [self setView];
        [self.tableView reloadData];
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)setView {
    _invoiceStatusLabel.text = [_model.status isEqualToString:@"0"] ?@"待开票":@"已开票";
    _finishTimeLabel.text = [Utils formatDate:[NSDate dateWithTimeIntervalSince1970:_model.finishTime/1000]];
    _invoiceTypeLabel.text = [_model.invoiceType isEqualToString:@"1"] ?@"个人":@"单位";
    _receverNameLabel.text = _model.receiverName;
    [_phoneButton setTitle:_model.receiverPhone forState:UIControlStateNormal];
    _addressLabel.text = _model.receiverAddress;
    if (_model.expressNumber.length > 0) {
        _expressNameLabel.text = _model.expressCompanyName;
        _expressNumberTextF.text = _model.expressNumber;
    }else{
        _expressNameLabel.text = @"暂无";
    }
    _companyNameLabel.text = _model.companyName;
    _companyNumberLabel.text = _model.companyNumber;
    if ([_model.invoiceType isEqualToString:@"1"]) {
        _companyNameLabel.hidden = YES;
        _companyNumberLabel.hidden = YES;
        _companyNameKeyLabel.hidden = YES;
        _companyNumberKeyLabel.hidden = YES;
        _receveTop1.constant = 8;
        _receveType2.constant = 8;
    }else{
        _companyNameLabel.hidden = NO;
        _companyNumberLabel.hidden = NO;
        _companyNameKeyLabel.hidden = NO;
        _companyNumberKeyLabel.hidden = NO;
        _receveTop1.constant = 69;
        _receveType2.constant = 69;
    }
    
}

- (IBAction)phoneBtnAct:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.receiverPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {}];
}

- (IBAction)copyBtnAct:(id)sender {
    [HUDClass showHUDWithText:@"复制成功!"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.expressNumberTextF.text;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if ([_model.invoiceType isEqualToString:@"1"]) {
            return 130;
        }else{
            return 191;
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 25)];
    headView.backgroundColor = bgColor;
    return headView;
}



@end
