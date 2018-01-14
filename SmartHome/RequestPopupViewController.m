//
//  RequestPopupViewController.m
//  SmartHome
//
//  Created by Apple on 1/13/18.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "RequestPopupViewController.h"
#import <QRCodeReader.h>
#import <QRCodeReaderViewController.h>
#import <QRCodeReaderDelegate.h>
#import <STPopup/STPopup.h>
#import "FirebaseHelper.h"
#import "User.h"
@interface RequestPopupViewController ()<QRCodeReaderDelegate>
{
    QRCodeReader *reader;
    
    // Instantiate the view controller
    QRCodeReaderViewController *vc;
}
@end

@implementation RequestPopupViewController
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnDidTap)];
    [self initQRCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)initQRCode{
    reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // Instantiate the view controller
    vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
}

-(void)showQRCodeReaderScreen{
    
    __weak RequestPopupViewController *weakSelf = self;
    
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
                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectNext)]) {
                            [weakSelf.delegate didSelectNext];
                        }
                        
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
- (void)nextBtnDidTap
{
    [self showQRCodeReaderScreen];
}
@end
