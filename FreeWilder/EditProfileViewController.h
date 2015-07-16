//
//  EditProfileViewController.h
//  FreeWilder
//
//  Created by Rahul Singha Roy on 01/06/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Footer.h"
#import "Side_menu.h"
#import "FW_JsonClass.h"
#import "UrlconnectionObject.h"
#import "UIImageView+WebCache.h"
@interface EditProfileViewController : UIViewController<UITextFieldDelegate,Slide_menu_delegate>
{
     Side_menu *sidemenu;
    UIView *overlay;
    FW_JsonClass *globalobj;
    UrlconnectionObject *urlobj;
    NSString *UserId;
    UIActionSheet *actionsheet;
}
@property (strong, nonatomic) IBOutlet UIView *footer_base;
- (IBAction)back_button:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImg;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
- (IBAction)SaveClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *mainscroll;
@property (weak, nonatomic) IBOutlet UILabel *lblPagetitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)ImageClick:(id)sender;


@end
