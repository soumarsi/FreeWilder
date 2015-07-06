//
//  InviteFriendViewController.h
//  FreeWilder
//
//  Created by Soumen on 01/06/15.
//  Copyright (c) 2015 Sandeep Dutta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Side_menu.h"

@interface FW_InviteFriendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,Slide_menu_delegate>
{
    // Creating Side menu object
    
    Side_menu *sidemenu;
    UIView *overlay;

}

@property (strong, nonatomic) IBOutlet UIView *footer_base;
@property (strong, nonatomic) IBOutlet UITextField *searchtextfield;

- (IBAction)Back_button_action:(id)sender;


@end
