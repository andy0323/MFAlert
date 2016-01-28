//
//  ViewController.m
//  MFAlertDemo
//
//  Created by andy on 1/28/16.
//  Copyright © 2016 MFKit. All rights reserved.
//

#import "ViewController.h"
#import "MFAlert.h"

@interface ViewController ()<MFAlertViewDelegate, MFActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark MFAlertViewDelegate

- (void)alertView:(MFAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@：buttonIndex：%d", NSStringFromSelector(_cmd), buttonIndex);
}

- (void)alertView:(MFAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@：buttonIndex：%d", NSStringFromSelector(_cmd), buttonIndex);
}

- (void)alertView:(MFAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@：buttonIndex：%d", NSStringFromSelector(_cmd), buttonIndex);
}

- (void)alertViewCancel:(MFAlertView *)alertView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)willPresentAlertView:(MFAlertView *)alertView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)didPresentAlertView:(MFAlertView *)alertView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(MFAlertView *)alertView
{
    return NO;
}

#pragma mark -
#pragma mark MFActionSheetDelegate

- (void)actionSheet:(MFActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)actionSheetCancel:(MFActionSheet *)actionSheet
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)willPresentActionSheet:(MFActionSheet *)actionSheet
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)didPresentActionSheet:(MFActionSheet *)actionSheet
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)actionSheet:(MFActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)actionSheet:(MFActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
