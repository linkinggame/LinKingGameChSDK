

#import "LKIssueStyleTableView.h"
#import "LKIssueStyleTableViewCell.h"

@interface LKIssueStyleTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *data;
@end

@implementation LKIssueStyleTableView
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
    [self registerNib:[UINib nibWithNibName:@"LKIssueStyleTableViewCell" bundle:nil] forCellReuseIdentifier:@"LKIssueStyleTableViewCell"];
    
    self.tableHeaderView = [self headerView];
    self.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.rowHeight = 40;
}

- (void)reloadData:(NSArray *)data{
    self.data =data;
    [self reloadData];
    
}

- (UIView *)headerView{
    
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.frame.size.width, 40);
    view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *label_year = [[UILabel alloc] init];
    label_year.text = @"请选择反馈内容";
    label_year.textColor = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1];
    label_year.textAlignment = NSTextAlignmentCenter;
    label_year.font = [UIFont systemFontOfSize:14];
    label_year.frame = CGRectMake(10, 10, 100, 30);
    [view addSubview:label_year];

    
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
    LKIssueStyleTableViewCell *cell = [[bundle loadNibNamed:@"LKIssueStyleTableViewCell" owner:nil options:nil] firstObject];
    
   // LKIssueStyleTableViewCell* cell =   [tableView dequeueReusableCellWithIdentifier:@"LKIssueStyleTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //NSDictionary *record = self.data[indexPath.row];
    cell.label_name.text =  self.data[indexPath.row];
    // order_no
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectItemCallBack) {
        self.selectItemCallBack(nil, indexPath.row);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
