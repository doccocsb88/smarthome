//
//  BaseViewController.h
//  SmartHome
//
//  Created by Apple on 3/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "CoredataHelper.h"
#import "NSString+Utils.h"
#import "SCSkypeActivityIndicatorView.h"
#import "MDCActivityIndicator.h"

#define LOADING_SIZE 100

@interface BaseViewController : UIViewController
@property (nonatomic) __strong UIButton *rightButton;
@property (strong, nonatomic)  UIButton *leftButton;
@property (nonatomic, strong)  SCSkypeActivityIndicatorView *activityIndicatorView;

-(void)setupNavigator;
-(void)pressedLeft:(UIButton *)button;
-(void)pressedRight:(UIButton *)button;
-(void)initLoadingView;
-(void)showLoadingView;
-(void)hideLoadingView;
-(void)showConfirmDialog:(NSString *)title message:(NSString *)message complete:(void (^)(NSInteger index))block;

-(void)showMessageView:(NSString *)title message:(NSString *)message autoHide:(BOOL)hide complete:(void (^)(NSInteger index))block;
-(void)showAlert:(NSString *)title message:(NSString *)message;
@end
