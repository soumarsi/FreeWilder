//
//  SearchProductViewController.h
//  FreeWilder
//
//  Created by Priyanka ghosh on 14/07/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"
#import "Side_menu.h"
#import "FW_JsonClass.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "Productcell.h"
#import "Footer.h"
@interface SearchProductViewController : UIViewController<UITextFieldDelegate,CKCalendarDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,Slide_menu_delegate,footerdelegate>
{
    UIView *calenderView,*timeView;
    NSMutableArray *ArrTime;
    UIPickerView *TimePicker;
    UIButton *btnSave,*btnCancel;
    NSString *time;
    Side_menu *sidemenu;
    UIView *overlay;
    FW_JsonClass *globalobj;
    NSMutableArray *ArrSearchList;
 //   UIButton *btnCross;
 //   CKCalendarView *calendar;
}
@property (weak, nonatomic) IBOutlet UITextField *txtPreductName;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;
@property (weak, nonatomic) IBOutlet UIView *LocationView;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
- (IBAction)DayClick:(id)sender;
- (IBAction)TimeClick:(id)sender;
- (IBAction)SearchClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *footer_base;
@property (weak, nonatomic) IBOutlet UITextField *txtDays;
@property (weak, nonatomic) IBOutlet UITextField *txtTime;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblProduct;

@property (weak, nonatomic) IBOutlet UITableView *SearchTable;
- (IBAction)BackClick:(id)sender;


@end
