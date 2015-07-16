//
//  AddServiceViewController.h
//  FreeWilder
//
//  Created by Rahul Singha Roy on 01/06/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Side_menu.h"
#import "UIImageView+WebCache.h"
@interface AddServiceViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,Slide_menu_delegate>

{
    // Creating Side menu object
    
    Side_menu *sidemenu;
    UIView *overlay;
}
- (IBAction)back_button:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *description1;
@property (weak, nonatomic) IBOutlet UIView *footer_base;
@property (weak, nonatomic) IBOutlet UILabel *lblPageTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
- (IBAction)NextClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoto;

@end
