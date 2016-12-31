//
//  JPCollectionViewCell.m
//  JPAnimation
//
//  Hello! I am NewPan from Guangzhou of China, Glad you could use my framework, If you have any question or wanna to contact me, please open https://github.com/Chris-Pan or http://www.jianshu.com/users/e2f2d779c022/latest_articles
//

#import "JPCollectionViewCell.h"
#import "JPAnimationTool.h"

@interface JPCollectionViewCell()

@end


@implementation JPCollectionViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    // 给显示封面的这个 imageView 加一个 tag.
    self.coverImageView.tag = JPCoverImageViewTag;
}

-(void)setDataString:(NSString *)dataString{
    _dataString = dataString;
    
    NSString *s = [NSString stringWithFormat:@"Airbnb0%@", dataString];
    self.coverImageView.image = [UIImage imageNamed:s];
}


@end
