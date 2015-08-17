

#import "ProductViewController.h"
#import "Productcell.h"
#import "Footer.h"
#import "Side_menu.h"
#import "UIImageView+WebCache.h"
#import "ProductDetailsViewController.h"
@interface ProductViewController ()<footerdelegate,Slide_menu_delegate>{
    
    NSString *priceSign;
    
}

@end

@implementation ProductViewController
@synthesize CategoryId,lblCategoryName,ProductListingTable,lblPageTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// initializing app footer view
    
    Footer *footer=[[Footer alloc]init];
    footer.frame=CGRectMake(0,0,_footer_base.frame.size.width,_footer_base.frame.size.height);
    footer.Delegate=self;
    [_footer_base addSubview:footer];
    
    
    /// Getting side from Xib & creating a black overlay
    
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
  //  sidemenu.ProfileImage.contentMode=UIViewContentModeScaleAspectFit;
    sidemenu.hidden=YES;
    sidemenu.SlideDelegate=self;
    [self.view addSubview:sidemenu];
    
    NSLog(@"category id=%@",CategoryId);
    globalobj=[[FW_JsonClass alloc]init];
    ArrProductList=[[NSMutableArray alloc] init];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    lblPageTitle.text=@"Product Listing";
    
    [self ProductDetailUrl];
    
}
-(void)ProductDetailUrl
{
   
    NSManagedObjectContext *context1=[appDelegate managedObjectContext];
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"ProductList"];
    NSMutableArray *fetchrequest=[[context1 executeFetchRequest:request error:nil] mutableCopy];
    NSInteger CoreDataCount=[fetchrequest count];
    NSLog(@"core data count=%ld",(long)CoreDataCount);
    data=0;
    
     //if data for this category present in core data or not
    for (NSManagedObject *obj1 in fetchrequest)
    {
    
      //  NSLog(@"category=%@",[obj1 valueForKey:@"categoryId"]);
        if ([[obj1 valueForKey:@"categoryId"] isEqualToString:CategoryId])
        {
            data=1;
          //  NSLog(@"data present");
            break;
        }
    }
    
   
    if (data)
    {
        
        [ArrProductList removeAllObjects];
        // data present in core data so show data from core data
        NSLog(@"data from local db");

        for (NSManagedObject *obj1 in fetchrequest)
        {
            
         //   NSLog(@"category id1=%@",[obj1 valueForKey:@"categoryId"]);
            if ([[obj1 valueForKey:@"categoryId"] isEqualToString:CategoryId])
            {
               // datacount++;
                [ArrProductList addObject:obj1];
                lblCategoryName.text=[[ArrProductList objectAtIndex:0] valueForKey:@"categoryname"];
            }
        }
        
    //    NSLog(@"arra-- %@", ArrProductList);
        
     //   NSLog(@"arr count=%lu",(unsigned long)[ArrProductList count]);
        [ProductListingTable reloadData];
        
        
        //check local data and url data same or not
        //fire url
        
       
            
            
        NSString *urlstring=[NSString stringWithFormat:@"%@app_product_details_cat?catid=%@",App_Domain_Url,[CategoryId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
                 NSLog(@"result=%@",[result objectForKey:@"details"]);
                for ( NSDictionary *tempDict1 in  [result objectForKey:@"details"])
                {
                    urldatacount++;
                    [tempArr addObject:tempDict1];
                    
                }
                NSLog(@"category data count=%ld",(long)ArrProductList.count);
                NSLog(@"url data count=%ld",(long)tempArr.count);
                // local data and url data same
                if (ArrProductList.count==tempArr.count)
                {
                    //do nothing, but as edit is enabled so .....
                    
                    //delete the particular category data from core data
                    
                    NSOperationQueue *myQueue22 = [[NSOperationQueue alloc] init];
                    [myQueue22 addOperationWithBlock:^{
                    NSLog(@"delete the particular category data from core data");
                    NSManagedObjectContext *context3=[appDelegate managedObjectContext];
                    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"ProductList" inManagedObjectContext:context3];
                    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
                    [fetch setEntity:productEntity];
                    NSPredicate *p=[NSPredicate predicateWithFormat:@"categoryId == %@", CategoryId];
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
                    for ( NSDictionary *tempDict1 in  [result objectForKey:@"details"])
                    {
                        NSLog(@"putting data in core data.");
                        NSManagedObjectContext *context=[appDelegate managedObjectContext];
                        NSManagedObject *manageobject=[NSEntityDescription insertNewObjectForEntityForName:@"ProductList" inManagedObjectContext:context];
                        NSLog(@"cat id=%@",CategoryId);
                        [manageobject setValue:CategoryId forKey:@"categoryId"];
                        [manageobject setValue:[tempDict1 valueForKey:@"category_name"] forKey:@"categoryname"];
                        [manageobject setValue:[tempDict1 valueForKey:@"date"] forKey:@"date"];
                        [manageobject setValue:[tempDict1 valueForKey:@"description"] forKey:@"desp"];
                        [manageobject setValue:[tempDict1 valueForKey:@"start_time"] forKey:@"start_time"];
                        [manageobject setValue:[tempDict1 valueForKey:@"close_time"] forKey:@"end_time"];
                        [manageobject setValue:[tempDict1 valueForKey:@"price"] forKey:@"price"];
                        [manageobject setValue:@"1" forKey:@"productid"];
                        [manageobject setValue:[tempDict1 valueForKey:@"description"] forKey:@"desp"];
                        [manageobject setValue:[tempDict1 valueForKey:@"name"] forKey:@"productname"];
                        [manageobject setValue:[tempDict1 valueForKey:@"ratings"] forKey:@"rating"];
                        [manageobject setValue:[tempDict1 valueForKey:@"price"] forKey:@"price"];
                        [manageobject setValue:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[tempDict1 valueForKey:@"product_image"]]]] forKey:@"productimage"];
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
                        
                        [manageobject setValue:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[tempDict1 valueForKey:@"user_image"]]]] forKey:@"userimage"];
                        [appDelegate saveContext];
                    }
                    
                    
                    // data show from core data
                    [ArrProductList removeAllObjects];
                    NSManagedObjectContext *context5=[appDelegate managedObjectContext];
                    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"ProductList"];
                    NSMutableArray *fetchrequest=[[context5 executeFetchRequest:request error:nil] mutableCopy];
                    for (NSManagedObject *obj1 in fetchrequest)
                    {
                        
                        
                        if ([[obj1 valueForKey:@"categoryId"] isEqualToString:CategoryId])
                        {
                            
                            [ArrProductList addObject:obj1];
                            lblCategoryName.text=[[ArrProductList objectAtIndex:0] valueForKey:@"categoryname"];
                        }
                    }
                   
                    [ProductListingTable reloadData];
                    
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        }];
                    }];
                    
                    
                    
                    
                }
                else
                {
                    //delete the particular category data from core data
                    
                    NSOperationQueue *myQueue22 = [[NSOperationQueue alloc] init];
                    [myQueue22 addOperationWithBlock:^{
                        
                        NSLog(@"delete the particular category data from core data");
                        NSManagedObjectContext *context3=[appDelegate managedObjectContext];
                        NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"ProductList" inManagedObjectContext:context3];
                        NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
                        [fetch setEntity:productEntity];
                        NSPredicate *p=[NSPredicate predicateWithFormat:@"categoryId == %@", CategoryId];
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
                        for ( NSDictionary *tempDict1 in  [result objectForKey:@"details"])
                        {
                            NSLog(@"putting data in core data.");
                            NSManagedObjectContext *context=[appDelegate managedObjectContext];
                            NSManagedObject *manageobject=[NSEntityDescription insertNewObjectForEntityForName:@"ProductList" inManagedObjectContext:context];
                            NSLog(@"cat id=%@",CategoryId);
                            [manageobject setValue:CategoryId forKey:@"categoryId"];
                            [manageobject setValue:[tempDict1 valueForKey:@"category_name"] forKey:@"categoryname"];
                            [manageobject setValue:[tempDict1 valueForKey:@"date"] forKey:@"date"];
                            [manageobject setValue:[tempDict1 valueForKey:@"description"] forKey:@"desp"];
                            [manageobject setValue:[tempDict1 valueForKey:@"start_time"] forKey:@"start_time"];
                            [manageobject setValue:[tempDict1 valueForKey:@"close_time"] forKey:@"end_time"];
                            [manageobject setValue:[tempDict1 valueForKey:@"price"] forKey:@"price"];
                            [manageobject setValue:@"1" forKey:@"productid"];
                            [manageobject setValue:[tempDict1 valueForKey:@"description"] forKey:@"desp"];
                            [manageobject setValue:[tempDict1 valueForKey:@"name"] forKey:@"productname"];
                            [manageobject setValue:[tempDict1 valueForKey:@"ratings"] forKey:@"rating"];
                            [manageobject setValue:[tempDict1 valueForKey:@"price"] forKey:@"price"];
                            [manageobject setValue:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[tempDict1 valueForKey:@"product_image"]]]] forKey:@"productimage"];
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
                            
                            [manageobject setValue:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[tempDict1 valueForKey:@"user_image"]]]] forKey:@"userimage"];
                            [appDelegate saveContext];
                        }
                        
                        
                        // data show from core data
                        [ArrProductList removeAllObjects];
                        NSManagedObjectContext *context5=[appDelegate managedObjectContext];
                        NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"ProductList"];
                        NSMutableArray *fetchrequest=[[context5 executeFetchRequest:request error:nil] mutableCopy];
                        for (NSManagedObject *obj1 in fetchrequest)
                        {
                            
                            
                            if ([[obj1 valueForKey:@"categoryId"] isEqualToString:CategoryId])
                            {
                                
                                [ArrProductList addObject:obj1];
                                lblCategoryName.text=[[ArrProductList objectAtIndex:0] valueForKey:@"categoryname"];
                            }
                        }
                        
                        [ProductListingTable reloadData];
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        }];
                    }];
                    
                    
                   
                    
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
        [ArrProductList removeAllObjects];
        NSLog(@"data from url");
        
        NSString *urlstring=[NSString stringWithFormat:@"%@app_product_details_cat?catid=%@",App_Domain_Url,[CategoryId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"str=%@",urlstring);
        [globalobj GlobalDict:urlstring Globalstr:@"array" Withblock:^(id result, NSError *error) {
            
            //   NSLog(@"result=%@",result);
            if([[result valueForKey:@"response"] isEqualToString:@"success"])
                
            {
                
             NSLog(@"result=%@",[result valueForKey:@"details"]);
                
                for ( NSDictionary *tempDict1 in  [result objectForKey:@"details"])
                {
                    [ArrProductList addObject:tempDict1];
                    
                }
                lblCategoryName.text=[[ArrProductList objectAtIndex:0] valueForKey:@"category_name"];
                
                
                [ProductListingTable reloadData];
                
                
                //put data from url to core data in back ground thread
                NSOperationQueue *myQueue11 = [[NSOperationQueue alloc] init];
                [myQueue11 addOperationWithBlock:^{
                    
                    
                    
                    for ( NSDictionary *tempDict1 in  [result objectForKey:@"details"])
                    {
                        NSLog(@"putting image data in core data.");
                        NSManagedObjectContext *context=[appDelegate managedObjectContext];
                        NSManagedObject *manageobject=[NSEntityDescription insertNewObjectForEntityForName:@"ProductList" inManagedObjectContext:context];
                        NSLog(@"cat id=%@",CategoryId);
                        [manageobject setValue:CategoryId forKey:@"categoryId"];
                        [manageobject setValue:[tempDict1 valueForKey:@"category_name"] forKey:@"categoryname"];
                         [manageobject setValue:[tempDict1 valueForKey:@"date"] forKey:@"date"];
                         [manageobject setValue:[tempDict1 valueForKey:@"description"] forKey:@"desp"];
                         [manageobject setValue:[tempDict1 valueForKey:@"start_time"] forKey:@"start_time"];
                         [manageobject setValue:[tempDict1 valueForKey:@"close_time"] forKey:@"end_time"];
                         [manageobject setValue:[tempDict1 valueForKey:@"price"] forKey:@"price"];
                        [manageobject setValue:@"1" forKey:@"productid"];
                        [manageobject setValue:[tempDict1 valueForKey:@"description"] forKey:@"desp"];
                        [manageobject setValue:[tempDict1 valueForKey:@"name"] forKey:@"productname"];
                        [manageobject setValue:[tempDict1 valueForKey:@"ratings"] forKey:@"rating"];
                        [manageobject setValue:[tempDict1 valueForKey:@"price"] forKey:@"price"];
                        [manageobject setValue:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[tempDict1 valueForKey:@"product_image"]]]] forKey:@"productimage"];
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
                        
                        [manageobject setValue:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[tempDict1 valueForKey:@"user_image"]]]] forKey:@"userimage"];
                        [appDelegate saveContext];
                    }
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    }];
                }];
            }
            else
            {
                lblCategoryName.text=@"No Product Found";
                //  UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:[result valueForKey:@"message" ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //  [loginAlert show];
                
            }
            
            
        }];
    }
    
}
-(void)checkLoader
{
    
    if([self.view.subviews containsObject:loader_shadow_View])
    {
        
        [loader_shadow_View removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
    }
    else
    {
       loader_shadow_View = [[UIView alloc] initWithFrame:self.view.frame];
     //   loader_shadow_View = [[UIView alloc] initWithFrame:ProductListingTable.frame];
        [loader_shadow_View setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.56f]];
        [loader_shadow_View setUserInteractionEnabled:NO];
        [[loader_shadow_View layer] setZPosition:2];
        [self.view setUserInteractionEnabled:NO];
        UIActivityIndicatorView *loader =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [loader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
        
        [loader startAnimating];
        
        
        [loader_shadow_View addSubview:loader];
        [self.view addSubview:loader_shadow_View];
    }
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
        
        ProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"add_service_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==3)
    {
        
        ProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"msg_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==2)
    {
        
        ProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchProductViewControllersid"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==1)
    {
        
        ProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Interest_page"];
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
             ProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Invite_Friend"];
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
             
             ProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Login_Page"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==7)
         {
            
             
             ProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"WishlistViewControllersid"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==3)
         {
             
             ProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Edit_profile_page"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==5)
         {
             
             ProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ServiceListingViewControllersid"];
             
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    ProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Product_details"];
//    
//    [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
    
    //-----------PK----------//
    
    
    ProductDetailsViewController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"Product_details"];
    
    if (data) {
        
        nav.boolString = @"coreData";
        
        NSString *price=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"];
        NSInteger len=price.length;
        NSString *finalPrice = [priceSign stringByAppendingString:[[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"] substringWithRange:NSMakeRange(4, len-4)]];
        
        
        nav.detailsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           [[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"productname"], @"productname",
                           [[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"desp"], @"desp",
                           [[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"productimage"], @"productimage",
                           finalPrice, @"price",
                           [[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"userimage"], @"userimage",
                           [[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"date"], @"date",nil];
        
        NSLog(@"PRO IMAGEEEEEEe-=-=-=-IF=-=-=-=-=-=-=-> %@",[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"userimage"]);
        
    }else{
        
        NSString *price=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"];
        NSInteger len=price.length;
        NSString *finalPrice = [priceSign stringByAppendingString:[[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"] substringWithRange:NSMakeRange(4, len-4)]];
        
        nav.detailsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           [[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"name"], @"productname",
                           [[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"description"], @"desp",
                           [[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"product_image"], @"productimage",
                           finalPrice, @"price",
                           [[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"user_image"], @"userimage",
                           [[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"date"], @"date",nil];
        
        NSLog(@"PRO IMAGEEEEEEe-=-=-=-ESLE=-=-=-=-=-=-=-> %@",[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"user_image"]);
        
    }
    [self.navigationController pushViewController:nav animated:NO];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 290;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //  NSLog(@"arr count1=%lu",(unsigned long)[ArrProductList count]);
    return [ArrProductList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Productcell *cell=(Productcell *)[tableView dequeueReusableCellWithIdentifier:@"productcell"];
    if (data)
    {
        
        //showing data from core data
        cell.lblProductName.text=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"productname"];
        cell.lblProductDesc.text=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"desp"];
        
        //product image
        NSData *dataBytes = [[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"productimage"];
        cell.ProductImage.image=[UIImage imageWithData:dataBytes];
        
//        cell.ProductImage.contentMode=UIViewContentModeScaleAspectFill;
        cell.ProductImage.clipsToBounds = YES;

        
        //product cost
        
        if ([[[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"] substringToIndex:3] isEqualToString:@"EUR"])
        {
            priceSign=@"€";
            // NSLog(@"price=%@",priceSign);
        }
        else if ([[[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"] substringToIndex:3] isEqualToString:@"INR"])
        {
            priceSign=@"₹";
            //  NSLog(@"price=%@",priceSign);
        }
        else if ([[[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"] substringToIndex:3] isEqualToString:@"USD"])
        {
            priceSign=@"$";
            // NSLog(@"price=%@",priceSign);
        }
        else if ([[[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"] substringToIndex:3] isEqualToString:@"PLN"])
        {
            priceSign=@"zł";
            // NSLog(@"price=%@",priceSign);
        }
        NSString *price=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"];
        NSInteger len=price.length;
        cell.lblProductCost.text=[priceSign stringByAppendingString:[[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"] substringWithRange:NSMakeRange(4, len-4)]];
        
        //user image
        cell.UserImage.layer.cornerRadius = cell.UserImage.frame.size.width/2;
        cell.UserImage.clipsToBounds = YES;
        cell.UserImage.userInteractionEnabled=YES;
        cell.UserImage.layer.borderColor=[UIColor whiteColor].CGColor;
        cell.UserImage.layer.borderWidth=1.5;
        cell.UserImage.contentMode=UIViewContentModeScaleAspectFill;
        
        NSData *dataBytes1 = [[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"userimage"];
        cell.UserImage.image=[UIImage imageWithData:dataBytes1];
        if (cell.UserImage.image==nil)
        {
          //   NSLog(@"data byte=%@",cell.UserImage.image);
            cell.UserImage.image=[UIImage imageNamed:@"Profile_image_placeholder"];
        }
        
       
     //   Profile_image_placeholder
      //  [cell.UserImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"user_image"]]] placeholderImage:[UIImage imageNamed:@"Profile_image_placeholder"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
        
        
        /*
        cell.lblDate.text=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"date"];
        if ([[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"start_time"] isEqualToString:@""])
        {
            cell.lblStartTime.hidden=YES;
        }
        else
        {
            cell.lblStartTime.hidden=NO;
            cell.lblStartTime.text=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"start_time"];
        }
        
        cell.lblDate.text=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"date"];
        if ([[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"end_time"] isEqualToString:@""])
        {
            cell.lblEndTime.hidden=YES;
        }
        else
        {
            cell.lblEndTime.hidden=NO;
            cell.lblEndTime.text=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"end_time"];
        }
         */
        cell.lblDate.text=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"date"];
    }
    else
    {
   cell.lblProductName.text=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.lblProductDesc.text=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"description"];
   
   [cell.ProductImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"product_image"]]] placeholderImage:[UIImage imageNamed:@"PlaceholderImg"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
//    cell.ProductImage.contentMode=UIViewContentModeScaleAspectFill;
     //    cell.ProductImage.clipsToBounds = YES;
    
    //product cost
    
    if ([[[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"] substringToIndex:3] isEqualToString:@"EUR"])
    {
        priceSign=@"€";
       // NSLog(@"price=%@",priceSign);
    }
    else if ([[[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"] substringToIndex:3] isEqualToString:@"INR"])
    {
        priceSign=@"₹";
      //  NSLog(@"price=%@",priceSign);
    }
    else if ([[[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"] substringToIndex:3] isEqualToString:@"USD"])
    {
        priceSign=@"$";
       // NSLog(@"price=%@",priceSign);
    }
    else if ([[[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"] substringToIndex:3] isEqualToString:@"PLN"])
    {
        priceSign=@"zł";
        // NSLog(@"price=%@",priceSign);
    }
    NSString *price=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"];
    NSInteger len=price.length;
    cell.lblProductCost.text=[priceSign stringByAppendingString:[[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"price"] substringWithRange:NSMakeRange(4, len-4)]];
    
    //user image
    cell.UserImage.layer.cornerRadius = cell.UserImage.frame.size.width/2;
    cell.UserImage.clipsToBounds = YES;
    cell.UserImage.userInteractionEnabled=YES;
    cell.UserImage.layer.borderColor=[UIColor whiteColor].CGColor;
    cell.UserImage.layer.borderWidth=1.5;
    cell.UserImage.contentMode=UIViewContentModeScaleAspectFill;
    [cell.UserImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"user_image"]]] placeholderImage:[UIImage imageNamed:@"Profile_image_placeholder"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
    
    cell.lblDate.text=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"date"];
    if ([[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"start_time"] isEqualToString:@""])
    {
        cell.lblStartTime.hidden=YES;
    }
    else
    {
        cell.lblStartTime.hidden=NO;
        cell.lblStartTime.text=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"start_time"];
    }
    
    cell.lblDate.text=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"date"];
    if ([[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"close_time"] isEqualToString:@""])
    {
        cell.lblEndTime.hidden=YES;
    }
    else
    {
        cell.lblEndTime.hidden=NO;
        cell.lblEndTime.text=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"close_time"];
    }
    cell.lblDate.text=[[ArrProductList objectAtIndex:indexPath.row] valueForKey:@"date"];
    }
    return cell;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *headerstr=@"Car & Motorcycle";
//    return headerstr;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 44.0f;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    ProductHeadercell *headercell=(ProductHeadercell *)[tableView dequeueReusableCellWithIdentifier:@"productheadercell"];
//    return headercell;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back_button:(id)sender
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
@end
