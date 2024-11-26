

#import "LKOrderTableView.h"
#import "LKOrderTableViewCell.h"
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
@interface LKOrderTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, copy) NSString *orderNumber;
@end

@implementation LKOrderTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];

    super.delegate = self;
    super.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"LKOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"LKOrderTableViewCell"];
    
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    self.rowHeight = 40;
    self.data = [NSMutableArray array];
}

- (void)reloadData:(NSArray *)data{
    [self.data removeAllObjects];
    [self.data addObjectsFromArray:data];
    [self reloadData];
    
}

- (UIView *)headerView{
    
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.frame.size.width, 40);
    view.backgroundColor = [UIColor orangeColor];
    
    
    UILabel *label_year = [[UILabel alloc] init];
    label_year.text = @"2019年";
    label_year.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    label_year.textAlignment = NSTextAlignmentCenter;
    label_year.font = [UIFont boldSystemFontOfSize:14];
    label_year.frame = CGRectMake(10, 5, 50, 30);
    [view addSubview:label_year];
    
    
    UILabel *lable_month = [[UILabel alloc] init];
    lable_month.text = @"9月";
    lable_month.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    lable_month.textAlignment = NSTextAlignmentCenter;
    lable_month.font = [UIFont boldSystemFontOfSize:14];
    lable_month.frame = CGRectMake(CGRectGetMaxX(label_year.frame), 5, 40, 30);
    [view addSubview:lable_month];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage lk_ImageNamed:@"down"] forState:UIControlStateNormal];
    
    
    button.frame = CGRectMake(CGRectGetMaxX(lable_month.frame), 10, button.imageView.image.size.width, button.imageView.image.size.height);
    
    [view addSubview:button];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
     NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKOrderTableViewCell *cell = [[bundle loadNibNamed:@"LKOrderTableViewCell" owner:nil options:nil] firstObject];

//    LKOrderTableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:@"LKOrderTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *record = self.data[indexPath.row];
    cell.label_time.text = record[@"date"];
    cell.label_orderNumber.text = [NSString stringWithFormat:@"订单号:%@",record[@"order_no"]];
    // record[@"order_no"];
    cell.label_price.text = [NSString stringWithFormat:@"金币￥%@",record[@"amount"]];
    
    NSString *statusStr = nil;
    NSNumber *status = record[@"status"];
    if ([status intValue]== 2) {
        statusStr = @"成功";
    }
    
    cell.label_state.text =statusStr;
    //对于cell设置长按点击事件
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPressGestureRecognizer];
    // order_no
    return cell;
}

- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer {
  if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
      LKOrderTableViewCell *cell = (LKOrderTableViewCell *) gestureRecognizer.view;
      [cell becomeFirstResponder];
      NSIndexPath *indexPath =[self indexPathForCell:cell];
      
      NSDictionary *record = self.data[indexPath.row];
  
      NSString *order_no = record[@"order_no"];
      
      self.orderNumber = order_no;

      //定义菜单
      UIMenuController *menu = [UIMenuController sharedMenuController];

      UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制订单号" action:@selector(copyAction:)];
      //设定菜单显示的区域，显示再Rect的最上面居中
      [menu setTargetRect:cell.frame inView:self];
      [menu setMenuItems:@[copy]];
      [menu setMenuVisible:YES animated:YES];
  }
}
//拷贝
- (void)copyAction:(id)sender {
    //拷贝操作
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.orderNumber];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
////允许 Menu菜单
//- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//  
////每个cell都会点击出现Menu菜单
//- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
//{
//    if (action == @selector(copy:)) {
//        return YES;
//    }
//    return NO;
//}
//
//- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
//{
//    NSDictionary *record = self.data[indexPath.row];
//    
//    NSString *order_no = record[@"order_no"];
//    if (action == @selector(copy:)) {
//        [UIPasteboard generalPasteboard].string = order_no;
//    }
//
//  
//}
/*
 {
   "amount" : 0.01,
   "status" : 2,
   "product_id" : "1111",
   "product_desc" : "月卡",
   "date" : "2020年07月22日 17:44"
 }
 
 **/

@end
