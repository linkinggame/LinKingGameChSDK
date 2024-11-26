

#import "LKOrderController.h"
#import "LKOrderView.h"
#import "ITDatePickerController.h"
#import "LKOrderApi.h"
#import "LKOrderTableView.h"
#import "LKLog.h"
@interface LKOrderController ()<ITDatePickerControllerDelegate>
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (nonatomic, strong)  LKOrderView *orderView;
@end

@implementation LKOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showOrderView];
}
- (void)showOrderView{

    LKOrderView *orderView = [LKOrderView instanceOrderView];
    self.orderView = orderView;
    [self.view insertSubview:orderView atIndex:self.view.subviews.count];
    orderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:orderView];

    
    [self setAlterWidth:322];
    [self setAlterHeight:480];
    [self layoutConstraint];
    
    
    orderView.selectDateCallBack = ^(UIButton * _Nonnull button) {
      
        
        [self showDateView];
    };
    
    
    orderView.closeAlterViewCallBack = ^(UIButton * _Nonnull button) {
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    
    [self loadCurrentDate];
}


- (void)queryOrderRecord:(NSString *)fullDate month:(NSString *)month{
    
    
    [LKOrderApi orderRecordQuery:fullDate month:month complete:^(NSError * _Nonnull error, NSArray * _Nonnull records) {
        
        if (error == nil) {
//            records = @[@{@"date":@"2020-11-16",@"order_no":@"123123123123123123123123123123123123",@"amount":@"21.00",@"status":@1},
//                       @{@"date":@"2020-11-16",@"order_no":@"456",@"amount":@"21.00",@"status":@1},
//                       @{@"date":@"2020-11-16",@"order_no":@"789",@"amount":@"21.00",@"status":@1}
//                       ,@{@"date":@"2020-11-16",@"order_no":@"qweret",@"amount":@"21.00",@"status":@1}];
            [self.orderView.tableView reloadData:records];
        }
        
    }];
}



- (void)loadCurrentDate{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | //年
    NSCalendarUnitMonth | //月份
    NSCalendarUnitDay | //日
    NSCalendarUnitHour |  //小时
    NSCalendarUnitMinute |  //分钟
    NSCalendarUnitSecond;  // 秒
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];

    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
     NSString *yearStr =  [NSString stringWithFormat:@"%ld年",(long)year];
    NSString *monthStr =  [NSString stringWithFormat:@"%02ld月",(long)month];
    self.orderView.label_year.text = yearStr;
    self.orderView.label_month.text = monthStr;
    
    
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM"];
    NSString * fullDateStr =[dateFormat stringFromDate:[NSDate date]];

    [self queryOrderRecord:fullDateStr month:[NSString stringWithFormat:@"%ld",(long)month]];
 
    

}

- (void)showDateView{
       ITDatePickerController *datePickerController = [[ITDatePickerController alloc] init];
       datePickerController.tag = 100;                     // Tag, which may be used in delegate methods
       datePickerController.delegate = self;               // Set the callback object
       datePickerController.showToday = NO;                // Whether to show "today", default is yes
    if (self.startDate == nil) {
        self.startDate = [NSDate date];
    }
       datePickerController.defaultDate = self.startDate;  // Default date
       datePickerController.maximumDate = self.endDate;    // maxinum date
       
       [self presentViewController:datePickerController animated:YES completion:nil];
}
#pragma mark - ITDatePickerControllerDelegate

- (void)datePickerController:(ITDatePickerController *)datePickerController didSelectedDate:(NSDate *)date dateString:(NSString *)dateString {
    

    if ([dateString rangeOfString:@"."].location != NSNotFound) {
        NSArray *array = [dateString componentsSeparatedByString:@"."];
        NSString *year = array[0];
        NSString *month = array[1];
//        LKLogInfo(@"year = %@",year);
//        LKLogInfo(@"month = %@",month);

        self.orderView.label_year.text = [NSString stringWithFormat:@"%@年",year];
        self.orderView.label_month.text = [NSString stringWithFormat:@"%@月",month];
    
         self.startDate = date;
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM"];
        NSString * fullDateStr =[dateFormat stringFromDate:date];

        [self queryOrderRecord:fullDateStr month:[NSString stringWithFormat:@"%ld",(long)[month integerValue]]];
    }
    

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
