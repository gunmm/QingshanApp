//
//  ImagePreController.m
//  WeighUpSystem
//
//  Created by gunmm on 2018/1/24.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "ImagePreController.h"
#import "AppDelegate.h"

@interface ImagePreController () <UIScrollViewDelegate>
{
    
    UIImageView *showImageView;
}


@property (nonatomic, retain) UIScrollView *scrollView;

@end

@implementation ImagePreController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _scrollView.delegate = self;
    _scrollView.hidden = YES;
    //设置自身属性
    _scrollView.maximumZoomScale = 3.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.contentSize = _scrollView.frame.size;
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.view addSubview:_scrollView];

    showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    showImageView.image = _imageView.image;
    UIImage *image = self.imageView.image;
    //获取图片宽高
    if (fabs(image.size.width - image.size.height) < 10) {
        showImageView.contentMode = UIViewContentModeScaleAspectFit;
    }else{
        showImageView.contentMode = UIViewContentModeScaleToFill;
    }
    showImageView.userInteractionEnabled = YES;
    [_scrollView addSubview:showImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAct:)];
    //设置点击次数
    tap.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAct:)];
    //设置点击次数
    doubleTap.numberOfTapsRequired = 2;
    //添加双击手势
    [_scrollView addGestureRecognizer:doubleTap];
    //双击时单击失效
    [tap requireGestureRecognizerToFail:doubleTap];
}


//点击击方法
- (void)tapAct:(UITapGestureRecognizer *)tap{
    if (tap.numberOfTapsRequired == 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }else if (tap.numberOfTapsRequired == 2){
        if (_scrollView.zoomScale == 1) {
            _scrollView.zoomScale = 2;
        }
        else if(_scrollView.zoomScale >= 2){
            _scrollView.zoomScale = 1;
        }
    }
}


//代理方法 实现缩放fa
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return showImageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if (_scrollView.zoomScale<=1) {
        showImageView.center = self.view.center;
    }else{
        showImageView.center = CGPointMake(_scrollView.contentSize.width/2, _scrollView.contentSize.height/2);
        
    }
}





- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //frame所在坐标系的转换
    CGRect newFrame = [self.imageView.superview convertRect:self.imageView.frame toView:self.view];
    UIImageView *newImageView = [[UIImageView alloc] initWithFrame:newFrame];
    newImageView.image = self.imageView.image;
    UIImage *image = self.imageView.image;
    //获取图片宽高
    if (fabs(image.size.width - image.size.height) < 10) {
        newImageView.contentMode = UIViewContentModeScaleAspectFit;
    }else{
        newImageView.contentMode = UIViewContentModeScaleToFill;
    }

    [self.view addSubview:newImageView];

    [UIView animateWithDuration:.3 animations:^{
        newImageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    } completion:^(BOOL finished) {
        self.scrollView.hidden = NO;
        newImageView.hidden = YES;
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CGRect newFrame = [self.imageView.superview convertRect:self.imageView.frame toView:appDelegate.window];
    UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    newImageView.image = self.imageView.image;
    //获取图片宽高
    UIImage *image = self.imageView.image;

    if (fabs(image.size.width - image.size.height) < 10) {
        newImageView.contentMode = UIViewContentModeScaleAspectFit;
    }else{
        newImageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    [appDelegate.window addSubview:newImageView];
    [appDelegate.window bringSubviewToFront:newImageView];

    [UIView animateWithDuration:.3 animations:^{
        newImageView.frame = newFrame;
    } completion:^(BOOL finished) {
        [newImageView removeFromSuperview];
    }];
}





@end
