//
//  AlertView.m
//  ConcreteCloud
//
//  Created by gunmm on 2017/12/21.
//  Copyright © 2017年 北京仝仝科技有限公司. All rights reserved.
//

#import "AlertView.h"



@implementation AlertView


+ (void)alertViewWithTitle:(NSString *)title withMessage:(NSString *)message withType:(UIAlertControllerStyle)type withConfirmBlock:(ConfirmBlock)confirmBlock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                                            preferredStyle:type];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              confirmBlock();
                                                          }];
    
    
    [alert addAction:defaultAction];
   [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)alertViewWithTitle:(NSString *)title withMessage:(NSString *)message withType:(UIAlertControllerStyle)type withConfirmBlock:(ConfirmBlock)confirmBlock withCancelBlock:(CancelBlock)cancelBlock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                                            preferredStyle:type];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              confirmBlock();
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             cancelBlock();
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}



+ (void)alertViewWithTitle:(NSString *)title withMessage:(NSString *)message withPlaceholder:(NSString *)placeholder withType:(UIAlertControllerStyle)type withKeykeyboardType:(UIKeyboardType)keyboardType withTextBlock:(TextBlock)textBlock withCancelBlock:(CancelBlock)cancelBlock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                                            preferredStyle:type];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              textBlock(alert.textFields.firstObject.text);
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             cancelBlock();
                                                         }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
        textField.keyboardType = keyboardType;
    }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}


+ (void)actionViewWithTitle:(NSString *)title withMessage:(NSString *)message withConfirmBlock:(ConfirmBlock)confirmBlock withCancelBlock:(CancelBlock)cancelBlock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              confirmBlock();
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             cancelBlock();
                                                         }];
    
    
    UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:@"取消111" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [alert addAction:cancelAction1];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}


+ (void)preAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message withType:(UIAlertControllerStyle)type withConfirmBlock:(ConfirmBlock)confirmBlock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                                            preferredStyle:type];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              confirmBlock();
                                                          }];
    
    
    [alert addAction:defaultAction];
    [[NavBgImage getCurrentVC] presentViewController:alert animated:YES completion:nil];
   
}

@end
