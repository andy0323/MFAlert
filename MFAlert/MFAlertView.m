//
//  MFAlertView.m
//  MFAlertViewDemo
//
//  Created by andy on 1/26/16.
//  Copyright © 2016 MFKit. All rights reserved.
//

#import "MFAlertView.h"
#import "MFAlertController.h"

#define MF_ALERT_IS_IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@interface MFAlertView ()<UIAlertViewDelegate>
@property (nonatomic, assign) NSInteger buttonPressedIndex;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) MFAlertController *alertController;
@end

@implementation MFAlertView

/// 初始化
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id<MFAlertViewDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [super init]) {
        
        if (MF_ALERT_IS_IOS9) {
            self.delegate = delegate;
            self.alertController = [MFAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
            [self alertControllerAppendButtonTitle:cancelButtonTitle];
            [self alertControllerAppendButtonTitle:otherButtonTitles];
            
            typeof(self) weakSelf = self;
            self.alertController->MFAlertWillPresentHandler = ^{
                if ([weakSelf.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
                    [weakSelf.delegate willPresentAlertView:weakSelf];
                }
            };
            self.alertController->MFAlertDidPresentHandler = ^{
                if ([weakSelf.delegate respondsToSelector:@selector(didPresentAlertView:)]) {
                    [weakSelf.delegate didPresentAlertView:weakSelf];
                }
            };
            self.alertController->MFAlertwillDismissHandler = ^{
                if ([weakSelf.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
                    [weakSelf.delegate alertView:weakSelf willDismissWithButtonIndex:weakSelf.buttonPressedIndex];
                }
            };
            self.alertController->MFAlertDidDismissHandler = ^{
                if ([weakSelf.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
                    [weakSelf.delegate alertView:weakSelf didDismissWithButtonIndex:weakSelf.buttonPressedIndex];
                }
            };
        }else {
            self.alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:otherButtonTitles, nil];
        }
        
        va_list args;
        va_start(args, otherButtonTitles);

        id arg;
        while ((arg = va_arg(args, id))) {
            if (arg && [arg isKindOfClass:[NSString class]]) {
                [self addButtonWithTitle:arg];
            }
        }
        
        va_end(args);
    }
    return self;
}

/// 添加按钮
- (NSInteger)addButtonWithTitle:(NSString *)title
{
    NSInteger retCount;
    
    if (MF_ALERT_IS_IOS9) {
        [self alertControllerAppendButtonTitle:title];
        retCount = self.alertController.actions.count;
    }else {
        retCount = [self.alertView addButtonWithTitle:title];
    }
    
    return retCount;
}

/// 显示弹出框
- (void)show
{
    if (MF_ALERT_IS_IOS9) {
        // 首个按钮是否可以点击
        if ([self.delegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)]) {
            
            BOOL shouldEnableFirstOtherButton = [self.delegate alertViewShouldEnableFirstOtherButton:self];
            
            if (!shouldEnableFirstOtherButton && self.alertController.actions.count) {
                UIAlertAction *action = self.alertController.actions[0];
                action.enabled = shouldEnableFirstOtherButton;
            }
        }
        
        switch (self.alertViewStyle) {
            case MFAlertViewStylePlainTextInput:
                [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    
                }];
                break;
            case MFAlertViewStyleSecureTextInput:
                [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.secureTextEntry = YES;
                }];
                break;
            case MFAlertViewStyleLoginAndPasswordInput:
                [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"Login";
                }];
                [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"Password";
                }];
                break;
            default:
                break;
        }
        
        UIViewController *mainVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [mainVc presentViewController:self.alertController animated:YES completion:nil];
    }else {
        [self.alertView show];
    }
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
    NSString *retTitile;
    if (MF_ALERT_IS_IOS9) {
        UIAlertAction *action = [self.alertController.actions objectAtIndex:buttonIndex];
        retTitile = action.title;
    }else {
        retTitile = [self.alertView buttonTitleAtIndex:buttonIndex];
    }
    return retTitile;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (MF_ALERT_IS_IOS9) {
        [self.alertController dismissViewControllerAnimated:animated completion:nil];
    }else {
        [self.alertView dismissWithClickedButtonIndex:buttonIndex animated:animated];
    }
}

- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex
{
    UITextField *retTextField;
    if (MF_ALERT_IS_IOS9) {
        retTextField = [self.alertController.textFields objectAtIndex:textFieldIndex];
    }else {
        retTextField = [self.alertView textFieldAtIndex:textFieldIndex];
    }
    return retTextField;
}

#pragma mark -
#pragma mark private

- (void)alertControllerAppendButtonTitle:(NSString *)buttonTitle
{
    if (!buttonTitle.length && ![buttonTitle isKindOfClass:[NSString class]]) {
        return;
    }
    
    typeof(self) weakSelf = self;
    UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       NSInteger buttonIndex = [weakSelf.alertController.actions indexOfObject:action];
                                                       
                                                       if ([weakSelf.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
                                                           [weakSelf.delegate alertView:self clickedButtonAtIndex:buttonIndex];
                                                       }
                                                       
                                                       weakSelf.buttonPressedIndex = buttonIndex;
                                                   }];
    [self.alertController addAction:action];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:buttonIndex];
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    if ([self.delegate respondsToSelector:@selector(alertViewCancel:)]) {
        [self.delegate alertViewCancel:self];
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if ([self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [self.delegate willPresentAlertView:self];
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if ([self.delegate respondsToSelector:@selector(didPresentAlertView:)]) {
        [self.delegate didPresentAlertView:self];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [self.delegate alertView:self willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if ([self.delegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)]) {
        return [self.delegate alertViewShouldEnableFirstOtherButton:self];
    }
    return YES;
}

#pragma mark -
#pragma mark Setter

- (void)setTitle:(NSString *)title
{
    if (MF_ALERT_IS_IOS9) {
        self.alertController.title = title;
    }else {
        self.alertView.title = title;
    }
}

- (void)setMessage:(NSString *)message
{
    if (MF_ALERT_IS_IOS9) {
        self.alertController.message = message;
    }else {
        self.alertView.message = message;
    }
}

- (void)setAlertViewStyle:(MFAlertViewStyle)alertViewStyle
{
    _alertViewStyle = alertViewStyle;
    
    if (MF_ALERT_IS_IOS9) {
        // nothing to do
    }else {
        self.alertView.alertViewStyle = (NSInteger)alertViewStyle;
    }
}

#pragma mark -
#pragma mark Getter

- (NSInteger)numberOfButtons
{
    NSInteger numberOfButtons;
    if (MF_ALERT_IS_IOS9) {
        numberOfButtons = self.alertController.actions.count;
    }else {
        numberOfButtons = self.alertView.numberOfButtons;
    }
    return numberOfButtons;
}

@end

#pragma clang diagnostic pop
