//
//  JPTableViewCell.m
//  JPAnimation
//
//  Created by lava on 2016/12/27.
//  Copyright © 2016年 NewPan. All rights reserved.
//

#import "JPTableViewCell.h"
#import "JPCollectionViewCell.h"

@interface JPTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

const CGFloat JPCollectionCellW = 250.;
const CGFloat JPCollectionCellInfoH = 44.;
static NSString *JPCollectionViewReuseID = @"JPCollectionViewReuseID";
@implementation JPTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
 
    [self setup];
}

-(void)setItems:(NSArray *)items{
    _items = items;
    [self.collectionView reloadData];
}


#pragma mark --------------------------------------------------
#pragma mark UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(collectionViewDidSelectedItemIndexPath:collcetionView:forCell:)]) {
        [self.delegate collectionViewDidSelectedItemIndexPath:indexPath collcetionView:collectionView forCell:self];
    }
}


#pragma mark --------------------------------------------------
#pragma mark UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JPCollectionViewReuseID forIndexPath:indexPath];
    cell.dataString = self.items[indexPath.row];
    return cell;
}


#pragma mark --------------------------------------------------
#pragma mark Setup

-(void)setup{
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JPCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:JPCollectionViewReuseID];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(JPCollectionCellW, JPCollectionCellW*2.0/3.0+JPCollectionCellInfoH);
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0 ;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 0);
}

@end
