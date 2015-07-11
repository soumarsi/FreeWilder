//
//  ServiceListingViewController.h
//  FreeWilder
//
//  Created by Priyanka ghosh on 11/07/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Side_menu.h"
#import "FW_JsonClass.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "ServiceListCell.h"
#import "Footer.h"
@interface ServiceListingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,Slide_menu_delegate>
{
    // Creating Side menu object
    
    Side_menu *sidemenu;
    UIView *overlay;
    FW_JsonClass *globalobj;
    NSMutableArray *ArrProductList;
    AppDelegate *appDelegate;
    bool data;
}
@property (weak, nonatomic) IBOutlet UITableView *tblService;
- (IBAction)BackClick:(id)sender;

@end
