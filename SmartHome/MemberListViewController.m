//
//  MemberListViewController.m
//  SmartHome
//
//  Created by Apple on 1/8/18.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "MemberListViewController.h"
#import "FirebaseHelper.h"
@interface MemberListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MemberListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self setupUI];
    [[FirebaseHelper sharedInstance] synMemberList:^(NSArray *members) {
        dataArray = [members mutableCopy];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData{
    dataArray = [NSMutableArray new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MemberViewCell" bundle:nil] forCellReuseIdentifier:@"MemberViewCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    
}
-(void)setupUI{
    self.leftButton = [[UIButton alloc] init];
    self.leftButton.frame = CGRectMake(0, 0, 40, 40);
    self.leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.leftButton setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(pressedLeft:) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.backgroundColor = [UIColor clearColor];
    self.leftButton.layer.cornerRadius = 3;
    self.leftButton.layer.masksToBounds = YES;
    self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"Danh sách thành viên";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray) {
        return dataArray.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberViewCell" forIndexPath:indexPath];
    Member *member = [dataArray objectAtIndex:indexPath.row];
    cell.displayNameLabel.text = member.displayname;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberDetailViewController *vc = [[MemberDetailViewController alloc]
                                    initWithNibName:@"MemberListViewController" bundle:nil];
    Member *member = [dataArray objectAtIndex:indexPath.row];
    vc.member = member;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)pressedLeft:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
