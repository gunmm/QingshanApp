//
//  ShortSoundPlay.h
//  QingShanProject
//
//  Created by gunmm on 2018/6/6.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface ShortSoundPlay : NSObject

+ (void)playSoundWithPath:(NSString *)path withType:(NSString *)type ;

@end
