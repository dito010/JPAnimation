//
//  JPViewController.h
//  JPAnimation
//
//  Hello! I am NewPan from Guangzhou of China, Glad you could use my framework, If you have any question or wanna to contact me, please open https://github.com/Chris-Pan or http://www.jianshu.com/users/e2f2d779c022/latest_articles
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
