//
//  NotificationViewController.h
//  FreeWilder
//
//  Created by Soumen on 01/06/15.
//  Copyright (c) 2015 Sandeep Dutta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Side_menu.h"
#import "UIImageView+WebCache.h"
@interface NotificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,Slide_menu_delegate>
{
    // Creating Side menu object
    
    Side_menu *sidemenu;
    UIView *overlay;
}
@property (strong, nonatomic) IBOutlet UIView *footer_base;

@end
