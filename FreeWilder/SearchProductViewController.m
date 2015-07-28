//
//  SearchProductViewController.m
//  FreeWilder
//
//  Created by Priyanka ghosh on 14/07/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import "SearchProductViewController.h"

@interface SearchProductViewController ()

@end

@implementation SearchProductViewController
@synthesize txtPreductName,txtLocation,LocationView,btnDate,btnTime,btnSearch,SearchTable,txtDays,txtTime,btnBack,lblProduct,lblPageTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,30, 20)];
    txtPreductName.leftView = paddingView1;
    txtPreductName.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,30, 20)];
    txtLocation.leftView = paddingView2;
    txtLocation.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,30, 20)];
    txtDays.leftView = paddingView3;
    txtDays.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,30, 20)];
    txtTime.leftView = paddingView4;
    txtTime.leftViewMode = UITextFieldViewModeAlways;
    
    
    
        
    
    
   
    ArrTime=[[NSMutableArray alloc]initWithObjects:@"All Times",@"Now",@"Morning",@"Afternoon",@"Evening", nil];
    
    Footer *footer=[[Footer alloc]init];
    footer.frame=CGRectMake(0,0,_footer_base.frame.size.width,_footer_base.frame.size.height);
    footer.Delegate=self;
     [footer TapCheck:2];
    [_footer_base addSubview:footer];
    
    
    /// Getting side from Xiv & creating a black overlay
    
    overlay=[[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    overlay.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:.6];
    overlay.hidden=YES;
    overlay.userInteractionEnabled=YES;
    [self.view addSubview:overlay];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Slide_menu_off)];
    tapGesture.numberOfTapsRequired=1;
    [overlay addGestureRecognizer:tapGesture];
    
    
    sidemenu=[[Side_menu alloc]init];
    sidemenu.frame=CGRectMake([UIScreen mainScreen].bounds.size.width,0,sidemenu.frame.size.width,[UIScreen mainScreen].bounds.size.height);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //  NSLog(@"user name=%@",[prefs valueForKey:@"UserName"]);
    sidemenu.lblUserName.text=[prefs valueForKey:@"UserName"];
    
    [sidemenu.ProfileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[prefs valueForKey:@"UserImage"]]] placeholderImage:[UIImage imageNamed:@"ProfileImage"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
  //  sidemenu.ProfileImage.contentMode=UIViewContentModeScaleAspectFill;
    
    sidemenu.hidden=YES;
    sidemenu.SlideDelegate=self;
    [self.view addSubview:sidemenu];
    
    
    globalobj=[[FW_JsonClass alloc]init];
    ArrSearchList=[[NSMutableArray alloc] init];
    
    txtPreductName.placeholder=@"Enter a Business or Service";
    txtLocation.placeholder=@"Location";
    txtDays.placeholder=@"All Days";
    txtTime.placeholder=@"All Times";
    [btnSearch setTitle:@"SEARCH" forState:UIControlStateNormal];
    lblPageTitle.text=@"Product Search";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pushmethod:(UIButton *)sender
{
    if (sender.tag==5)
    {
        
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.6
                            options:1 animations:^{
                                
                                
                                
                                sidemenu.hidden=NO;
                                overlay.hidden=NO;
                                
                                
                                sidemenu.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-sidemenu.frame.size.width,0,sidemenu.frame.size.width,[UIScreen mainScreen].bounds.size.height);
                                
                            }
         
                         completion:^(BOOL finished)
         {
             
             overlay.userInteractionEnabled=YES;
             
         }];
        
        
    }
    else if (sender.tag==4)
    {
        
        SearchProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"add_service_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==3)
    {
        
        SearchProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"msg_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    /*
    else if (sender.tag==2)
    {
        
        WishlistViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"search_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
     */
    else if (sender.tag==1)
    {
        
        SearchProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Interest_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    
    
    
}

-(void)Slide_menu_off
{
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.6
                        options:1 animations:^{
                            
                            overlay.hidden=YES;
                            sidemenu.frame=CGRectMake([UIScreen mainScreen].bounds.size.width,0,sidemenu.frame.size.width,[UIScreen mainScreen].bounds.size.height);
                            
                        }
     
                     completion:^(BOOL finished)
     {
         
         sidemenu.hidden=YES;
         
         
     }];
    
    
}
//side menu
-(void)action_method:(UIButton *)sender
{
    
    NSLog(@"##### test mode...%ld",(long)sender.tag);
    
    [UIView transitionWithView:sidemenu
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionNone
                    animations:^{
                        
                        overlay.hidden=YES;
                        sidemenu.frame=CGRectMake([UIScreen mainScreen].bounds.size.width,0,sidemenu.frame.size.width,[UIScreen mainScreen].bounds.size.height);
                        
                    }
     
                    completion:^(BOOL finished)
     {
         
         sidemenu.hidden=YES;
         overlay.userInteractionEnabled=NO;
         
         
         if (sender.tag==1)
         {
             SearchProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Invite_Friend"];
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         
         else if (sender.tag==8)
         {
             NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
             [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
             
             
             [[FBSession activeSession] closeAndClearTokenInformation];
             
             NSUserDefaults *userData=[NSUserDefaults standardUserDefaults];
             
             [userData removeObjectForKey:@"status"];
             
             [userData removeObjectForKey:@"logInCheck"];

             
             SearchProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Login_Page"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==5)
         {
             
             SearchProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ServiceListingViewControllersid"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
        
          else if (sender.tag==7)
          {
          
          SearchProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"WishlistViewControllersid"];
          
          [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
          }
         
         else if (sender.tag==3)
         {
             
             SearchProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Edit_profile_page"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         
         
     }];
    
}
-(void)PushViewController:(UIViewController *)viewController WithAnimation:(NSString *)AnimationType
{
    CATransition *Transition=[CATransition animation];
    [Transition setDuration:0.5f];
    [Transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [Transition setType:AnimationType];
    [[[[self navigationController] view] layer] addAnimation:Transition forKey:nil];
    [[self navigationController] pushViewController:viewController animated:NO];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //UITextField *yourTextField;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    if(textField==txtPreductName)
    {
        
    }
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)DayClick:(id)sender
{
   
    
    [txtLocation resignFirstResponder];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         calenderView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:.5
                                               delay:1.0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              calenderView.alpha = 1.0f;
                                              
    
                        
                                          }
                                          completion:NULL];
                     }];

    if(self.view.frame.size.width==375)
    {
        //  [self.mainscroll setContentOffset:CGPointMake(0.0f,50.0f) animated:YES];
        calenderView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height)];
        [calenderView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8]];
        [self.view addSubview:calenderView];
        
        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
        calendar.delegate = self;
        /*
         self.dateFormatter = [[NSDateFormatter alloc] init];
         [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
         self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
         
         self.disabledDates = @[
         //                [self.dateFormatter dateFromString:@"05/01/2013"],
         //                [self.dateFormatter dateFromString:@"06/01/2013"],
         //                [self.dateFormatter dateFromString:@"07/01/2013"]
         ];
         */
        calendar.onlyShowCurrentMonth = NO;
        calendar.adaptHeightToNumberOfWeeksInMonth = YES;
        calendar.layer.cornerRadius=0.0f;
        calendar.backgroundColor=[UIColor whiteColor];
        
        calendar.frame = CGRectMake(40,150, calenderView.frame.size.width-80,calenderView.frame.size.height);
        [calenderView addSubview:calendar];
        
        UIButton *btnCross = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCross.frame = CGRectMake(calendar.frame.origin.x+calendar.frame.size.width-30, 110, 30, 30);
        [btnCross addTarget:self action:@selector(CrossClick) forControlEvents:UIControlEventTouchUpInside];
        btnCross.imageEdgeInsets = UIEdgeInsetsMake(5,5, 5, 5);
        [btnCross setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
        [calenderView addSubview:btnCross];
    }
    
    else if (self.view.frame.size.width==320)
    {
        //  [self.mainscroll setContentOffset:CGPointMake(0.0f,150.0f) animated:YES];
        calenderView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height)];
        [calenderView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8]];
        [self.view addSubview:calenderView];
        
        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
        calendar.delegate = self;
        /*
         self.dateFormatter = [[NSDateFormatter alloc] init];
         [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
         self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
         
         self.disabledDates = @[
         //                [self.dateFormatter dateFromString:@"05/01/2013"],
         //                [self.dateFormatter dateFromString:@"06/01/2013"],
         //                [self.dateFormatter dateFromString:@"07/01/2013"]
         ];
         */
        calendar.onlyShowCurrentMonth = NO;
        calendar.adaptHeightToNumberOfWeeksInMonth = YES;
        calendar.layer.cornerRadius=0.0f;
        calendar.backgroundColor=[UIColor whiteColor];
        calendar.frame = CGRectMake(20,120, calenderView.frame.size.width-40,calenderView.frame.size.height);
        [calenderView addSubview:calendar];
        
        UIButton *btnCross = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCross.frame = CGRectMake(calendar.frame.origin.x+calendar.frame.size.width-30, 80, 30, 30);
        btnCross.imageEdgeInsets = UIEdgeInsetsMake(5,5, 5, 5);
        [btnCross addTarget:self action:@selector(CrossClick) forControlEvents:UIControlEventTouchUpInside];
        [btnCross setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
        [calenderView addSubview:btnCross];
        
        
    }
}
-(void)CrossClick
{
    [calenderView removeFromSuperview];
   
}
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    //  TODO: play with the coloring if we want to...
    
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    //   NSString *Current_date = [formatter stringFromDate:date];
    
    
    
    
    
}





- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];
    
    txtDays.text=str;
  //  [btnDate setTitle:str forState:UIControlStateNormal];
    
    
    
    self.navigationItem.rightBarButtonItem=nil;
    [calenderView removeFromSuperview];
    
}



- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    
    return YES;
}


- (IBAction)TimeClick:(id)sender
{
            
        [timeView removeFromSuperview];
    
        
        timeView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height)];
    
        [timeView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8]];
        [self.view addSubview:timeView];
        
        TimePicker=[[UIPickerView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-125, 180, 250,150)];
    
        [TimePicker setBackgroundColor:[UIColor whiteColor]];
        //    [repeattaskpicker setBackgroundColor:[UIColor colorWithRed:35 green:154 blue:242 alpha:1.0]];
        TimePicker.delegate=self;
        TimePicker.dataSource=self;
        [timeView addSubview:TimePicker];
        
        btnSave=[[UIButton alloc] initWithFrame:CGRectMake(TimePicker.frame.origin.x+TimePicker.frame.size.width-50, TimePicker.frame.origin.y-50, 50, 50)];
        [btnSave setTitle:@"Save" forState:UIControlStateNormal];
        btnSave.backgroundColor = [UIColor clearColor];
        [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        btnSave.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
        [btnSave addTarget:self action:@selector(pickerChange) forControlEvents:UIControlEventTouchUpInside];
        [timeView addSubview:btnSave];
        
        btnCancel=[[UIButton alloc] initWithFrame:CGRectMake(TimePicker.frame.origin.x, TimePicker.frame.origin.y-50, 60, 50)];
        [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        btnCancel.backgroundColor = [UIColor clearColor];
        [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        btnCancel.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
        [btnCancel addTarget:self action:@selector(repeatpickerCancel) forControlEvents:UIControlEventTouchUpInside];
        [timeView addSubview:btnCancel];
  

}
-(void)repeatpickerCancel
{
    [timeView removeFromSuperview];
}

-(void)pickerChange
{
    if ([time isEqualToString:@"" ] || time ==nil) {
        
        txtTime.text=[ArrTime objectAtIndex:0];
       // [btnTime setTitle:[ArrTime objectAtIndex:0] forState:UIControlStateNormal];
        
    }
    else
    {
        txtTime.text=time;
      // [btnTime setTitle:time forState:UIControlStateNormal];
    }
   
    time=@"";
    [timeView removeFromSuperview];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView==TimePicker)
    {
        return ArrTime.count;
    }
    else
    {
        return 0;
    }
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (pickerView==TimePicker)
    {
        return ArrTime[row];
    }
    else
    {
        return @"";
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pickerView==TimePicker)
    {
        time= ArrTime[row];
    }
    
    else
    {
        
    }
}
- (IBAction)SearchClick:(id)sender
{
    LocationView.hidden=YES;
    btnBack.hidden=NO;
    [self SearchUrl];
}
-(void)SearchUrl
{
    [ArrSearchList removeAllObjects];
   
    
    NSString *urlstring=[NSString stringWithFormat:@"%@app_product_details_cat?servicename=%@&serviceplae=%@&opendate=%@&timeopen=%@",App_Domain_Url,[txtPreductName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[txtLocation.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[txtDays.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[txtTime.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"str=%@",urlstring);
    [globalobj GlobalDict:urlstring Globalstr:@"array" Withblock:^(id result, NSError *error) {
        
        //   NSLog(@"result=%@",result);
        if([[result valueForKey:@"response"] isEqualToString:@"success"])
            
        {
            
              NSLog(@"result=%@",[result valueForKey:@"details"]);
            
            for ( NSDictionary *tempDict1 in  [result objectForKey:@"details"])
            {
                [ArrSearchList addObject:tempDict1];
                
            }
            //    lblCategoryName.text=[[ArrProductList objectAtIndex:0] valueForKey:@"category_name"];
            
            [SearchTable reloadData];
        }
        else
        {
            lblProduct.text=@"No Product Found";
            NSLog(@"No product found");
            [SearchTable reloadData];
        }
        if (ArrSearchList.count==0)
        {
            lblProduct.text=@"No Product Found";
            NSLog(@"No product found");
        }
        else
        {
            lblProduct.text=@"";
        }
        }];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
     ProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Product_details"];
     
     [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
     */
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 290;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //  NSLog(@"arr count1=%lu",(unsigned long)[ArrProductList count]);
    return [ArrSearchList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Productcell *cell=(Productcell *)[tableView dequeueReusableCellWithIdentifier:@"productcell"];
    cell.lblProductName.text=[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.lblProductDesc.text=[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"description"];
    
    [cell.ProductImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"product_image"]]] placeholderImage:[UIImage imageNamed:@"PlaceholderImg"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
    cell.ProductImage.contentMode=UIViewContentModeScaleAspectFill;
    cell.ProductImage.clipsToBounds = YES;
    
    //product cost
    NSString *priceSign;
    if ([[[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"price"] substringToIndex:3] isEqualToString:@"EUR"])
    {
        priceSign=@"€";
        // NSLog(@"price=%@",priceSign);
    }
    else if ([[[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"price"] substringToIndex:3] isEqualToString:@"INR"])
    {
        priceSign=@"₹";
        //  NSLog(@"price=%@",priceSign);
    }
    else if ([[[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"price"] substringToIndex:3] isEqualToString:@"USD"])
    {
        priceSign=@"$";
        // NSLog(@"price=%@",priceSign);
    }
    else if ([[[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"price"] substringToIndex:3] isEqualToString:@"PLN"])
    {
        priceSign=@"zł";
        // NSLog(@"price=%@",priceSign);
    }
    NSString *price=[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"price"];
    NSInteger len=price.length;
    cell.lblProductCost.text=[priceSign stringByAppendingString:[[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"price"] substringWithRange:NSMakeRange(4, len-4)]];
    
    //user image
    cell.UserImage.layer.cornerRadius = cell.UserImage.frame.size.height/2;
    cell.UserImage.clipsToBounds = YES;
    cell.UserImage.userInteractionEnabled=YES;
    cell.UserImage.layer.borderColor=[UIColor whiteColor].CGColor;
    cell.UserImage.layer.borderWidth=1.5;
    cell.UserImage.contentMode=UIViewContentModeScaleAspectFill;
    [cell.UserImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"user_image"]]] placeholderImage:[UIImage imageNamed:@"Profile_image_placeholder"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
    
    cell.lblDate.text=[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"date"];
    if ([[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"start_time"] isEqualToString:@""])
    {
        cell.lblStartTime.hidden=YES;
    }
    else
    {
        cell.lblStartTime.hidden=NO;
        cell.lblStartTime.text=[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"start_time"];
    }
    
    cell.lblDate.text=[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"date"];
    if ([[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"close_time"] isEqualToString:@""])
    {
        cell.lblEndTime.hidden=YES;
    }
    else
    {
        cell.lblEndTime.hidden=NO;
        cell.lblEndTime.text=[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"close_time"];
    }
    cell.lblDate.text=[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"date"];
    return cell;
}
- (IBAction)BackClick:(id)sender
{
    LocationView.hidden=NO;
    btnBack.hidden=YES;
}
@end
