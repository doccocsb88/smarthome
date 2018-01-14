//
//  WellComeViewController.m
//  SmartHome
//
//  Created by Apple on 1/13/18.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "WellComeViewController.h"
#import <QRCodeReader.h>
#import <QRCodeReaderViewController.h>
#import <QRCodeReaderDelegate.h>
#import <STPopup/STPopup.h>
#import "User.h"
#import "FirebaseHelper.h"
#import "Helper.h"
@interface WellComeViewController ()<QRCodeReaderDelegate>{
    QRCodeReader *reader;
    
    // Instantiate the view controller
    QRCodeReaderViewController *vc;
}
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) UIButton *memberButton;
@end

@implementation WellComeViewController
- (instancetype)init
{
    if (self = [super init]) {
        self.title = [NSString stringWithFormat:@"Xin Chào %@",[User sharedInstance].displayName];
         self.contentSizeInPopup = CGSizeMake(300, 400);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contentLabel = [UILabel new];
    self.contentLabel.frame = CGRectMake(20, 20, self.contentSizeInPopup.width - 40, self.contentSizeInPopup.height - 150);
    self.contentLabel.text = @"- Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text \n\n- Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text ";
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentLabel sizeToFit];

    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.backgroundColor = [UIColor redColor];
    //
    self.startButton = [UIButton new];
    self.startButton.frame = CGRectMake(20, self.contentSizeInPopup.height - 100, self.contentSizeInPopup.width - 40, 40);
    [self.startButton setTitle:@"Cài đặt mới" forState:UIControlStateNormal];
    self.startButton.backgroundColor = [Helper colorFromHexString:@"42B38F"];
    [self.startButton addTarget:self action:@selector(pressedStart:) forControlEvents:UIControlEventTouchUpInside];
    //
    self.memberButton = [UIButton new];
    self.memberButton.frame = CGRectMake(20, self.contentSizeInPopup.height - 50, self.contentSizeInPopup.width - 40, 40) ;
    [self.memberButton setTitle:@"Nhận dữ liệu từ máy khác" forState:UIControlStateNormal];
    self.memberButton.backgroundColor = [Helper colorFromHexString:@"42B38F"];
    [self.memberButton addTarget:self action:@selector(pressedRequestMember:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.memberButton];
    [self.view addSubview:self.contentLabel];
    [self initQRCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initQRCode{
    reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // Instantiate the view controller
    vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
}
-(void)showQRCodeReaderScreen{
    
    __weak WellComeViewController *weakSelf = self;
    
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // Define the delegate receiver
    vc.delegate = self;
    // Or use blocks
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        NSLog(@"%@", resultAsString);
        [weakSelf dismissViewControllerAnimated:true completion:nil];
        if ([resultAsString containsString:@":"]) {
            NSArray *qrArr =[resultAsString componentsSeparatedByString:@":"];
            NSString *typeString = qrArr[0];
            NSString *requestUid = qrArr[1];
            if ([typeString isEqualToString:@"share"]) {
                [[FirebaseHelper sharedInstance]requestMember:requestUid completion:^(BOOL exist) {
                    if (exist) {
                        [weakSelf showAlert:@"" message:@"Đăng ký thành viên thành công"];
                        [weakSelf dismissViewControllerAnimated:YES completion:^{
                            weakSelf.completion(true);

                        }];

                    }
                }];
            }
        }
        
    }];
    [self presentViewController:vc animated:YES completion:NULL];
    
}
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result{
    if (vc) {
        [vc dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)readerDidCancel:(QRCodeReaderViewController *)reader{
    if (vc) {
        [vc dismissViewControllerAnimated:YES completion:nil];
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
-(void)pressedStart:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:^{
        self.completion(true);
    }];
}
-(void)pressedRequestMember:(UIButton *)button{
    [self showQRCodeReaderScreen];
    
}
@end
