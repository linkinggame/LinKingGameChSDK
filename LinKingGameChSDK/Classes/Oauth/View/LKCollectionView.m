
#import "LKCollectionView.h"
#import "LKCollectionViewCell.h"
#import "LKGlobalConf.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import <Toast/Toast.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>
@interface LKCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) CGRect customeFrame;
@property (nonatomic, assign) CGFloat itemWidth;
@end

@implementation LKCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self.customeFrame = frame;
    self = [super initWithFrame:frame collectionViewLayout:[self collectionViewLayout]];
    if (self) {
        super.delegate = self;
        super.dataSource = self;
        
       

        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
        
        [self registerNib:[UINib nibWithNibName:@"LKCollectionViewCell" bundle:bundle] forCellWithReuseIdentifier:@"LKCollectionViewCell"];

    }
    return self;
}

- (void)setData:(NSArray *)data{
    _data = data;
    [self reloadData];
}
- (UICollectionViewFlowLayout *)collectionViewLayout{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat count  = 3;
    CGFloat interitemSpacing = 10;
    CGFloat lineSpacing = 10;
    CGFloat itemWidth = (self.customeFrame.size.width - 20 - (count -1) * interitemSpacing)* 1.0 / count;
    self.itemWidth = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumLineSpacing = lineSpacing;
    layout.minimumInteritemSpacing = interitemSpacing;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    return layout;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
     LKCollectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"LKCollectionViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
         cell = [[bundle loadNibNamed:@"LKCollectionViewCell" owner:nil options:nil] firstObject];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    NSString *icon = self.data[indexPath.row][@"url"];
    [cell.imageView_icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage lk_ImageNamed:@"default-icon"]];
    
    cell.imageView_icon.layer.cornerRadius = self.itemWidth * 0.5;
    cell.imageView_icon.clipsToBounds = YES;
    cell.backgroundColor = [UIColor clearColor];
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *icon = self.data[indexPath.row][@"url"];
    NSString *iconId = self.data[indexPath.row][@"id"];
    
    if (self.selectIconCallback) {
        self.selectIconCallback(icon,iconId);
    }
    
}


@end
