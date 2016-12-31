//
//  JPViewController.m
//  JPAnimation
//
//  Created by lava on 2016/12/27.
//  Copyright © 2016年 NewPan. All rights reserved.
//

#import "JPViewController.h"
#import "JPNavigationControllerKit.h"

@interface JPViewController ()<JPNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailImageUpCons;

@end

@implementation JPViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        self.fadeBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            
            [strongSelf.view layoutIfNeeded];
            
            strongSelf.detailImageUpCons.constant = 0;
            [UIView animateWithDuration:0.45 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                strongSelf.detailImageView.alpha = 1;
                [strongSelf.view layoutIfNeeded];
                
            }completion:nil];
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.coverImageView.image = _coverImage;
    
    self.detailImageView.alpha = 0;
    self.detailImageUpCons.constant = 25;
    [self.view layoutIfNeeded];
    
    self.navigationController.jp_pushDelegate = self;
    self.navigationController.jp_interactivePopMaxAllowedInitialDistanceToLeftEdge = 100;
}


#pragma mark --------------------------------------------------
#pragma mark JPNavigationControllerDelegate

-(BOOL)jp_navigationControllerShouldPushRight{
    [self backBtnClick:nil];
    return NO;
}

- (IBAction)backBtnClick:(id)sender {
    if (self.closeBlock) {
        self.closeBlock(self);
    }
    self.view.alpha = 0;
}

@end
