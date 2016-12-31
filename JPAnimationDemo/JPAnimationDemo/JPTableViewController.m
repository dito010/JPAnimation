//
//  JPTableViewController.m
//  JPAnimation
//
//  Hello! I am NewPan from Guangzhou of China, Glad you could use my framework, If you have any question or wanna to contact me, please open https://github.com/Chris-Pan or http://www.jianshu.com/users/e2f2d779c022/latest_articles
//

#import "JPTableViewController.h"
#import "JPTableViewCell.h"
#import "JPViewController.h"
#import "JPCollectionViewCell.h"
#import "JPNavigationControllerKit.h"
#import "JPSnapTool.h"
#import "JPAnimationTool.h"

@interface JPTableViewController ()<UITableViewDataSource, UITableViewDelegate, JPTableViewCellDelegate>

/** data */
@property(nonatomic, strong)NSArray *items;

/** animationTool */
@property(nonatomic, strong)JPAnimationTool *animationTool;

@end

static NSString *JPTableViewReuseID = @"JPTableViewReuseID";
@implementation JPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}


#pragma mark --------------------------------------------------
#pragma mark JPTableViewCellDelegate

-(void)collectionViewDidSelectedItemIndexPath:(NSIndexPath *)indexPath collcetionView:(UICollectionView *)collectionView forCell:(JPTableViewCell *)cell{
    
    JPCollectionViewCell *collectionCell = (JPCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    JPViewController *presentViewController = [JPViewController new];
    presentViewController.coverImage = collectionCell.coverImageView.image;
    
    presentViewController.closeBlock =  [self.animationTool begainAnimationWithCollectionViewDidSelectedItemIndexPath:indexPath collcetionView:collectionView forViewController:self presentViewController:presentViewController afterPresentedBlock:presentViewController.fadeBlock];
}

#pragma mark --------------------------------------------------
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JPTableViewReuseID forIndexPath:indexPath];
    cell.items = self.items;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}



#pragma mark --------------------------------------------------
#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280;
}


#pragma mark --------------------------------------------------
#pragma mark Setup

-(void)setup{
    
    // 选择状态栏样式
    self.navigationController.jp_prefersStatusBarStyle = JPStatusBarStyleLight;
    
    // 自定义导航栏
    UIImageView *navBarImageView = [UIImageView new];
    navBarImageView.image = [UIImage imageNamed:@"navBar"];
    navBarImageView.frame = CGRectMake(0, -20, JPScreenWidth, 64);
    [self.navigationController.navigationBar addSubview:navBarImageView];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JPTableViewCell class]) bundle:nil] forCellReuseIdentifier:JPTableViewReuseID];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        NSString *s = [NSString stringWithFormat:@"%@", @(i)];
        [arrM addObject:s];
    }
    self.items = [arrM copy];
    
    [self.tableView reloadData];
}


#pragma mark --------------------------------------------------
#pragma mark Private

-(JPAnimationTool *)animationTool{
    if (!_animationTool) {
        _animationTool = [JPAnimationTool new];
    }
    return _animationTool;
}

@end
