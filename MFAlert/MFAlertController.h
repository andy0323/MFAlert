//
//  MFAlertController.h
//  MFAlertViewDemo
//
//  Created by andy on 1/27/16.
//  Copyright © 2016 MFKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFAlertController : UIAlertController
{
@public
    void (^MFAlertWillPresentHandler)(void);
    void (^MFAlertDidPresentHandler)(void);
    void (^MFAlertwillDismissHandler)(void);
    void (^MFAlertDidDismissHandler)(void);
}

@end
