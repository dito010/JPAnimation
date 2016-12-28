//
//  JPViewController.h
//  JPAnimation
//
//  Created by lava on 2016/12/27.
//  Copyright © 2016年 NewPan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JPNoParaBlock)(void);
typedef void(^JPContainIDBlock)(id);

@interface JPViewController : UIViewController

/** coverImage */
@property(nonatomic, strong)UIImage *coverImage;

/** 进入出现动画 */
@property(nonatomic, strong)JPNoParaBlock fadeBlock;

/** 关闭动画 */
@property(nonatomic, strong)JPContainIDBlock closeBlock;

@end
