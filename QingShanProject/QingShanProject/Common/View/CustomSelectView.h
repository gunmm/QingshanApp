//
//  CustomSelectView.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSelectViewDelegate <NSObject>

@optional
- (void)customSelectViewDidSelectedSex:(NSString *)sex;
- (void)customSelectViewDidSelectedDate:(NSDate *)date DateString:(NSString *)dateString;
- (void)customSelectViewDidSelectedLocation:(NSString *)location;

@end



@interface CustomSelectView : UIView

@property (weak,nonatomic) id<CustomSelectViewDelegate> delegate;

+ (instancetype)customSelectView;

- (void)showSexChooser;
- (void)showCityChooser;
- (void)showDateChooserWithMode:(UIDatePickerMode)mode;
- (void)hide;


@end
