//
//  ImageCropperController.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/29.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageCropperController;

@protocol ImageCropperDelegate <NSObject>

- (void)imageCropper:(ImageCropperController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(ImageCropperController *)cropperViewController;

@end

@interface ImageCropperController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<ImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;



@end
