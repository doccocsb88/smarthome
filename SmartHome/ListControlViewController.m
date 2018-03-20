//
//  ListControlViewController.m
//  SmartHome
//
//  Created by Apple on 3/20/18.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "ListControlViewController.h"
#import "ControlViewCell.h"
#import "CoredataHelper.h"
@interface ListControlViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation ListControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableview.scrollEnabled = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"ControlViewCell" bundle:nil] forCellReuseIdentifier:@"ControlViewCell"];
    dataArray = [[[CoredataHelper sharedInstance] getListcontroller] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray) {
        return dataArray.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Controller *controller = [dataArray objectAtIndex:indexPath.row];

    ControlViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ControlViewCell" forIndexPath:indexPath];
    cell.nameLabel.text = controller.name ? controller.name: controller.id ;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Controller *controller = [dataArray objectAtIndex:indexPath.row];
    if (self.handleSelectControl) {
        self.handleSelectControl(controller);
    }
}
- (IBAction)addButtonTapped:(id)sender {
    if (self.handleAddControl) {
        self.handleAddControl();
    }
}

@end
