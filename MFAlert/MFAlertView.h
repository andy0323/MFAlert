//
//  MFAlertView.h
//  MFAlertViewDemo
//
//  Created by andy on 1/26/16.
//  Copyright © 2016 MFKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MFAlertViewStyle) {
    MFAlertViewStyleDefault = 0,
    MFAlertViewStyleSecureTextInput,
    MFAlertViewStylePlainTextInput,
    MFAlertViewStyleLoginAndPasswordInput
};

@protocol MFAlertViewDelegate;
@interface MFAlertView : NSObject

/// 标题
@property(nonatomic, copy) NSString *title;

/// 消息内容
@property(nonatomic, copy) NSString *message;

/// 回调代理
@property (nonatomic, weak) id<MFAlertViewDelegate> delegate;

/// 按钮个数
@property(nonatomic, readonly) NSInteger numberOfButtons;

/// 按钮类型
@property(nonatomic, assign) MFAlertViewStyle alertViewStyle;

/// 初始化警告框
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id<MFAlertViewDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...;

/// 弹出警告框
- (void)show;

/// 添加警告框按钮
- (NSInteger)addButtonWithTitle:(NSString *)title;

/// 获取索引下的按钮标题
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

/// 隐藏AlertView
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

/// 文本输入框
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;

@end

@protocol MFAlertViewDelegate <NSObject>

/// 警告框按钮点击回调
- (void)alertView:(MFAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

/// 警告框取消按钮被点击回调
- (void)alertViewCancel:(MFAlertView *)alertView;

/// 警告框将要弹出
- (void)willPresentAlertView:(MFAlertView *)alertView;

/// 警告框已经弹出
- (void)didPresentAlertView:(MFAlertView *)alertView;

/// 警告框将要隐藏
- (void)alertView:(MFAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex;

/// 警告框已经隐藏
- (void)alertView:(MFAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;

/// 警告框第一个按钮是否可以被点击
- (BOOL)alertViewShouldEnableFirstOtherButton:(MFAlertView *)alertView;

@end
