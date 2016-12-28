//
//  JPCollectionViewCell.m
//  JPAnimation
//
//  Created by lava on 2016/12/27.
//  Copyright © 2016年 NewPan. All rights reserved.
//

#import "JPCollectionViewCell.h"

@interface JPCollectionViewCell()

@end


@implementation JPCollectionViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    // 给显示封面的这个 imageView 加一个 tag.
    self.coverImageView.tag = 1000;
}

-(void)setDataString:(NSString *)dataString{
    _dataString = dataString;
    
    NSString *s = [NSString stringWithFormat:@"Airbnb0%@", dataString];
    self.coverImageView.image = [UIImage imageNamed:s];
}


@end
