//
//  MFAlertController.m
//  MFAlertViewDemo
//
//  Created by andy on 1/27/16.
//  Copyright © 2016 MFKit. All rights reserved.
//

#import "MFAlertController.h"

@interface MFAlertController ()

@end

@implementation MFAlertController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (MFAlertWillPresentHandler) {
        MFAlertWillPresentHandler();
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (MFAlertDidPresentHandler) {
        MFAlertDidPresentHandler();
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (MFAlertwillDismissHandler) {
        MFAlertwillDismissHandler();
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (MFAlertDidDismissHandler) {
        MFAlertDidDismissHandler();
    }
}

@end
