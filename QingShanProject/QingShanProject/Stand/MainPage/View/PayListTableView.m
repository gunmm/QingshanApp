//
//  PayListTableView.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "PayListTableView.h"

@implementation PayListTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    UITableView *thetableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 120)];
    thetableView.dataSource = self;
    thetableView.delegate = self;
    thetableView.rowHeight = 60;
    thetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:thetableView];
}


#pragma mark------ <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PayListCell";
    PayListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PayListCell" owner:nil options:nil] lastObject];
    }
    cell.indexPath = indexPath;
    if (indexPath.row == 0) {
        _currentSelectCell = cell;
        [NavBgImage showIconFontForView:_currentSelectCell.selectBtn iconName:@"\U0000e661" color:mainColor font:15];
        _currentSelectType = @"1";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableViewSelectBlock) {
        self.tableViewSelectBlock(indexPath.row);
    }
    
    PayListCell *celll = (PayListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (_currentSelectCell == celll) {
        return;
    }
    [NavBgImage showIconFontForView:celll.selectBtn iconName:@"\U0000e661" color:mainColor font:15];
    
    [NavBgImage showIconFontForView:_currentSelectCell.selectBtn iconName:@"\U0000e662" color:mainColor font:14];

    _currentSelectCell = celll;
    _currentSelectType = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    
   
}

@end
