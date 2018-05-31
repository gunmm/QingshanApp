//
//  GUNMMCityVC.m
//  ChooseDay
//
//  Created by 闵哲 on 16/1/18.
//  Copyright © 2016年 DreamThreeMusketeers. All rights reserved.
//

#import "GUNMMCityVC.h"
#import "CityCollectionViewCell.h"

static NSString *identifier = @"cell";

static NSString *header = @"header";

static NSString *footer = @"footer";

@interface GUNMMCityVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UITextFieldDelegate>
{
    
    CityBlock _block;
    
    UICollectionView *_collectionView;
    
    //城市数组
    NSArray *_newCityArr;
    
    //筛选前的数组
    NSMutableArray *_oldCityArr;
    
    //检索text
    UITextField *_textField;
}

@end

@implementation GUNMMCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavBar];

    [self initView];
    
}

- (void)initNavBar {
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (IS_IPHONE_5_8 ? 44 : 20)+5, 34, 34)];
    [backBtn setImage:[UIImage imageNamed:@"back3"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAct) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.view addSubview:backBtn];
    
    [self receiveTextValueChange];
    
    UIView *divisionView = [[UIView alloc]initWithFrame:CGRectMake(0, (IS_IPHONE_5_8 ? 44 : 20)+43, kDeviceWidth, 0.5)];
    divisionView.backgroundColor = devide_line_color;
    [self.view addSubview:divisionView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)backAct {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initView {
    
    //添加城市的collectionview
    [self addCollectionView];
}






//接收_textFieldText值改变的通知
- (void)receiveTextValueChange{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(40, (IS_IPHONE_5_8 ? 44 : 20)+7, kDeviceWidth-48, 30)];
        _textField.backgroundColor = bgColor;
        _textField.placeholder = @"请输入城市名";
        _textField.layer.cornerRadius = 6;
        _textField.layer.masksToBounds = YES;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.delegate = self;
        [self.view addSubview:_textField];
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *new_text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];//变化后的字符串
    //创建谓词条件
    NSPredicate *pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self like[C]'*%@*'",new_text_str]];
    //通过谓词条件过滤
    
    _newCityArr = [_oldCityArr filteredArrayUsingPredicate:pred];
    
    NSLog(@"_new = %@",_newCityArr);
    [_collectionView reloadData];
    return YES;
}






//添加城市的collectionview
- (void)addCollectionView{
    
    //1.创建布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //设置单元格大小
    layout.itemSize = CGSizeMake((kDeviceWidth-60)/3, 50);
    
    
    //设置单元格之间的间隙
    layout.minimumLineSpacing = 20;
    
    layout.minimumInteritemSpacing = 10;
    
    //初始化
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, (IS_IPHONE_5_8 ? 44 : 20)+44, kDeviceWidth, kDeviceHeight-((IS_IPHONE_5_8 ? 44 : 20)+44)) collectionViewLayout:layout];
    
    //设置代理和数据源
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    //添加到view
    
    [self.view addSubview:_collectionView];
    
    //注册单元格和头部视图
    [_collectionView registerClass:[CityCollectionViewCell class] forCellWithReuseIdentifier:identifier];
   
    //数据源
    [self loadData];

}

//数据源
- (void)loadData{
    
    //开辟内存
    _oldCityArr = [NSMutableArray array];

    
    //文件路径
    NSString *path = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist"];
    
    //外层字典
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    //数组
    NSArray *result = [dic objectForKey:@"result"];
    
    for (NSDictionary *cityDic in result) {
        
        
        int a = 1;
        
        //查看数组中是否有当前城市
        for (NSString *name in _oldCityArr) {
            if ([name isEqualToString:[cityDic objectForKey:@"city"]]) {
                a = 0;
                
                break;
            }
        }
        
        //如果没有侧添加
        if (a) {
            [_oldCityArr addObject:[cityDic objectForKey:@"city"]];
        }
        
        
    }
    
    _newCityArr = [NSArray arrayWithArray:_oldCityArr];
    
    
    
}


//返回单元格数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _newCityArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
   
    cell.cityName = _newCityArr[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *name = _newCityArr[indexPath.row];
    if (_block) {
        _block(name);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//设置四周间距 上下左右
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//block
- (void)getBlock:(CityBlock)cityBlock{
    _block = cityBlock;
}


@end
