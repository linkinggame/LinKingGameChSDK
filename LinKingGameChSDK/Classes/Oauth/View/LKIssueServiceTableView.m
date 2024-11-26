

#import "LKIssueServiceTableView.h"
#import "LKIssueServiceCell.h"
#import "LKIssueSectionHeaderView.h"
#import "LKIssueApi.h"
#import "LKLog.h"
@interface LKIssueServiceTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) NSMutableArray *rowDatas;
@property(nonatomic,strong)NSMutableArray*   isOpenArr;
@end

@implementation LKIssueServiceTableView

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
    [self registerNib:[UINib nibWithNibName:@"LKIssueServiceCell" bundle:nil] forCellReuseIdentifier:@"LKIssueServiceCell"];
    
    self.tableHeaderView = [self headerView];
    self.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.rowHeight = 50;
    self.rowDatas = [NSMutableArray array];
    self.isOpenArr = [NSMutableArray array];
}

- (void)reloadData:(NSArray *)data{
    self.data = data;
    [self.rowDatas removeAllObjects];
    [self.isOpenArr removeAllObjects];
    
    for (int i = 0; i < data.count; i++) {
        NSDictionary *item = data[i];
        NSString *reply_content = item[@"reply_content"] != nil ? item[@"reply_content"] : @"";
        NSMutableArray *arrayItem = [NSMutableArray array];
        [arrayItem addObject:@{@"reply_content":reply_content}];
        NSString*  state=@"close";
        [self.isOpenArr addObject:state];
        [self.rowDatas addObject:arrayItem];
        
    }
   
    [self reloadData];
    
}

- (UIView *)headerView{
    
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.frame.size.width, 30);
    view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *label_one = [[UILabel alloc] init];
    label_one.text = @"查看我提交过的问题";
    label_one.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
    label_one.textAlignment = NSTextAlignmentCenter;
    label_one.font = [UIFont systemFontOfSize:14];
    label_one.frame = CGRectMake(10, 5, 140, 20);
    [view addSubview:label_one];
    
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    NSString*  state=[self.isOpenArr objectAtIndex:section];
    if ([state isEqualToString:@"open"]) {
        NSArray*  arr=[self.rowDatas objectAtIndex:section];
        return arr.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}

/*
 {
   "success" : true,
   "code" : null,
   "data" : [
     {
       "question_type" : "卡顿",
       "status" : 1,  // 1处理中 2已完成
       "pictures" : [
         "https:\/\/lk-hzres.oss-cn-hangzhou.aliyuncs.com\/sdk\/question\/picture\/bb31e0c31855e7090036e8fe89ff24c7.png"
       ],
       "question" : "卡顿",
       "create_time" : "2020-07-27 09:55",
       "update_time" : "2020-07-27 09:55"
     }
   ],
   "desc" : null
 }
 
 **/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
     NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKIssueServiceCell *cell = [[bundle loadNibNamed:@"LKIssueServiceCell" owner:nil options:nil] firstObject];
    
//    LKIssueServiceCell* cell =   [tableView dequeueReusableCellWithIdentifier:@"LKIssueServiceCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSArray* arr=[self.rowDatas objectAtIndex:indexPath.section];
    NSDictionary *dict = arr.firstObject;
    NSString *replay = dict[@"reply_content"];
    cell.label_replay.text = replay;
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray* itemArray =[self.rowDatas objectAtIndex:indexPath.section];
    NSDictionary *dict = itemArray.firstObject;
    NSString *replay = dict[@"reply_content"];
    CGFloat width = tableView.frame.size.width - 63;
    CGFloat contenHeight =  [replay boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
    return contenHeight + 5 + 10;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectItemCallBack) {
        self.selectItemCallBack(nil, indexPath.row);
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
     NSDictionary *item = self.data[section];
     NSString *question = [NSString stringWithFormat:@"问题:%@",item[@"question"]];
    CGFloat width = tableView.frame.size.width - 74;
    CGFloat questionHeight =  [question boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
    // 10时间顶部高度 16时间高度 5底部举例 20（凑足高度44+容错）
    if (questionHeight < 0) {
        questionHeight = 0;
    }
    //  10 + 16 + 5 + 20
    return questionHeight + 51;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LKIssueSectionHeaderView *headerView = (LKIssueSectionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    
    if (headerView == nil) {
        headerView = [LKIssueSectionHeaderView instancessueSectionHeaderView];
        headerView.frame = CGRectMake(0, 0,  tableView.frame.size.width, 50);
        [headerView.button_action addTarget:self action:@selector(clickSection:) forControlEvents:UIControlEventTouchUpInside];
        headerView.button_action.tag = section;
        
        NSDictionary *item = self.data[section];
   
         NSString *question = [NSString stringWithFormat:@"问题:%@",item[@"question"]];
         NSString *create_time = item[@"create_time"];
         NSString *status = item[@"status"];// 1处理中 2已完成
       if ([status intValue] == 1) {
           headerView.label_state.textColor = [UIColor colorWithRed:42/255.0 green:169/255.0 blue:234/255.0 alpha:1];
           headerView.label_state.text = @"处理中...";
       }else{
           headerView.label_state.textColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1];
           headerView.label_state.text = @"处理完成";
       }
       headerView.label_issue.text = question;
       headerView.label_time.text = create_time;
    }

    return  headerView;
}
- (void)clickSection:(UIButton*)sender{
    
    NSDictionary *item = self.data[sender.tag];
    NSNumber *isRead = item[@"read"];
    if ([isRead boolValue]) { // 已读直接展开
        [self showRow:sender.tag];
    }else{//未读
        NSString *issueId = item[@"id"];
        [self issueAlreadyRead:issueId complete:^(NSError *error) {
            if (error == nil) {
                [self showRow:sender.tag];
            }else{
                LKLogInfo(@"==阅读失败==");
            }
        }];
    }
    
  

}

- (void)showRow:(NSInteger)index{
    NSArray* arr=[self.rowDatas objectAtIndex:index];
    NSDictionary *dict = arr.firstObject;
    NSString *replay = dict[@"reply_content"];
    
    if ([replay isEqualToString:@""]) {
//        return;
    }
    
    NSString*  state=[self.isOpenArr objectAtIndex:index];
    if ([state isEqualToString:@"open"]) {
        state=@"close";
    }else
    {
        state=@"open";
    }
    self.isOpenArr[index]=state;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
        [self reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    });
}


- (void)issueAlreadyRead:(NSString *)issueId complete:(void(^)(NSError *error))complete{
    
    [LKIssueApi readIssueWithId:issueId complete:^(NSError * _Nonnull error) {
        if (complete) {
            complete(error);
        }
    }];
}

@end
