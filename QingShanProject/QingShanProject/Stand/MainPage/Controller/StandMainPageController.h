//
//  StandMainPageController.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/3.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^StandMainPageShowLeft)(void);

@interface StandMainPageController : BaseViewController

@property (nonatomic, copy) StandMainPageShowLeft standMainPageShowLeft;

@end
