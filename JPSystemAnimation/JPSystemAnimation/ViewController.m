//
//  ViewController.m
//  JPSystemAnimation
//
//  Created by lava on 2016/12/30.
//  Copyright © 2016年 NewPan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *folderImageView;

/** 动画元素 */
@property(nonatomic, strong)UIImageView *animationImageView;

/** 是否是打开预览动画 */
@property(nonatomic, assign)BOOL isOpenOverView;

@end

// 放大倍数
const CGFloat magnificateMultiple = 3.;

#define  JPScreenWidth   [UIScreen mainScreen].bounds.size.width
#define  JPScreenHeight  [UIScreen mainScreen].bounds.size.height
@implementation ViewController

-(UIImageView *)animationImageView{
    if (!_animationImageView) {
        _animationImageView = [UIImageView new];
    }
    return _animationImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isOpenOverView = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 先将文件夹那个视图进行截图
    UIImage *animationImage = [self snapImageForView:self.folderImageView];
    
    // 再将文件夹视图的坐标系迁移到窗口坐标系（绝对坐标系）
    CGRect targetFrame_start = [self.folderImageView.superview convertRect:self.folderImageView.frame toView:nil];
    
    // 计算动画终点位置
    CGFloat targetW = targetFrame_start.size.width*magnificateMultiple;
    CGFloat targetH = targetFrame_start.size.height*magnificateMultiple;
    CGFloat targetX = (JPScreenWidth - targetW) / 2.0;
    CGFloat targetY =(JPScreenHeight - targetH) / 2.0;
    CGRect targetFrame_end = CGRectMake(targetX, targetY, targetW, targetH);
    
    // 添加做动画的元素
    if (!self.animationImageView.superview) {
        self.animationImageView.image = animationImage;
        self.animationImageView.frame = targetFrame_start;
        [self.view.window addSubview:self.animationImageView];
    }
    
    if (self.isOpenOverView) {
        
        // 预览动画
        [UIView animateWithDuration:0.25 delay:0. options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.animationImageView.frame = targetFrame_end;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        
        // 关闭预览动画
        [UIView animateWithDuration:0.25 delay:0. options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.animationImageView.frame = targetFrame_start;
            
        } completion:^(BOOL finished) {
            
            [self.animationImageView removeFromSuperview];
            
        }];
    }
    
    self.isOpenOverView = !self.isOpenOverView;
}


#pragma mark --------------------------------------------------
#pragma mark Private

// 将一个 view 进行截图
-(UIImage *)snapImageForView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *aImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aImage;
}

@end
