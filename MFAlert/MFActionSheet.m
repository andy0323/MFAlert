//
//  MFActionSheet.m
//  MFAlertViewDemo
//
//  Created by andy on 1/27/16.
//  Copyright © 2016 MFKit. All rights reserved.
//

#import "MFActionSheet.h"
#import "MFAlertController.h"

#define MF_SHEET_IS_IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@interface MFActionSheet ()<UIActionSheetDelegate>
@property (nonatomic, assign) NSInteger buttonPressedIndex;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) MFAlertController *alertController;
@end


@implementation MFActionSheet

/// 初始化
- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<MFActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [super init]) {
        if (MF_SHEET_IS_IOS9) {
            self.delegate = delegate;
            self.alertController = [MFAlertController alertControllerWithTitle:title
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
            [self alertControllerAppendButtonTitle:cancelButtonTitle];
            [self alertControllerAppendButtonTitle:otherButtonTitles];
            
            typeof(self) weakSelf = self;
            self.alertController->MFAlertWillPresentHandler = ^{
                if ([weakSelf.delegate respondsToSelector:@selector(willPresentActionSheet:)]) {
                    [weakSelf.delegate willPresentActionSheet:weakSelf];
                }
            };
            self.alertController->MFAlertDidPresentHandler = ^{
                if ([weakSelf.delegate respondsToSelector:@selector(didPresentActionSheet:)]) {
                    [weakSelf.delegate didPresentActionSheet:weakSelf];
                }
            };
            self.alertController->MFAlertwillDismissHandler = ^{
                if ([weakSelf.delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
                    [weakSelf.delegate actionSheet:weakSelf willDismissWithButtonIndex:weakSelf.buttonPressedIndex];
                }
            };
            self.alertController->MFAlertDidDismissHandler = ^{
                if ([weakSelf.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
                    [weakSelf.delegate actionSheet:weakSelf didDismissWithButtonIndex:weakSelf.buttonPressedIndex];
                }
            };
        }else {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                           delegate:self
                                                  cancelButtonTitle:cancelButtonTitle
                                             destructiveButtonTitle:destructiveButtonTitle
                                                  otherButtonTitles:otherButtonTitles, nil];
        }
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
    
    return self;
}

/// 显示弹出框
- (void)showInView:(UIView *)view
{
    if (MF_SHEET_IS_IOS9) {
        UIViewController *mainVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [mainVc presentViewController:self.alertController animated:YES completion:nil];
    }else {
        [self.actionSheet showInView:view];
    }
}

/// 添加弹出框按钮标题
- (NSInteger)addButtonWithTitle:(NSString *)title
{
    NSInteger retCount;
    
    if (MF_SHEET_IS_IOS9) {
        [self alertControllerAppendButtonTitle:title];
        retCount = self.alertController.actions.count;
    }else {
        retCount = [self.actionSheet addButtonWithTitle:title];
    }
    
    return retCount;
}

/// 获取弹出框对应索引标题
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
    NSString *retTitile;
    if (MF_SHEET_IS_IOS9) {
        UIAlertAction *action = [self.alertController.actions objectAtIndex:buttonIndex];
        retTitile = action.title;
    }else {
        retTitile = [self.actionSheet buttonTitleAtIndex:buttonIndex];
    }
    return retTitile;
}

/// 隐藏警告框
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (MF_SHEET_IS_IOS9) {
        [self.alertController dismissViewControllerAnimated:animated completion:nil];
    }else {
        [self.actionSheet dismissWithClickedButtonIndex:buttonIndex animated:animated];
    }
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
                                                       
                                                       if ([weakSelf.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
                                                           [weakSelf.delegate actionSheet:weakSelf clickedButtonAtIndex:buttonIndex];
                                                       }
                                                       
                                                       weakSelf.buttonPressedIndex = buttonIndex;
                                                   }];
    [self.alertController addAction:action];
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:buttonIndex];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    if ([self.delegate respondsToSelector:@selector(actionSheetCancel:)]) {
        [self.delegate actionSheetCancel:self];
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    if ([self.delegate respondsToSelector:@selector(willPresentActionSheet:)]) {
        [self.delegate willPresentActionSheet:self];
    }
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    if ([self.delegate respondsToSelector:@selector(didPresentActionSheet:)]) {
        [self.delegate didPresentActionSheet:self];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([self.delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
        [self.delegate actionSheet:self willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([self.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
        [self.delegate actionSheet:self didDismissWithButtonIndex:buttonIndex];
    }
}

@end

#pragma clang diagnostic pop
