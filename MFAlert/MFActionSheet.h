//
//  MFActionSheet.h
//  MFAlertViewDemo
//
//  Created by andy on 1/27/16.
//  Copyright © 2016 MFKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MFActionSheetDelegate;

@interface MFActionSheet : NSObject

/// 回调代理
@property(nonatomic, weak) id<MFActionSheetDelegate> delegate;

/// 弹出框标题
@property(nonatomic, copy) NSString *title;

/// 弹出框类型
@property(nonatomic, assign) UIActionSheetStyle actionSheetStyle;

/// 弹出框按钮个数
@property(nonatomic, readonly) NSInteger numberOfButtons;

/// 初始化
- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<MFActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...;


/// 显示弹出框
- (void)showInView:(UIView *)view;

/// 添加弹出框按钮标题
- (NSInteger)addButtonWithTitle:(NSString *)title;

/// 获取弹出框对应索引标题
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

/// 隐藏ActionSheet
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end

@protocol MFActionSheetDelegate <NSObject>
@optional
/// 警告框按钮点击回调
- (void)actionSheet:(MFActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

/// 警告框取消按钮被点击回调
- (void)actionSheetCancel:(MFActionSheet *)actionSheet;

/// 警告框将要弹出
- (void)willPresentActionSheet:(MFActionSheet *)actionSheet;

/// 警告框已经弹出
- (void)didPresentActionSheet:(MFActionSheet *)actionSheet;

/// 警告框将要隐藏
- (void)actionSheet:(MFActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;

/// 警告框已经隐藏
- (void)actionSheet:(MFActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end