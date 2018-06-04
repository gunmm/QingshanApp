//
//  AlertView.h
//  ConcreteCloud
//
//  Created by gunmm on 2017/12/21.
//  Copyright © 2017年 北京仝仝科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ConfirmBlock)(void);
typedef void(^CancelBlock)(void);
typedef void(^TextBlock)(NSString *text);


@interface AlertView : NSObject <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textF;


+ (void)alertViewWithTitle:(NSString *)title withMessage:(NSString *)message withType:(UIAlertControllerStyle)type withConfirmBlock:(ConfirmBlock)confirmBlock;

+ (void)alertViewWithTitle:(NSString *)title withMessage:(NSString *)message withConfirmTitle:(NSString *)confirmTitle withCancelTitle:(NSString *)cancelTitle withType:(UIAlertControllerStyle)type withConfirmBlock:(ConfirmBlock)confirmBlock withCancelBlock:(CancelBlock)cancelBlock;

+ (void)alertViewWithTitle:(NSString *)title withMessage:(NSString *)message withPlaceholder:(NSString *)placeholder withType:(UIAlertControllerStyle)type withKeykeyboardType:(UIKeyboardType)keyboardType withTextBlock:(TextBlock)textBlock withCancelBlock:(CancelBlock)cancelBlock;

+ (void)preAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message withType:(UIAlertControllerStyle)type withConfirmBlock:(ConfirmBlock)confirmBlock;


@end
