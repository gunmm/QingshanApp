//
//  FindOrderView.h
//  QingShanProject
//
//  Created by gunmm on 2018/12/22.
//  Copyright © 2018 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FindOrderBtnActBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface FindOrderView : UIView

@property (nonatomic, copy) FindOrderBtnActBlock findOrderBtnActBlock;

@end

NS_ASSUME_NONNULL_END
