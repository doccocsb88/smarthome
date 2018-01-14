//
//  AddMenuViewController.m
//  SmartHome
//
//  Created by Apple on 3/23/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "AddMenuViewController.h"
#import <QRCodeReader.h>
#import <QRCodeReaderViewController.h>
#import <QRCodeReaderDelegate.h>
#define MENU_SIZE 50
@interface AddMenuViewController () <UITableViewDelegate, UITableViewDataSource, QRCodeReaderDelegate>
{
    NSMutableArray *dataArray;
    CGSize screenSize;
    QRCodeReader *reader;
    
    // Instantiate the view controller
    QRCodeReaderViewController *vc;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginTop;

@end

@implementation AddMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.marginTop.constant = (screenSize.height - MENU_SIZE * dataArray.count)/2 - 20;
    [self.view updateFocusIfNeeded];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    dataArray = [[NSMutableArray alloc] init];
    [dataArray addObject:@"Tạo Phòng"];
   // [dataArray addObject:@"Thêm Thiết Bị"];
    [dataArray addObject:@"Sắp Xếp Phòng"];
    [dataArray addObject:@"Thoát"];
    //
    screenSize = [UIScreen mainScreen].bounds.size;
    self.tableView.alwaysBounceVertical = true;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = false;
    //
    reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // Instantiate the view controller
    vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MENU_SIZE;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddMenuViewCell *cell = (AddMenuViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AddMenuViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = [dataArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;

    switch (index) {
        case 0:
            //tao phong

     
            [self showAddRoomView];

            break;
        //case 1:
            //them theit bi
         //   [self showQRCodeReaderScreen];
         //   break;
        case 1:
            //sap xep phong
        [self showSortRoomViewController ];
        break;
        case 2:
            //thoat
            [self dismissViewControllerAnimated:true completion:nil];
            break;
        default:
            break;
    }
}
-(void)showQRCodeReaderScreen{

    // Set the presentation style
  
    __weak AddMenuViewController *weakSelf = self;
    
    [self dismissViewControllerAnimated:true completion:^{
        //                ;
        [weakSelf.delegate didShowQRCode];
    }];
}

-(void)showAddRoomView{
    __weak AddMenuViewController *weakSelf = self;

    [self dismissViewControllerAnimated:true completion:^{
        //                ;
        [weakSelf.delegate didShowAddDevice];
    }];
   
}
    
-(void)showSortRoomViewController{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(openSortRoom)]) {
            [self.delegate openSortRoom];
        }
        
    }];

}
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", result);
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
