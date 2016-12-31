//
//  JPTableViewCell.h
//  JPAnimation
//
//  Hello! I am NewPan from Guangzhou of China, Glad you could use my framework, If you have any question or wanna to contact me, please open https://github.com/Chris-Pan or http://www.jianshu.com/users/e2f2d779c022/latest_articles
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
