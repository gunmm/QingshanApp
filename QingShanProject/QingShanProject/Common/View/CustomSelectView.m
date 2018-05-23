//
//  CustomSelectView.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "CustomSelectView.h"

@interface CustomSelectView () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) UIView *functionView;
@property (nonatomic,strong) UIPickerView *sexPickView;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UIPickerView *cityPickView;

@property (nonatomic,copy) NSArray *provinces;
@property (nonatomic,copy) NSArray *cities;
@property (nonatomic,copy) NSArray *areas;

@property (nonatomic) UIDatePickerMode datePickerMode;

@end

@implementation CustomSelectView

+ (instancetype)customSelectView {
    static CustomSelectView *csv = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        csv = [[CustomSelectView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        
        //Add Masterview
        UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        masterView.alpha = 0.5f;
        masterView.backgroundColor = [UIColor grayColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:csv action:@selector(handleTap:)];
        [masterView addGestureRecognizer:tap];
        [csv addSubview:masterView];
        
        //Add FunctionView
        
        //UIPickerView的高度始终固定为三个尺寸162.0，180.0，216.0
        csv.functionView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, 162 + 40)];
        csv.functionView.alpha = 1.0f;
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:csv action:@selector(hide)];
        cancel.width = kDeviceWidth / 3;
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:csv action:@selector(done)];
        done.width = kDeviceWidth / 3;
        //        done.tintColor = [UIColor redColor];
        UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:csv action:@selector(clear)];
        clear.width = kDeviceWidth / 3;
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [toolbar setItems:@[flexibleSpace, cancel, done, clear, flexibleSpace]];
        
        [csv.functionView addSubview:toolbar];
        
        //Functionview add Sex pickerview
        csv.sexPickView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        csv.sexPickView.delegate = csv;
        csv.sexPickView.dataSource = csv;
        csv.sexPickView.backgroundColor = [UIColor whiteColor];
        csv.sexPickView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        csv.sexPickView.frame = CGRectMake(0, 40, kDeviceWidth,162);
        [csv.functionView addSubview:csv.sexPickView];
        
        //FunctionView add Date pickerview
        csv.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, kDeviceWidth, 162)];
        csv.datePicker.backgroundColor = [UIColor whiteColor];
        csv.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        csv.datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:20 * 365 * 24 * 60 * 60 * -1];
        
        [csv.functionView addSubview:csv.datePicker];
        
        //FunctionView add city pickerview
        csv.cityPickView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        csv.cityPickView.delegate = csv;
        csv.cityPickView.dataSource = csv;
        csv.cityPickView.backgroundColor = [UIColor whiteColor];
        csv.cityPickView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        csv.cityPickView.frame = CGRectMake(0, 40, kDeviceWidth,162);
        [csv.functionView addSubview:csv.cityPickView];
        
        [csv addSubview:csv.functionView];
        
    });
    return csv;
}

- (void)handleTap:(UIPanGestureRecognizer *)gesture {
    [self hide];
}

//显示性别选择
- (void)showSexChooser {
    
    [self setHidden:NO];
    
    [self.datePicker setHidden:YES];
    [self.cityPickView setHidden:YES];
    [self.sexPickView setHidden:NO];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.functionView.frame = CGRectMake(0, kDeviceHeight - 162 - 40, kDeviceWidth,162 + 40);
                     }];
}

//显示地区选择
- (void)showCityChooser {
    
    [self setHidden:NO];
    
    [self.datePicker setHidden:YES];
    [self.sexPickView setHidden:YES];
    [self.cityPickView setHidden:NO];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.functionView.frame = CGRectMake(0, kDeviceHeight - 162 - 40, kDeviceWidth,162 + 40);
                     }];
}

//根据日期显示模式显示日期选择
- (void)showDateChooserWithMode:(UIDatePickerMode)mode {
    
    [self setHidden:NO];
    
    [self.sexPickView setHidden:YES];
    [self.cityPickView setHidden:YES];
    self.datePickerMode = mode;
    [self.datePicker setDatePickerMode:mode];
    [self.datePicker setHidden:NO];
    [self.datePicker setDate:[NSDate date]];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.functionView.frame = CGRectMake(0, kDeviceHeight - 162 - 40, kDeviceWidth,162 + 40);
                     }];
}

//隐藏（取消)
- (void)hide {
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.functionView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, 162 + 40);
                     } completion:^(BOOL finished) {
                         [self setHidden:YES];
                     }];
}

//完成
- (void)done {
    if (!self.sexPickView.hidden) {
        NSInteger row = [self.sexPickView selectedRowInComponent:0];
        NSString *sex = [self pickerView:self.sexPickView titleForRow:row forComponent:0];
        if ([self.delegate respondsToSelector:@selector(customSelectViewDidSelectedSex:)]) {
            [self.delegate customSelectViewDidSelectedSex:sex];
        }
    }
    if (!self.datePicker.hidden) {
        NSDate *date = self.datePicker.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        if (self.datePickerMode == UIDatePickerModeDate) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }else if(self.datePickerMode == UIDatePickerModeTime){
            [dateFormatter setDateFormat:@"HH:mm:ss"];
        }else{
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        
        NSString *birthday = [dateFormatter stringFromDate:date];
        if ([self.delegate respondsToSelector:@selector(customSelectViewDidSelectedDate:DateString:)]) {
            [self.delegate customSelectViewDidSelectedDate:date DateString:birthday];
        }
    }
    if (!self.cityPickView.hidden) {
        NSInteger provinceRow = [self.cityPickView selectedRowInComponent:0];
        NSInteger cityRow = [self.cityPickView selectedRowInComponent:1];
        NSInteger areaRow = [self.cityPickView selectedRowInComponent:2];
        NSString *location = [self pickerView:self.cityPickView titleForRow:provinceRow forComponent:0];
        location = [location stringByAppendingString:[self pickerView:self.cityPickView titleForRow:cityRow forComponent:1]];
        NSString *area = [self pickerView:self.cityPickView titleForRow:areaRow forComponent:2];
        if (![area isEqualToString:@""]) {
            location = [location stringByAppendingString:area];
        }
        if ([self.delegate respondsToSelector:@selector(customSelectViewDidSelectedLocation:)]) {
            [self.delegate customSelectViewDidSelectedLocation:location];
        }
    }
    [self hide];
}

//清除
- (void)clear {
    if (!self.sexPickView.hidden) {
        if ([self.delegate respondsToSelector:@selector(customSelectViewDidSelectedSex:)]) {
            [self.delegate customSelectViewDidSelectedSex:@""];
        }
    }
    if (!self.datePicker.hidden) {
        if ([self.delegate respondsToSelector:@selector(customSelectViewDidSelectedDate:DateString:)]) {
            [self.delegate customSelectViewDidSelectedDate:nil DateString:@""];
        }
    }
    if (!self.cityPickView.hidden) {
        if ([self.delegate respondsToSelector:@selector(customSelectViewDidSelectedLocation:)]) {
            [self.delegate customSelectViewDidSelectedLocation:@""];
        }
    }
    [self hide];
    
}

#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == self.sexPickView) {
        return 1;
    }else {
        return 3;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.sexPickView) {
        return 2;
    }else {
        switch (component) {
            case 0:
                return [self.provinces count];
                break;
            case 1:
                return [self.cities count];
                break;
            case 2:
                return [self.areas count];
                break;
            default:
                return 0;
                break;
        }
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.sexPickView) {
        return row == 0 ? @"男" : @"女";
    }else {
        switch (component) {
            case 0:
                return [[self.provinces objectAtIndex:row] objectForKey:@"state"];
                break;
            case 1:
                return [[self.cities objectAtIndex:row] objectForKey:@"city"];
                break;
            case 2:
                if (self.areas.count > 0) {
                    return [self.areas objectAtIndex:row];
                    break;
                }
            default:
                return @"";
                break;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.cityPickView) {
        switch (component) {
            case 0:
                self.cities = [[self.provinces objectAtIndex:row] objectForKey:@"cities"];
                [pickerView selectRow:0 inComponent:1 animated:YES];
                [pickerView reloadComponent:1];
                
                self.areas = [[self.cities objectAtIndex:0] objectForKey:@"areas"];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                [pickerView reloadComponent:2];
                break;
            case 1:
                self.areas = [[self.cities objectAtIndex:row] objectForKey:@"areas"];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                [pickerView reloadComponent:2];
                break;
            case 2:
                break;
            default:
                break;
        }
    }
}

#pragma mark - Lazy load
- (NSArray *)provinces {
    if (_provinces == nil) {
        _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    }
    return _provinces;
}

- (NSArray *)cities {
    if (_cities == nil) {
        _cities = [[self.provinces objectAtIndex:0] objectForKey:@"cities"];
    }
    return _cities;
}

- (NSArray *)areas {
    if (_areas == nil) {
        _areas = [[self.cities objectAtIndex:0] objectForKey:@"areas"];
    }
    return _areas;
}


@end

