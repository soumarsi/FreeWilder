//
//  ServiceListingViewController.m
//  FreeWilder
//
//  Created by Priyanka ghosh on 11/07/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import "ServiceListingViewController.h"

@interface ServiceListingViewController ()

@end

@implementation ServiceListingViewController
@synthesize tblService,lblServiceName,lblPageTitle,btnAdd;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /// initializing app footer view
    
    Footer *footer=[[Footer alloc]init];
    footer.frame=CGRectMake(0,0,_footer_base.frame.size.width,_footer_base.frame.size.height);
    footer.Delegate=self;
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
    ArrServiceList=[[NSMutableArray alloc] init];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UserId=[prefs valueForKey:@"UserId"];
    NSLog(@"User Id=%@",UserId);
    
    lblPageTitle.text=@"Service Listing";
    [btnAdd setTitle:@"Add" forState:UIControlStateNormal];
    [self ServiceDetailUrl];
}
-(void)ServiceDetailUrl
{
    
    NSManagedObjectContext *context1=[appDelegate managedObjectContext];
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"ServiceList"];
    NSMutableArray *fetchrequest=[[context1 executeFetchRequest:request error:nil] mutableCopy];
    NSInteger CoreDataCount=[fetchrequest count];
    NSLog(@"core data count=%ld",(long)CoreDataCount);
    data=0;
    
    //if data for this category present in core data or not
    for (NSManagedObject *obj1 in fetchrequest)
    {
        
        //  NSLog(@"category=%@",[obj1 valueForKey:@"categoryId"]);
        if ([[obj1 valueForKey:@"userId"] isEqualToString:UserId])
        {
            data=1;
            //  NSLog(@"data present");
            break;
        }
    }
    
    
    if (data)
    {
        [ArrServiceList removeAllObjects];
        // data present in core data so show data from core data
        NSLog(@"data from local db");
      //  NSInteger datacount;
        for (NSManagedObject *obj1 in fetchrequest)
        {
            
            //   NSLog(@"category id1=%@",[obj1 valueForKey:@"categoryId"]);
            if ([[obj1 valueForKey:@"userId"] isEqualToString:UserId])
            {
                // datacount++;
                [ArrServiceList addObject:obj1];
               // lblCategoryName.text=[[ArrProductList objectAtIndex:0] valueForKey:@"categoryname"];
            }
        }
        //   NSLog(@"arr count=%lu",(unsigned long)[ArrProductList count]);
        [tblService reloadData];
        
        //check local data and url data same or not
        //fire url
        NSString *urlstring=[NSString stringWithFormat:@"%@app_user_service?userid=%@",App_Domain_Url,[UserId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"str=%@",urlstring);
        
        
        
        [globalobj GlobalDict:urlstring Globalstr:@"array" Withblock:^(id result, NSError *error) {
            
            NSLog(@"result=%@",result);
            if([[result valueForKey:@"response"] isEqualToString:@"success"])
                
            {
                //           NSOperationQueue *myQueue2 = [[NSOperationQueue alloc] init];
                //           [myQueue2 addOperationWithBlock:^{
                NSMutableArray *tempArr=[[NSMutableArray alloc]init];
                NSInteger urldatacount;
                //  NSLog(@"result=%@",[result valueForKey:@"details"]);
                NSLog(@"result=%@",[result objectForKey:@"service_details"]);
                for ( NSDictionary *tempDict1 in  [result objectForKey:@"service_details"])
                {
                    urldatacount++;
                    [tempArr addObject:tempDict1];
                    
                }
                NSLog(@"core data count=%ld",(long)ArrServiceList.count);
                NSLog(@"url data count=%ld",(long)tempArr.count);
                // local data and url data same
                if (ArrServiceList.count==tempArr.count)
                {
                    //do nothing
                }
                else
                {
                    //delete the particular user data from core data
                    NSLog(@"delete the particular user id data from core data");
                    NSManagedObjectContext *context3=[appDelegate managedObjectContext];
                    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"ServiceList" inManagedObjectContext:context3];
                    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
                    [fetch setEntity:productEntity];
                    NSPredicate *p=[NSPredicate predicateWithFormat:@"userId == %@", UserId];
                    [fetch setPredicate:p];
                    //... add sorts if you want them
                    NSError *fetchError;
                    NSError *error;
                    NSArray *fetchedProducts=[context3 executeFetchRequest:fetch error:&fetchError];
                    for (NSManagedObject *product in fetchedProducts)
                    {
                        [context3 deleteObject:product];
                    }
                    [context3 save:&error];
                    
                    // put url data in core data
                    for ( NSDictionary *tempDict1 in  [result objectForKey:@"service_details"])
                    {
                        NSLog(@"putting data in core data.");
                        NSManagedObjectContext *context=[appDelegate managedObjectContext];
                        NSManagedObject *manageobject=[NSEntityDescription insertNewObjectForEntityForName:@"ServiceList" inManagedObjectContext:context];
                        NSLog(@"user id=%@",UserId);
                        [manageobject setValue:UserId forKey:@"userId"];
                        [manageobject setValue:[tempDict1 valueForKey:@"service_id"] forKey:@"serviceId"];
                        [manageobject setValue:[tempDict1 valueForKey:@"service_name"] forKey:@"serviceName"];
                        [manageobject setValue:[tempDict1 valueForKey:@"category_details"] forKey:@"categoryDetail"];
                        [manageobject setValue:[tempDict1 valueForKey:@"location"] forKey:@"location"];
                        [manageobject setValue:[tempDict1 valueForKey:@"step_to_list"] forKey:@"stepToList"];
                        [manageobject setValue:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[tempDict1 valueForKey:@"image"]]]] forKey:@"image"];
                        //     UIImageView *productimgview=[[UIImageView alloc]init];
                        //    [productimgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[tempDict1 valueForKey:@"product_image"]]] placeholderImage:[UIImage imageNamed:@""] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
                        
                        //   NSLog(@"image=%@",productimgview.image);
                        //   NSData *imgData= UIImagePNGRepresentation(productimgview.image);
                        //   [manageobject setValue:imgData forKey:@"productimage"];
                        
                        //    UIImageView *userimgview=[[UIImageView alloc]init];
                        //     [userimgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[tempDict1 valueForKey:@"user_image"]]] placeholderImage:[UIImage imageNamed:@"Profile_image_placeholder"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
                        //     NSLog(@"image=%@",productimgview.image);
                        //     NSData *imgData1= UIImagePNGRepresentation(userimgview.image);
                        //      [manageobject setValue:imgData1 forKey:@"userimage"];
                        
                       
                        [appDelegate saveContext];
                    }
                    
                    // data show from core data
                    [ArrServiceList removeAllObjects];
                    NSManagedObjectContext *context5=[appDelegate managedObjectContext];
                    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"ServiceList"];
                    NSMutableArray *fetchrequest=[[context5 executeFetchRequest:request error:nil] mutableCopy];
                    for (NSManagedObject *obj1 in fetchrequest)
                    {
                        
                        
                        if ([[obj1 valueForKey:@"userId"] isEqualToString:UserId])
                        {
                            
                            [ArrServiceList addObject:obj1];
                         //   lblCategoryName.text=[[ArrProductList objectAtIndex:0] valueForKey:@"categoryname"];
                        }
                    }
                    
                    [tblService reloadData];
                    
                    
                    
                    
                }
                //           [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //            }];
                //        }];
                
            }
        }];
        
        
        
    }
    else
    {
        // core data empty
        //fire url
        [ArrServiceList removeAllObjects];
        NSLog(@"data from url");
        
        NSString *urlstring=[NSString stringWithFormat:@"%@app_user_service?userid=%@",App_Domain_Url,[UserId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"str=%@",urlstring);
        [globalobj GlobalDict:urlstring Globalstr:@"array" Withblock:^(id result, NSError *error) {
            
            //   NSLog(@"result=%@",result);
            if([[result valueForKey:@"response"] isEqualToString:@"success"])
                
            {
                
                //  NSLog(@"result=%@",[result valueForKey:@"details"]);
                
                for ( NSDictionary *tempDict1 in  [result objectForKey:@"service_details"])
                {
                    [ArrServiceList addObject:tempDict1];
                    
                }
            //    lblCategoryName.text=[[ArrProductList objectAtIndex:0] valueForKey:@"category_name"];
                
                [tblService reloadData];
                
                //put data from url to core data in back ground thread
                NSOperationQueue *myQueue11 = [[NSOperationQueue alloc] init];
                [myQueue11 addOperationWithBlock:^{
                    
                    
                    
                    for ( NSDictionary *tempDict1 in  [result objectForKey:@"service_details"])
                    {
                        NSLog(@"putting image data in core data.");
                        NSManagedObjectContext *context=[appDelegate managedObjectContext];
                        NSManagedObject *manageobject=[NSEntityDescription insertNewObjectForEntityForName:@"ServiceList" inManagedObjectContext:context];
                        NSLog(@"user id=%@",UserId);
                        [manageobject setValue:UserId forKey:@"userId"];
                        [manageobject setValue:[tempDict1 valueForKey:@"service_id"] forKey:@"serviceId"];
                        [manageobject setValue:[tempDict1 valueForKey:@"service_name"] forKey:@"serviceName"];
                        [manageobject setValue:[tempDict1 valueForKey:@"category_details"] forKey:@"categoryDetail"];
                        [manageobject setValue:[tempDict1 valueForKey:@"location"] forKey:@"location"];
                        [manageobject setValue:[tempDict1 valueForKey:@"step_to_list"] forKey:@"stepToList"];
                        [manageobject setValue:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[tempDict1 valueForKey:@"image"]]]] forKey:@"image"];
                        //     UIImageView *productimgview=[[UIImageView alloc]init];
                        //    [productimgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[tempDict1 valueForKey:@"product_image"]]] placeholderImage:[UIImage imageNamed:@""] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
                        
                        //   NSLog(@"image=%@",productimgview.image);
                        //   NSData *imgData= UIImagePNGRepresentation(productimgview.image);
                        //   [manageobject setValue:imgData forKey:@"productimage"];
                        
                        //    UIImageView *userimgview=[[UIImageView alloc]init];
                        //     [userimgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[tempDict1 valueForKey:@"user_image"]]] placeholderImage:[UIImage imageNamed:@"Profile_image_placeholder"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
                        //     NSLog(@"image=%@",productimgview.image);
                        //     NSData *imgData1= UIImagePNGRepresentation(userimgview.image);
                        //      [manageobject setValue:imgData1 forKey:@"userimage"];
                        
                       
                        [appDelegate saveContext];
                    }
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    }];
                }];
            }
            else
            {
                lblServiceName.text=@"No Service Found";
                NSLog(@"no service");
                //  UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:[result valueForKey:@"message" ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //  [loginAlert show];
                
            }
            
            
            
            
        }];
    }
    
    if (ArrServiceList.count==0)
    {
        lblServiceName.text=@"No Service Found";
        NSLog(@"no service");
    }
    else
    {
         lblServiceName.text=@"";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    return [ArrServiceList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceListCell *cell=(ServiceListCell *)[tableView dequeueReusableCellWithIdentifier:@"ServiceListCell"];
    cell.btnBooking.layer.cornerRadius=15.0f;
    cell.btnEdit.layer.cornerRadius=15.0f;
    cell.lblLocation.text=[[ArrServiceList objectAtIndex:indexPath.row] valueForKey:@"location"];
    [cell.btnBooking setTitle:@"View Booking" forState:UIControlStateNormal];
    if (cell.lblLocation.text.length==0)
    {
        cell.locationImg.hidden=YES;
    }
    else
    {
        cell.locationImg.hidden=NO;
    }
    if (data)
    {
        //showing data from core data
        cell.ServiceName.text=[[ArrServiceList objectAtIndex:indexPath.row] valueForKey:@"serviceName"];
        cell.CategoryDetail.text=[[ArrServiceList objectAtIndex:indexPath.row] valueForKey:@"categoryDetail"];
        
        //product image
        NSData *dataBytes = [[ArrServiceList objectAtIndex:indexPath.row] valueForKey:@"image"];
        cell.ServiceImg.image=[UIImage imageWithData:dataBytes];
        
        cell.ServiceImg.contentMode=UIViewContentModeScaleAspectFill;
        cell.ServiceImg.clipsToBounds = YES;

        if ([[[ArrServiceList objectAtIndex:indexPath.row] valueForKey:@"stepToList"] isEqualToString:@"0  "])
        {
            [cell.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
        }
        else
        {
            [cell.btnEdit setTitle:[[[[ArrServiceList objectAtIndex:indexPath.row] valueForKey:@"stepToList"] substringWithRange:NSMakeRange(0, 2)] stringByAppendingString:@"Step to list"] forState:UIControlStateNormal];
            
        }
        
    }
    else
    {
        cell.ServiceName.text=[[ArrServiceList objectAtIndex:indexPath.row] valueForKey:@"service_name"];
        cell.CategoryDetail.text=[[ArrServiceList objectAtIndex:indexPath.row] valueForKey:@"category_details"];
        
        [cell.ServiceImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[ArrServiceList objectAtIndex:indexPath.row] valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"PlaceholderImg"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
        cell.ServiceImg.contentMode=UIViewContentModeScaleAspectFill;
        cell.ServiceImg.clipsToBounds = YES;
        
        if ([[[ArrServiceList objectAtIndex:indexPath.row] valueForKey:@"step_to_list"] isEqualToString:@"0  "])
        {
            [cell.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
        }
        else
        {
            [cell.btnEdit setTitle:[[[[ArrServiceList objectAtIndex:indexPath.row] valueForKey:@"step_to_list"] substringWithRange:NSMakeRange(0, 2)] stringByAppendingString:@"Step to list"] forState:UIControlStateNormal];
            
        }
        
    }
    return cell;
}
- (IBAction)BackClick:(id)sender
{
    [self POPViewController];
}
-(void)POPViewController
{
    CATransition *Transition=[CATransition animation];
    [Transition setDuration:0.7f];
    [Transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [Transition setType:kCAMediaTimingFunctionEaseOut];
    [[[[self navigationController] view] layer] addAnimation:Transition forKey:nil];
    [[self navigationController] popViewControllerAnimated:NO];
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
        
        ServiceListingViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"add_service_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==3)
    {
        
        ServiceListingViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"msg_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==2)
    {
        
        ServiceListingViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchProductViewControllersid"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==1)
    {
        
        ServiceListingViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Interest_page"];
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
             ServiceListingViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Invite_Friend"];
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         
         else if (sender.tag==8)
         {
             NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
             [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

             ServiceListingViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Login_Page"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==7)
         {
             
             ServiceListingViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"WishlistViewControllersid"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==3)
         {
             
             ServiceListingViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Edit_profile_page"];
             
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
- (IBAction)AddClick:(id)sender
{
    ServiceListingViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"add_service_page"];
    [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
}
@end
