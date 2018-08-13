//
//  SettingViewController.m
//  QingShanProject
//
//  Created by gunmm on 2018/8/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"

@interface SettingViewController ()
{
    NSFileManager *manager;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavBar];
    [self initView];
    [self initData];
}

- (void)initNavBar {
    self.title = @"设置";
}

- (void)initData {
    
    
    if ([[self sandBox] floatValue]>0) {
        self.cacheLabel.text = [NSString stringWithFormat:@"%@M",[self sandBox]];
    }
    else{
        self.cacheLabel.text = @"0.0M";
    }
    
    
    if (IS_IOS8_OR_LATER) { //iOS8以上包含iOS8
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
            _messageLabel.text = @"未开启";
            _messageAgeLabel.text = @"未开启";
            
        }
        else{
            _messageLabel.text = @"已开启";
            _messageAgeLabel.text = @"已开启";
            
            
        }
    }else{ // ios7 一下
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == UIRemoteNotificationTypeNone) {
            _messageLabel.text = @"未开启";
            _messageAgeLabel.text = @"未开启";
        }
        else{
            
            _messageLabel.text = @"已开启";
            _messageAgeLabel.text = @"已开启";
            
            
            
        }
    }

}

//沙盒目录
-(NSString *)sandBox{
    
    //获取library文件
    NSString *library = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    
    //文件缓存数值
    float totalsize = 0;
    
    //for in遍历library文件夹里的所有子文件
    for (NSString *filePath in [manager subpathsAtPath:library]) {
        
        //转换filePath
        NSString *subPath = [library stringByAppendingPathComponent:filePath];
        
        //获取文件里的所有属性，都是存放在字典里
        NSDictionary *dic = [manager attributesOfItemAtPath:subPath error:nil];
        
        //赋值--- 文件大小
        totalsize += [dic[NSFileSize] floatValue];
        
    }
    
    //返回大小---存放的是字节，转换成M
    return [NSString stringWithFormat:@"%.1f",(totalsize/1024.0/1024.0 - 0.08f)];
}

- (void)initView {
    self.tableView.backgroundColor = bgColor;
    self.tableView.tableFooterView = [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"MyInfo" bundle:nil];
            AboutViewController *aboutViewController = [board instantiateViewControllerWithIdentifier:@"about_my"];
            [self.navigationController pushViewController:aboutViewController animated:YES];
            
        }else if (indexPath.row == 1) {
            [self performSelector:@selector(initClearCatchAlert) withObject:nil afterDelay:0.8f];
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [Utils backToLogin];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 35)];
    view.backgroundColor = bgColor;
    
    return view;
}

- (void)initClearCatchAlert{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
        for (NSString *file in files) {
            NSError *error;
            NSString *path = [[cachePath stringByAppendingString:@"/"] stringByAppendingString:file];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        [self performSelectorOnMainThread:@selector(clearCachesSuccess) withObject:nil waitUntilDone:YES];
    });
}

- (void)clearCachesSuccess {
    [AlertView alertViewWithTitle:@"清空完毕" withMessage:@"" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        self.cacheLabel.text = @"0.0M";
    }];
   
}




@end
