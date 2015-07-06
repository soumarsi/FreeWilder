//
//  ViewController.h
//  FreeWilder
//
//  Created by Rahul Singha Roy on 27/05/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FW_JsonClass.h"
#import "ForgotpasswordViewController.h"

@interface ViewController : UIViewController
{
    IBOutlet UITextField *forgot_Password;
    NSMutableArray *forgotArray;
}

- (IBAction)login_button:(id)sender;
- (IBAction)sign_up:(id)sender;

@end

