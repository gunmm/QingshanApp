//
//  StarView.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/11.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "StarView.h"

@implementation StarView

- (void)awakeFromNib {
    [super awakeFromNib];
    _starBtn1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _starBtn2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _starBtn3.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _starBtn4.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _starBtn5.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)starBtnAct1:(id)sender {
    [_starBtn1 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    [_starBtn2 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
    [_starBtn3 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
    [_starBtn4 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
    [_starBtn5 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
    _starNumber = 1;
    
    if (self.starBtnBlock) {
        self.starBtnBlock(self.starNumber);
    }

}

- (IBAction)starBtnAct2:(id)sender {
    [_starBtn1 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    [_starBtn2 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    [_starBtn3 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
    [_starBtn4 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
    [_starBtn5 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
    _starNumber = 2;
    if (self.starBtnBlock) {
        self.starBtnBlock(self.starNumber);
    }
}

- (IBAction)starBtnAct3:(id)sender {
    [_starBtn1 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    [_starBtn2 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    [_starBtn3 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    [_starBtn4 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
    [_starBtn5 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
    _starNumber = 3;
    if (self.starBtnBlock) {
        self.starBtnBlock(self.starNumber);
    }
}

- (IBAction)starBtnAct4:(id)sender {
    [_starBtn1 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    [_starBtn2 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    [_starBtn3 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    [_starBtn4 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    [_starBtn5 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
    _starNumber = 4;
    if (self.starBtnBlock) {
        self.starBtnBlock(self.starNumber);
    }
}

- (IBAction)starBtnAct5:(id)sender {
    [_starBtn1 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    [_starBtn2 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    [_starBtn3 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    [_starBtn4 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    [_starBtn5 setImage:[UIImage imageNamed:@"comment_star_highlight.png"] forState:UIControlStateNormal];
    _starNumber = 5;
    if (self.starBtnBlock) {
        self.starBtnBlock(self.starNumber);
    }
}
@end
