//
//  JPAnimationTool.m
//  JPAnimation
//
//  Created by lava on 2016/12/28.
//  Copyright © 2016年 NewPan. All rights reserved.
//

#import "JPAnimationTool.h"
#import "JPNavigationControllerKit.h"
#import "JPSnapTool.h"

typedef NS_OPTIONS(NSInteger, JPTailorType) {
    JPTailorTypeNone = 1 << 0,
    JPTailorTypeUp = 1 << 1, // 裁剪上半部分
    JPTailorTypeDown = 1 << 2, // 裁剪下半部分
    JPTailorTypeCenter = 1 << 3, // 裁剪中间部分
};

@interface JPAnimationTool()

/** 用来做动画的 ImageView 数组 */
@property(nonatomic, strong)NSMutableArray<UIImageView *> *animationImageViewReusePool;

@end


@implementation JPAnimationTool

-(JPContainIDBlock)begainAnimationWithCollectionViewDidSelectedItemIndexPath:(NSIndexPath *)indexPath collcetionView:(UICollectionView *)collectionView forViewController:(UIViewController *)viewController presentViewController:(UIViewController *)presentViewController fadeBlock:(JPNoParaBlock)fadeBlock closeBlock:(JPContainIDBlock)closeBlock{
    
    // 拿到 collectionView 点击的那个 cell 的imageView.
    UICollectionViewCell *tapCollectionCell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imageView = [self getImageViewForCollectionCell:tapCollectionCell];
    
    // 先计算点击的那个 item 的那张图片的 frame 转换为窗口坐标以后的值 (相对坐标系为 : 窗口坐标)
    CGRect tapImageViewFrame = [imageView.superview convertRect:imageView.frame toView:nil];
    
    // 计算将窗口截图裁剪为需要做动画的图片的裁剪点(imageView 上下各有一个裁剪点)(相对坐标系为 : 窗口坐标)
    CGFloat upTailorY = tapImageViewFrame.origin.y;
    CGFloat downTailorY = upTailorY + tapImageViewFrame.size.height;
    
    // 计算做动画的 ImageView 的初始 frame (相对坐标系为 : 窗口坐标)
    CGRect upAnimationImageViewFrame_start = CGRectMake(0, 0, JPScreenWidth, upTailorY);
    CGRect downAnimationImageViewFrame_start = CGRectMake(0, downTailorY, JPScreenWidth, JPScreenHeight - downTailorY);
    
    // 计算做动画的 ImageView 的终点 frame (相对坐标系为 : 窗口坐标)
    CGRect upAnimationImageViewFrame_end = CGRectMake(0, -upTailorY, JPScreenWidth, upTailorY);
    CGRect downAnimationImageViewFrame_end = CGRectMake(0, JPScreenHeight, JPScreenWidth, JPScreenHeight - downTailorY);
    
    // For Test, 添加一个红色的遮罩来查看自己换算的frame是否正确
    //    UIView *redView = [[UIView alloc]init];
    //    redView.backgroundColor = [UIColor redColor];
    //    redView.frame = downAnimationImageViewFrame;
    //    [self.view.window addSubview:redView];
    
    
    // 将当前窗口进行截图
    UIImage *snapImage = [JPSnapTool snapShotWithView:viewController.view.window];
    
    // 根据裁剪点分别裁剪图片, 待做动画的时候使用
    UIImage *upAnimationImage = [self tailorImage:snapImage andTailorPoint:upTailorY useTailorType:JPTailorTypeUp];
    UIImage *downAnimationImage = [self tailorImage:snapImage andTailorPoint:downTailorY useTailorType:JPTailorTypeDown];
    
    
    
    // 添加做动画需要的上下两个 ImageView, 以及点击的那个 item 的 ImageView 到窗口.
    UIImageView *upAnimationImageView = [self dequeueReusableImageView];
    upAnimationImageView.frame = upAnimationImageViewFrame_start;
    upAnimationImageView.image = upAnimationImage;
    [viewController.view.window addSubview:upAnimationImageView];
    
    
    UIImageView *downAnimationImageView = [self dequeueReusableImageView];
    downAnimationImageView.frame = downAnimationImageViewFrame_start;
    downAnimationImageView.image = downAnimationImage;
    [viewController.view.window addSubview:downAnimationImageView];
    
    
    // 处理 collectionView 每个可见 cell, 创建一个做动画的 ImageView 添加到窗口
    NSDictionary *dict = [self addAnimationImageViewsForCenterWithCollectionView:collectionView forViewController:viewController];
    __block NSMutableArray *animationImageViews = dict[@"animationImageViews"];
    NSMutableArray *animationFrames_start = dict[@"animationFrames_start"];
    
    
    // 根据点击的那个 cell 的目标位置推断出临近可见 cell 的目标位置 (相对坐标系为 : 窗口坐标)
    NSMutableArray *animationFrames_end = [self calculateEndAniamtionFrameForCenterImageViewWithAnimationFrames_start:animationFrames_start tapImageViewFrame:tapImageViewFrame];
    
    // 开始做动画
    [UIView animateWithDuration:0.35 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        // 当前 View 变透明
        viewController.view.hidden = YES;
        
        // 状态栏暂时隐藏
        viewController.navigationController.navigationBar.hidden = YES;
        
        // 上部上移
        upAnimationImageView.frame = upAnimationImageViewFrame_end;
        
        // 下部下移
        downAnimationImageView.frame = downAnimationImageViewFrame_end;
        
        // collectionView 每个 cell 的照片动画
        for (int i = 0; i<animationImageViews.count; i++) {
            UIImageView *imageView = animationImageViews[i];
            NSValue *value = animationFrames_end[i];
            CGRect rect = [value CGRectValue];
            imageView.frame = rect;
        }
        
    }completion:^(BOOL finished) {
        
        [viewController.navigationController pushViewController:presentViewController animated:NO];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 第二个界面淡入上移动画调用
            if (fadeBlock) {
                fadeBlock();
            }
        });
        
        // 重置动画控件
        [self enqueueForImageView:upAnimationImageView];
        [self enqueueForImageView:downAnimationImageView];
        for (UIImageView *imageView in animationImageViews) {
            [self enqueueForImageView:imageView];
        }
        animationImageViews = nil;
        
        viewController.view.hidden = NO;
    }];
    
    // 保存关闭的动画的block
    return [self saveCloseAnimationWithUpAnimationImage:upAnimationImage
                        upAnimationImageViewFrame_start:upAnimationImageViewFrame_start
                          upAnimationImageViewFrame_end:upAnimationImageViewFrame_end
                                     downAnimationImage:downAnimationImage
                      downAnimationImageViewFrame_start:downAnimationImageViewFrame_start
                        downAnimationImageViewFrame_end:downAnimationImageViewFrame_end
                                    visiableCells:collectionView.visibleCells
                                    animationFrames_end:animationFrames_end
                                  animationFrames_start:animationFrames_start
                                      forViewController:viewController
                                  presentViewController:presentViewController];
}


-(NSDictionary *)addAnimationImageViewsForCenterWithCollectionView:(UICollectionView *)collectionView forViewController:(UIViewController *)viewController{
    
    // 处理 collectionView 每个可见 cell, 创建一个做动画的 ImageView 添加到窗口
    NSArray *cells = collectionView.visibleCells;
    NSMutableArray *animationImageViews = [NSMutableArray arrayWithCapacity:cells.count];
    NSMutableArray *animationFrames_start = [NSMutableArray arrayWithCapacity:cells.count];
    for (UICollectionViewCell *cell in cells) {
        
        // 先添加可见 cell 个数的动画 imageView 到窗口
        // 计算每张图片的 frame 转换为窗口的 frame (相对坐标系为 : 窗口坐标)
        UIImageView *imageView = [self getImageViewForCollectionCell:cell];
        CGRect rect = [imageView.superview convertRect:imageView.frame toView:nil];
        NSValue *value = [NSValue valueWithCGRect:rect];
        [animationFrames_start addObject:value];
        
        // 从缓存池中取复用的 UIImageView.
        UIImageView *animationImageView = [self dequeueReusableImageView];
        animationImageView.image = imageView.image;
        animationImageView.frame = rect;
        [viewController.view.window addSubview:animationImageView];
        [animationImageViews addObject:animationImageView];
    }
    NSDictionary *dict = @{
                           @"animationImageViews" : animationImageViews,
                           @"animationFrames_start" : animationFrames_start
                           };
    
    return dict;
    
}

-(NSMutableArray *)calculateEndAniamtionFrameForCenterImageViewWithAnimationFrames_start:(NSArray *)animationFrames_start tapImageViewFrame:(CGRect)tapImageViewFrame{
    
    // 根据点击的那个 cell 的目标位置推断出临近可见 cell 的目标位置 (相对坐标系为 : 窗口坐标)
    CGRect tapAnimationImageViewFrame_end = CGRectMake(0, 0, JPScreenWidth, JPScreenWidth*2.0/3.0);
    NSMutableArray *animationFrames_end = [NSMutableArray arrayWithCapacity:animationFrames_start.count];
    for (int i = 0; i<animationFrames_start.count; i++) {
        NSValue *value = animationFrames_start[i];
        CGRect rect = [value CGRectValue];
        
        CGRect targetRect = tapAnimationImageViewFrame_end;
        if (rect.origin.x < tapImageViewFrame.origin.x) { // 在点击 cell 的左侧 ⬅️
            CGFloat detla = tapImageViewFrame.origin.x - rect.origin.x;
            targetRect.origin.x = -(detla * JPScreenWidth)/tapImageViewFrame.size.width;
        }
        else if (rect.origin.x == tapImageViewFrame.origin.x){ // 就是当前点击的 cell
            
        }
        else{ // 在点击 cell 的右侧 ➡️
            CGFloat detla = rect.origin.x - tapImageViewFrame.origin.x;
            targetRect.origin.x = (detla*JPScreenWidth)/tapImageViewFrame.size.width;
        }
        
        NSValue *targetValue = [NSValue valueWithCGRect:targetRect];
        [animationFrames_end addObject:targetValue];
    }
    
    return animationFrames_end;
}

-(JPContainIDBlock)saveCloseAnimationWithUpAnimationImage:(UIImage *)upAnimationImage
        upAnimationImageViewFrame_start:(CGRect)upAnimationImageViewFrame_start
          upAnimationImageViewFrame_end:(CGRect)upAnimationImageViewFrame_end
                     downAnimationImage:(UIImage *)downAnimationImage
      downAnimationImageViewFrame_start:(CGRect)downAnimationImageViewFrame_start
        downAnimationImageViewFrame_end:(CGRect)downAnimationImageViewFrame_end
                    visiableCells:(NSArray *)visiableCells
                    animationFrames_end:(NSArray *)animationFrames_end
                  animationFrames_start:(NSArray *)animationFrames_start
                      forViewController:(UIViewController *)viewController
                  presentViewController:(UIViewController *)presentViewController
{
    
    // 保存关闭动画为 block
    __weak typeof(self) weakSelf = self;
    JPContainIDBlock closeBlock = ^(UIViewController *tab){
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        
        // 添加做动画需要的上下两个 ImageView, 以及点击的那个 item 的 ImageView 到窗口.
        UIImageView *upAnimationImageView = [strongSelf dequeueReusableImageView];
        upAnimationImageView.frame = upAnimationImageViewFrame_end;
        upAnimationImageView.image = upAnimationImage;
        [tab.view.window addSubview:upAnimationImageView];
        
        
        UIImageView *downAnimationImageView = [strongSelf dequeueReusableImageView];
        downAnimationImageView.frame = downAnimationImageViewFrame_end;
        downAnimationImageView.image = downAnimationImage;
        [tab.view.window addSubview:downAnimationImageView];
        
        
        // collectionView 每个 cell 的照片动画
        __block NSMutableArray *animationImageViews = [NSMutableArray array];
        for (int i = 0; i<visiableCells.count; i++) {
            UIImageView *imageView = [strongSelf dequeueReusableImageView];
            [animationImageViews addObject:imageView];
            NSValue *value = animationFrames_end[i];
            CGRect rect = [value CGRectValue];
            imageView.frame = rect;
            imageView.image = [strongSelf getImageViewForCollectionCell:visiableCells[i]].image;
            [tab.view.window addSubview:imageView];
        }
        
        // 开始做动画
        [UIView animateWithDuration:0.35 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            // 上部下移
            upAnimationImageView.frame = upAnimationImageViewFrame_start;
            
            // 下部上移
            downAnimationImageView.frame = downAnimationImageViewFrame_start;
            
            // collectionView 每个 cell 的照片动画
            for (int i = 0; i<animationImageViews.count; i++) {
                UIImageView *imageView = animationImageViews[i];
                NSValue *value = animationFrames_start[i];
                CGRect rect = [value CGRectValue];
                imageView.frame = rect;
            }
            
        }completion:^(BOOL finished) {
            
            // 重置动画控件
            [strongSelf enqueueForImageView:upAnimationImageView];
            [strongSelf enqueueForImageView:downAnimationImageView];
            
            [presentViewController.navigationController popViewControllerAnimated:NO];
            
            for (UIImageView *imageView in animationImageViews) {
                [strongSelf enqueueForImageView:imageView];
            }
            animationImageViews = nil;
            
            // 状态栏暂时隐藏
            viewController.navigationController.navigationBar.hidden = NO;
        }];
    };
    return closeBlock;
}


#pragma mark --------------------------------------------------
#pragma mark Private

-(void)enqueueForImageView:(UIImageView *)imageView{
    if (imageView.superview) {
        imageView.image = nil;
        [imageView removeFromSuperview];
        [self.animationImageViewReusePool addObject:imageView];
    }
}

-(UIImageView *)dequeueReusableImageView{
    UIImageView *resultImageView = nil;
    if (!self.animationImageViewReusePool) {
        self.animationImageViewReusePool = [NSMutableArray array];
    }
    if (self.animationImageViewReusePool.count>0) {
        resultImageView = self.animationImageViewReusePool.firstObject;
        [self.animationImageViewReusePool removeObject:resultImageView];
    }
    else{
        resultImageView = [UIImageView new];
    }
    return resultImageView;
}

-(UIImageView *)getImageViewForCollectionCell:(UICollectionViewCell *)cell{
    UIImageView *result = nil;
    UIView *collectionViewContentView = cell.subviews.firstObject;
    NSArray *views = collectionViewContentView.subviews;
    for (UIView *view in views) {
        if (view.tag == 1000) {
            result = (UIImageView *)view;
            break;
        }
    }
    return result;
}

-(UIImage *)tailorImage:(UIImage *)image andTailorPoint:(CGFloat)point useTailorType:(JPTailorType)type{
    return [self tailorImage:image andTailorPoint:point useTailorType:type tailorHei:0];
}

-(UIImage *)tailorImage:(UIImage *)image andTailorPoint:(CGFloat)point useTailorType:(JPTailorType)type tailorHei:(CGFloat)hei{
    
    // 将要裁剪的图片根据 要裁剪的类型进行裁剪
    
    CGSize imageSize = image.size;
    if (point>0 && point<imageSize.height) {
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGRect rect= CGRectNull;
        if (type & JPTailorTypeUp) {
            rect = CGRectMake(0, 0, imageSize.width*scale, point*scale);
        }
        else if (type & JPTailorTypeDown){
            rect = CGRectMake(0, point*scale, imageSize.width*scale, (imageSize.height-point)*scale);
        }
        else if (type & JPTailorTypeCenter){
            rect = CGRectMake(0, point*scale, imageSize.width*scale, hei*scale);
        }
        
        CGImageRef sourceImageRef = [image CGImage];
        CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
        return newImage;
    }
    return nil;
}

@end
