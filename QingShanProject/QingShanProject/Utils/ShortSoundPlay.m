//
//  ShortSoundPlay.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/6.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "ShortSoundPlay.h"


@implementation ShortSoundPlay

// 音频文件的ID
SystemSoundID ditaVoice;

static void completionCallback(SystemSoundID mySSID)
{
    // Play again after sound play completion
    //    AudioServicesPlaySystemSound(mySSID);
}

+ (void)playSoundWithPath:(NSString *)path withType:(NSString *)type {
    // 1. 定义要播放的音频文件的URL
    NSURL *voiceURL = [[NSBundle mainBundle] URLForResource:path withExtension:type];
    // 2. 注册音频文件（第一个参数是音频文件的URL 第二个参数是音频文件的SystemSoundID）
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(voiceURL),&ditaVoice);
    // 3. 为crash播放完成绑定回调函数
    AudioServicesAddSystemSoundCompletion(ditaVoice,NULL,NULL,(void*)completionCallback,NULL);
    // 4. 播放 ditaVoice 注册的音频 并控制手机震动
    AudioServicesPlayAlertSound(ditaVoice);
    //    AudioServicesPlaySystemSound(ditaVoice);
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); // 控制手机振动
}




@end
