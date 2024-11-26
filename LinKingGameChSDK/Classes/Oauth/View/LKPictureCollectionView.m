

#import "LKPictureCollectionView.h"
#import "LKPictureCollectionCell.h"
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
@interface LKPictureCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, assign) CGRect customeFrame;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) NSArray *images;
@end

@implementation LKPictureCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self.customeFrame = frame;
    self = [super initWithFrame:frame collectionViewLayout:[self collectionViewLayout]];
    if (self) {
        super.delegate = self;
        super.dataSource = self;
        
        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
        
        [self registerNib:[UINib nibWithNibName:@"LKPictureCollectionCell" bundle:bundle] forCellWithReuseIdentifier:@"LKPictureCollectionCell"];

    }
    return self;
}


- (void)reloadDatas:(NSArray *)datas{
    self.images = datas;
    [self reloadData];
}

- (UICollectionViewFlowLayout *)collectionViewLayout{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat count  = 4;
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
    if (self.images.count == 4) {
          return self.images.count;
      }else{
          return self.images.count + 1;
      }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
     LKPictureCollectionCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"LKPictureCollectionCell" forIndexPath:indexPath];
    if (cell == nil) {
        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
         cell = [[bundle loadNibNamed:@"LKPictureCollectionCell" owner:nil options:nil] firstObject];
    }

    //LKPictureCollectionCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"LKPictureCollectionCell" forIndexPath:indexPath];
     cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == self.images.count) {
        cell.imageView_alnumAdd.image = [UIImage lk_ImageNamed:@"add-picture"];
    }else{
        cell.imageView_alnumAdd.image = self.images[indexPath.row];
    }
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.images.count) {
        if (self.selectItemCallBack) {
            self.selectItemCallBack(indexPath.row);
        }
    }
    

}


@end
