//
//  SelectAddressController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/11.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "SelectAddressController.h"
#import "MapHeadView.h"
#import "SelectAddressCell.h"
#import "IQKeyboardManager.h"
#import "SelectAddressHeadView.h"
#import "GUNMMCityVC.h"





@interface SelectAddressController () <UITextFieldDelegate, BMKPoiSearchDelegate, UITableViewDelegate, UITableViewDataSource>
{
    
    NotHaveDataView *_notHaveView;
    


}

@property (strong, nonatomic) BMKPoiSearch *poiSearch;

@property (strong, nonatomic) UITableView *theTableView;
@property (strong, nonatomic) SelectAddressHeadView *selectAddressHeadView;
@property (strong, nonatomic) MapHeadView *mapheadView;

@property (nonatomic, assign) NSInteger currentPage;




@end

@implementation SelectAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self initNavBar];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _poiSearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _poiSearch.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_beginSerchString.length > 0) {
        _mapheadView.addressLabel.text = _beginSerchString;
        [self searchWithAddress:_beginSerchString];
    }
    [_mapheadView.addressLabel becomeFirstResponder];

    
}

- (void)initNavBar {
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (IS_IPHONE_5_8 ? 44 : 20)+5, 34, 34)];
    [backBtn setImage:[UIImage imageNamed:@"back3"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAct) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.view addSubview:backBtn];
    
    _mapheadView = [[MapHeadView alloc]initWithFrame:CGRectMake(40, (IS_IPHONE_5_8 ? 44 : 20) + 7, kDeviceWidth-54, 30)];
    _mapheadView.addressLabel.userInteractionEnabled = YES;
    _mapheadView.addressLabel.delegate = self;
    [self.view addSubview:_mapheadView];
    
    UIView *divisionView = [[UIView alloc]initWithFrame:CGRectMake(0, (IS_IPHONE_5_8 ? 44 : 20)+45, kDeviceWidth, 0.5)];
    divisionView.backgroundColor = devide_line_color;
    [self.view addSubview:divisionView];
    self.view.backgroundColor = [UIColor whiteColor];
    _currentPage = 0;
    
}

- (void)backAct {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initView {
    [self initTableView];
    [self initPoiSearch];

}

- (void)initTableView {
    _theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVBAR_HEIGHT+2, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT-2) style:UITableViewStylePlain];
    _theTableView.delegate = self;
    _theTableView.dataSource = self;
    _theTableView.estimatedRowHeight = 0;
    
    _theTableView.tableFooterView = [UIView new];
    
    [self.view addSubview:_theTableView];
    
    __weak typeof(self) weakSelf = self;
    _theTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf performSelector:@selector(searchWithAddress:) withObject:weakSelf.mapheadView.addressLabel.text afterDelay:1];
    }];
   
    
    
    
    
    
    if (_addressArray.count > 0) {
        [_notHaveView removeFromSuperview];
    }else{
        [_notHaveView removeFromSuperview];
        _notHaveView = [[NotHaveDataView alloc] init];
        _notHaveView.contentLabel.text = @"未检索到关键字";
        [NavBgImage showIconFontForView:_notHaveView.iconLabel iconName:@"\U0000e647" color:[UIColor colorWithRed:66/255.0 green:67/255.0 blue:81/255.0 alpha:0.7] font:60];
        _notHaveView.frame = CGRectMake(0, 50, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT-50);

        [_theTableView addSubview:_notHaveView];
    }
    
    
    _selectAddressHeadView = [[[NSBundle mainBundle] loadNibNamed:@"SelectAddressHeadView" owner:nil options:nil] lastObject];
    _selectAddressHeadView.frame =CGRectMake(0, 0, kDeviceWidth, 50);
    _theTableView.tableHeaderView = _selectAddressHeadView;
    
    [_selectAddressHeadView.cityBtn setTitle:_nowCityString forState:UIControlStateNormal];
    _selectAddressHeadView.cityBtnBlock = ^{
        GUNMMCityVC *cityVc = [[GUNMMCityVC alloc] init];
        [weakSelf presentViewController:cityVc animated:YES completion:nil];
        [cityVc getBlock:^(NSString *cityName) {
            [weakSelf.selectAddressHeadView.cityBtn setTitle:[NSString stringWithFormat:@"%@市", cityName] forState:UIControlStateNormal];
            weakSelf.beginSerchString = @"";
            weakSelf.mapheadView.addressLabel.text = @"";
            if (weakSelf.cityNameBlock) {
                weakSelf.cityNameBlock([NSString stringWithFormat:@"%@市", cityName]);
            }
        }];
    };
}

- (void)initPoiSearch
{
    _poiSearch = [[BMKPoiSearch alloc] init];
}

- (void)searchWithAddress:(NSString *)address
{
    BMKPOICitySearchOption *option = [[BMKPOICitySearchOption alloc] init];
    option.pageIndex = _currentPage;
    option.pageSize = 20;
    option.city = _selectAddressHeadView.cityBtn.titleLabel.text;
    option.keyword = address;
    
    BOOL result = [_poiSearch poiSearchInCity:option];
    
    if (!result)
    {
        
    }
}



#pragma mark -- BMKSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode {
   
    [self.theTableView.mj_footer endRefreshing];
    if (errorCode == BMK_SEARCH_NO_ERROR)
    {
        if (_currentPage == 0) {
            if (_oldArray.count == 0) {
                _addressArray = [NSMutableArray arrayWithArray:poiResult.poiInfoList];
            }else{
                _addressArray = [NSMutableArray arrayWithArray:_oldArray];
                [_addressArray addObjectsFromArray:poiResult.poiInfoList];
            }
        }else {
            [_addressArray addObjectsFromArray:poiResult.poiInfoList];
        }
        
        [_theTableView reloadData];
        
        if (_addressArray.count > 0) {
            [_notHaveView removeFromSuperview];
        }else{
            [_notHaveView removeFromSuperview];
            _notHaveView = [[NotHaveDataView alloc] init];
            _notHaveView.contentLabel.text = @"未检索到关键字";
            _notHaveView.frame = CGRectMake(0, 50, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT-50);
            [NavBgImage showIconFontForView:_notHaveView.iconLabel iconName:@"\U0000e647" color:[UIColor colorWithRed:66/255.0 green:67/255.0 blue:81/255.0 alpha:0.7] font:60];
            _notHaveView.backgroundColor = [UIColor whiteColor];

            [_theTableView addSubview:_notHaveView];
        }
    }
    else
    {
        
    }
}


#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * new_text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];//变化后的字符串
    _oldArray = nil;
    _currentPage = 0;
    [self searchWithAddress:new_text_str];
    return YES;
}



#pragma mark --  UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SelectAddressCell";
    SelectAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SelectAddressCell" owner:nil options:nil]lastObject];
    }
    BMKPoiInfo *info = _addressArray[indexPath.row];
    cell.nameLabel.text = info.name;
    cell.addressLabel.text = info.address;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BMKPoiInfo *info = _addressArray[indexPath.row];
    if (self.cellClickBlock) {
        [self dismissViewControllerAnimated:YES completion:^{
            NSString *detailAddress = @"";
            if ([(DIRECTLY_CITY_ARRAY) containsObject:info.city]) {
                if (info.city && info.area) {
                    detailAddress = [NSString stringWithFormat:@"%@%@", info.city, info.area];
                }else {
                    detailAddress = self.selectAddressHeadView.cityBtn.currentTitle;
                }
                
            }else{
                if (info.province && info.city && info.area) {
                    detailAddress = [NSString stringWithFormat:@"%@%@%@", info.province, info.city, info.area];
                }else {
                    detailAddress = self.selectAddressHeadView.cityBtn.currentTitle;
                }
            }
            
            self.cellClickBlock(info.name, detailAddress, info.pt);
        }];
    }
}



@end
