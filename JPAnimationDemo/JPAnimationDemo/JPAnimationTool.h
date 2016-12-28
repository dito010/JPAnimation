//
//  JPAnimationTool.h
//  JPAnimation
//
//  Created by lava on 2016/12/28.
//  Copyright © 2016年 NewPan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JPNoParaBlock)(void);
typedef void(^JPContainIDBlock)(id);

@interface JPAnimationTool : NSObject

-(JPContainIDBlock)begainAnimationWithCollectionViewDidSelectedItemIndexPath:(NSIndexPath *)indexPath collcetionView:(UICollectionView *)collectionView forViewController:(UIViewController *)viewController presentViewController:(UIViewController *)presentViewController fadeBlock:(JPNoParaBlock)fadeBlock closeBlock:(JPContainIDBlock)closeBlock;

@end
