//
//  JPTableViewCell.h
//  JPAnimation
//
//  Created by lava on 2016/12/27.
//  Copyright © 2016年 NewPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPTableViewCell, JPCollectionViewCell;

@protocol JPTableViewCellDelegate <NSObject>

@optional
-(void)collectionViewDidSelectedItemIndexPath:(NSIndexPath *)indexPath collcetionView:(UICollectionView *)collectionView forCell:(JPTableViewCell *)cell;

@end


@interface JPTableViewCell : UITableViewCell

/** delegate */
@property(nonatomic, weak)id<JPTableViewCellDelegate> delegate;

/** data */
@property(nonatomic, strong)NSArray *items;

@end
