//
//  FindInterestsViewController.m
//  FreeWilder
//
//  Created by Rahul Singha Roy on 01/06/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import "FindInterestsViewController.h"
#import "Footer.h"
#import "Side_menu.h"
@interface FindInterestsViewController ()<footerdelegate,Slide_menu_delegate,NSURLConnectionDataDelegate>
{
    NSMutableArray *dataarray;
    NSMutableDictionary *maindic;
    BOOL pos;
}

@end

@implementation FindInterestsViewController
@synthesize lblPageTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataarray=[[NSMutableArray alloc]init];
    
    pos=true;
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
  //  sidemenu.ProfileImage.contentMode=UIViewContentModeScaleAspectFit;
    sidemenu.hidden=YES;
    sidemenu.SlideDelegate=self;
    [self.view addSubview:sidemenu];
    
    lblPageTitle.text=@"Find Your Interests";
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    jsonObj=[[FW_JsonClass alloc]init];
    //json
   // [self getdata];
    [self urlFire];
}
/*
-(void)getdata
{
    
    //json url
    FW_JsonClass *jsonObj=[[FW_JsonClass alloc]init];
    NSString *finddata=[NSString stringWithFormat:@"%@verify_app_category?categorytype=featured",App_Domain_Url];
    [jsonObj GlobalDict:finddata Globalstr:@"array" Withblock:^(id result, NSError *error) {
        
        NSLog(@"----? %@",result);
        
        dataarray=[[NSMutableArray alloc]init];
        dataarray= [result mutableCopy];
        maindic=[[NSMutableDictionary alloc]init];
        maindic=[dataarray valueForKey:@"infoaray"];
        NSLog(@"%@",maindic);
        NSLog(@"data %lu",(unsigned long)maindic.count);
        //button created after data inserted
        [self buttoncreate];
    }];
    
    
}
 */

-(void)urlFire
{
    
    
    //////////////////////////
    
    NSManagedObjectContext *context1=[appDelegate managedObjectContext];
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"CategoryFeatureList"];
    NSMutableArray *fetchrequest=[[context1 executeFetchRequest:request error:nil] mutableCopy];
    NSInteger CoreDataCount=[fetchrequest count];
    NSLog(@"core data count=%ld",(long)CoreDataCount);
    
    
    
    if (CoreDataCount>0)
    {
        localdata=1;
        dataarray=[[NSMutableArray alloc]init];
        // data present in core data so show data from core data
        NSLog(@"data from local db");
      
      
        for (NSManagedObject *obj1 in fetchrequest)
        {
            
            //   NSLog(@"category id1=%@",[obj1 valueForKey:@"categoryId"]);
            
            // datacount++;
            [dataarray addObject:obj1];
            
        }
        maindic=[[NSMutableDictionary alloc]init];
        maindic=[fetchrequest mutableCopy];
   //     NSLog(@"array=%@",jsonResult);
        [self buttoncreate];
        
      
        
       
        
        //check local data and url data same or not
        //fire url
        NSString *urlstring=[NSString stringWithFormat:@"%@verify_app_category?categorytype=featured",App_Domain_Url];
        
        [jsonObj GlobalDict:urlstring Globalstr:@"array" Withblock:^(id result, NSError *error) {
            localdata=1;
            //     NSLog(@"result=%@",result);
            if([[result valueForKey:@"response"] isEqualToString:@"success"])
                
            {
                //           NSOperationQueue *myQueue2 = [[NSOperationQueue alloc] init];
                //           [myQueue2 addOperationWithBlock:^{
                NSInteger urlCount=(int)[[result valueForKey:@"infoaray"] count];
                NSLog(@"core data count=%ld",(long)CoreDataCount);
                NSLog(@"url data count=%ld",(long)urlCount);
                
                // local data and url data same
                if (CoreDataCount==urlCount)
                {
                    //do nothing but if edit or delete enabled then
                    
                    //delete the particular category data from core data
                    NSLog(@"delete the particular category data from core data");
                    NSManagedObjectContext *context3=[appDelegate managedObjectContext];
                    NSFetchRequest *request3=[[NSFetchRequest alloc] initWithEntityName:@"CategoryFeatureList"];
                    NSMutableArray *fetchrequest3=[[context3 executeFetchRequest:request3 error:nil] mutableCopy];
                    for (NSManagedObject *obj3 in fetchrequest3)
                    {
                        
                        [context3 deleteObject:obj3];
                        
                        
                    }
                    [context3 save:&error];
                    
                    // put url data in core data
                    for ( NSDictionary *tempDict1 in  [result valueForKey:@"infoaray"])
                    {
                        NSLog(@"putting data in core data.");
                        NSManagedObjectContext *context=[appDelegate managedObjectContext];
                        NSManagedObject *manageobject=[NSEntityDescription insertNewObjectForEntityForName:@"CategoryFeatureList" inManagedObjectContext:context];
                        
                        [manageobject setValue:[tempDict1 valueForKey:@"id"] forKey:@"categoryId"];
                        [manageobject setValue:[tempDict1 valueForKey:@"category_name"] forKey:@"categoryName"];
                        
                        [appDelegate saveContext];
                    }
                    
                    // data show from core data
                    
                   /*
                     dataarray=[[NSMutableArray alloc]init];
                     NSManagedObjectContext *context5=[appDelegate managedObjectContext];
                     NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"CategoryFeatureList"];
                     NSMutableArray *fetchrequest=[[context5 executeFetchRequest:request error:nil] mutableCopy];
                    
                    maindic=[[NSMutableDictionary alloc]init];
                    maindic=[fetchrequest mutableCopy];
                    
                     for (NSManagedObject *obj1 in fetchrequest)
                     {
                     
                     //   NSLog(@"category id1=%@",[obj1 valueForKey:@"categoryId"]);
                     
                     // datacount++;
                     [dataarray addObject:obj1];
                     
                     }
                     
                     [self buttoncreate];
                     */
                    
                    
                }
                else
                {
                    //delete the particular category data from core data
                    NSLog(@"delete the particular category data from core data");
                    NSManagedObjectContext *context3=[appDelegate managedObjectContext];
                    NSFetchRequest *request3=[[NSFetchRequest alloc] initWithEntityName:@"CategoryFeatureList"];
                    NSMutableArray *fetchrequest3=[[context3 executeFetchRequest:request3 error:nil] mutableCopy];
                    for (NSManagedObject *obj3 in fetchrequest3)
                    {
                        
                        [context3 deleteObject:obj3];
                        
                        
                    }
                    [context3 save:&error];
                    
                    // put url data in core data
                    for ( NSDictionary *tempDict1 in  [result valueForKey:@"infoaray"])
                    {
                        NSLog(@"putting data in core data.");
                        NSManagedObjectContext *context=[appDelegate managedObjectContext];
                        NSManagedObject *manageobject=[NSEntityDescription insertNewObjectForEntityForName:@"CategoryFeatureList" inManagedObjectContext:context];
                        
                        [manageobject setValue:[tempDict1 valueForKey:@"id"] forKey:@"categoryId"];
                        [manageobject setValue:[tempDict1 valueForKey:@"category_name"] forKey:@"categoryName"];
                        
                        [appDelegate saveContext];
                    }
                    
                    // data show from core data
                  /*
                    
                    dataarray=[[NSMutableArray alloc]init];
                    NSManagedObjectContext *context5=[appDelegate managedObjectContext];
                    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"CategoryFeatureList"];
                    NSMutableArray *fetchrequest=[[context5 executeFetchRequest:request error:nil] mutableCopy];
                    
                    maindic=[[NSMutableDictionary alloc]init];
                    maindic=[fetchrequest mutableCopy];
                    
                    for (NSManagedObject *obj1 in fetchrequest)
                    {
                        
                        //   NSLog(@"category id1=%@",[obj1 valueForKey:@"categoryId"]);
                        
                        // datacount++;
                        [dataarray addObject:obj1];
                        
                    }
                    
                    [self buttoncreate];
                   */
                }
                
               
                
                
            }
            
            
            
        }];
        
        
        
    }
    else
    {
        localdata=0;
        // core data empty
        //fire url
        
        NSLog(@"data from url");
        
        NSString *urlstring=[NSString stringWithFormat:@"%@verify_app_category?categorytype=featured",App_Domain_Url];
        
        [jsonObj GlobalDict:urlstring Globalstr:@"array" Withblock:^(id result, NSError *error) {
            
            
            dataarray=[[NSMutableArray alloc]init];
            
            dataarray=[[NSMutableArray alloc]init];
            dataarray= [result mutableCopy];
            maindic=[[NSMutableDictionary alloc]init];
            maindic=[dataarray valueForKey:@"infoaray"];
            
            
            //put data from url to core data in back ground thread
            NSOperationQueue *myQueue11 = [[NSOperationQueue alloc] init];
            [myQueue11 addOperationWithBlock:^{
                
                
                
                for ( NSDictionary *tempDict1 in  [result valueForKey:@"infoaray"])
                {
                    NSLog(@"putting data in core data.");
                    NSManagedObjectContext *context=[appDelegate managedObjectContext];
                    NSManagedObject *manageobject=[NSEntityDescription insertNewObjectForEntityForName:@"CategoryFeatureList" inManagedObjectContext:context];
                    
                    [manageobject setValue:[tempDict1 valueForKey:@"id"] forKey:@"categoryId"];
                    [manageobject setValue:[tempDict1 valueForKey:@"category_name"] forKey:@"categoryName"];
                    
                    [appDelegate saveContext];
                }
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                }];
            }];
            
            [self buttoncreate];
            
           
            
            
        }];
    }
    
    
    
    
    
    /////////////////
    
    
    
    
    
    
    
    
    
    
    
    
    
}
-(void)buttoncreate
{
    CGRect screenBounds=[[UIScreen mainScreen] bounds];
    if(screenBounds.size.height == 667 && screenBounds.size.width == 375)
    {
        int  w=120;
        if ((maindic.count%2)==0)
        {
            NSInteger position=0;
            int y=20;
            int x=20;
            NSLog(@"i am from button%lu",(unsigned long)maindic.count);
            NSInteger loop=maindic.count/2;
            NSLog(@"%ld",(long)loop);
            for (int i=0; i<loop; i++)
            {
                x=30;
                for (int j=0; j<2; j++)
                {
                    if (pos==true) {
                        w=140;
                        pos=false;
                    }
                    else
                    {
                        w=170;
                        pos=true;
                    }
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    if (localdata) {
                        button.tag=[[[dataarray objectAtIndex:position]valueForKey:@"categoryId"] integerValue];
                    }
                    else
                    {
                     button.tag=[[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"id"] integerValue];
                    }
                    [button addTarget:self
                               action:@selector(tap:)
                     forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:[UIColor colorWithRed:(115.0f/255.0) green:(115.0f/255.0) blue:(115.0f/255.0) alpha:3] forState:UIControlStateNormal];
                    [button.titleLabel setFont:[UIFont fontWithName:@"Lato Regular" size:10.0]];
                    button.titleLabel.adjustsFontSizeToFitWidth = YES;
                    if (localdata)
                    {
                        [button setTitle:[[dataarray objectAtIndex:position]valueForKey:@"categoryName"] forState:UIControlStateNormal];
                    }
                    else
                    {
                       [button setTitle:[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"category_name"] forState:UIControlStateNormal];
                    }
                    
                    [button setBackgroundColor:[UIColor whiteColor]];
                    button.layer.cornerRadius=20;
                    [[button layer] setBorderWidth:0.5f];
                    [[button layer] setBorderColor:[UIColor colorWithRed:(171.0f/255.0) green:(171.0f/255.0) blue:(171.0f/255.0) alpha:1].CGColor];
                    button.frame =CGRectMake(x, y, w, 40.0) ;
                    x=x+w+8;
                    [_findscrollview addSubview:button];
                    position++;
                    
                }
                y=y+60;
                if (pos==true)
                {
                    pos=false;
                }
                else
                {
                    pos=true;
                }
                
            }
            NSInteger p=[maindic count];
            [_findscrollview setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, p*30)];
            
        }
        else
        {
            NSInteger position=0;
            int y=20;
            int x=20;
            NSLog(@"i am from button%lu",(unsigned long)maindic.count);
            NSInteger loop=maindic.count/2;
            NSLog(@"%ld",(long)loop);
            for (int i=0; i<loop; i++)
            {
                x=30;
                for (int j=0; j<2; j++)
                {
                    if (pos==true) {
                        w=140;
                        pos=false;
                    }
                    else
                    {
                        w=170;
                        pos=true;
                    }
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    if (localdata) {
                        button.tag=[[[dataarray objectAtIndex:position]valueForKey:@"categoryId"] integerValue];
                    }
                    else
                    {
                        button.tag=[[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"id"] integerValue];
                    }
                    
                    [button addTarget:self
                               action:@selector(tap:)
                     forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:[UIColor colorWithRed:(115.0f/255.0) green:(115.0f/255.0) blue:(115.0f/255.0) alpha:3] forState:UIControlStateNormal];
                    [button.titleLabel setFont:[UIFont fontWithName:@"Lato Regular" size:10.0]];
                    button.titleLabel.adjustsFontSizeToFitWidth = YES;
                    if (localdata) {
                       [button setTitle:[[dataarray objectAtIndex:position]valueForKey:@"categoryName"] forState:UIControlStateNormal];
                    }
                    else
                    {
                       [button setTitle:[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"category_name"] forState:UIControlStateNormal];
                    }
                    
                    [button setBackgroundColor:[UIColor whiteColor]];
                    button.layer.cornerRadius=20;
                    [[button layer] setBorderWidth:0.5f];
                    [[button layer] setBorderColor:[UIColor colorWithRed:(171.0f/255.0) green:(171.0f/255.0) blue:(171.0f/255.0) alpha:1].CGColor];
                    button.frame =CGRectMake(x, y, w, 40.0);
                    x=x+w+8;
                    [_findscrollview addSubview:button];
                    position++;
                    
                     NSLog(@"Position---->%lu",position);
                }
                y=y+55;
                if (pos==true) {
                    pos=false;
                }
                else
                {
                    pos=true;
                }
                
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            NSLog(@"Dataarray count---->%lu",dataarray.count);
            
            NSLog(@"Position======>%lu",position);
            
 //closed
            
            

     //       NSLog(@"------>%@",[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"id"]);
            if (localdata) {
                button.tag=[[[dataarray objectAtIndex:position]valueForKey:@"categoryId"] integerValue];
            }
            else
            {
                button.tag=[[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"id"] integerValue];
            }
            
            [button addTarget:self
                       action:@selector(tap:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor colorWithRed:(115.0f/255.0) green:(115.0f/255.0) blue:(115.0f/255.0) alpha:3] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"Lato Regular" size:10.0]];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            if (localdata) {
                [button setTitle:[[dataarray objectAtIndex:position]valueForKey:@"categoryName"] forState:UIControlStateNormal];
            }
            else
            {
               [button setTitle:[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"category_name"] forState:UIControlStateNormal];
            }

            
            button.layer.cornerRadius=20;
            button.frame =CGRectMake(x-250, y, 160.0, 40.0) ;
            [[button layer] setBorderWidth:0.5f];
            [[button layer] setBorderColor:[UIColor colorWithRed:(171.0f/255.0) green:(171.0f/255.0) blue:(171.0f/255.0) alpha:1].CGColor];
            x=x+160+10;
            [_findscrollview addSubview:button];
            
            
           
            
            NSInteger p=[maindic count];
            [_findscrollview setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, p*30)];
        }
        
    }
    
    else if(screenBounds.size.height == 568 && screenBounds.size.width == 320)
    {
        int  w=120;
        if ((maindic.count%2)==0)
        {
            NSInteger position=0;
            int y=20;
            int x=20;
            NSLog(@"i am from button%lu",(unsigned long)maindic.count);
            NSInteger loop=maindic.count/2;
            NSLog(@"%ld",(long)loop);
            for (int i=0; i<loop; i++)
            {
                x=18;
                for (int j=0; j<2; j++)
                {
                    if (pos==true) {
                        w=130;
                        pos=false;
                    }
                    else
                    {
                        w=150;
                        pos=true;
                    }
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    if (localdata) {
                        button.tag=[[[dataarray objectAtIndex:position]valueForKey:@"categoryId"] integerValue];
                    }
                    else
                    {
                        button.tag=[[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"id"] integerValue];
                    }

                    [button addTarget:self
                               action:@selector(tap:)
                     forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:[UIColor colorWithRed:(115.0f/255.0) green:(115.0f/255.0) blue:(115.0f/255.0) alpha:3] forState:UIControlStateNormal];
                    [button.titleLabel setFont:[UIFont fontWithName:@"Lato Regular" size:10.0]];
                    button.titleLabel.adjustsFontSizeToFitWidth = YES;
                    if (localdata) {
                        [button setTitle:[[dataarray objectAtIndex:position]valueForKey:@"categoryName"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [button setTitle:[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"category_name"] forState:UIControlStateNormal];
                    }
                    [button setBackgroundColor:[UIColor whiteColor]];
                    button.layer.cornerRadius=20;
                    [[button layer] setBorderWidth:0.5f];
                    [[button layer] setBorderColor:[UIColor colorWithRed:(171.0f/255.0) green:(171.0f/255.0) blue:(171.0f/255.0) alpha:1].CGColor];
                    button.frame =CGRectMake(x, y, w, 40.0) ;
                    x=x+w+8;
                    [_findscrollview addSubview:button];
                    position++;
                    
                }
                y=y+48;
                if (pos==true) {
                    pos=false;
                }
                else
                {
                    pos=true;
                }
                
            }
            NSInteger p=[maindic count];
            [_findscrollview setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, p*30)];
            
        }
        else
        {
            NSInteger position=0;
            int y=20;
            int x=20;
            NSLog(@"i am from button%lu",(unsigned long)maindic.count);
            NSInteger loop=maindic.count/2;
            NSLog(@"%ld",(long)loop);
            for (int i=0; i<loop; i++)
            {
                x=18;
                for (int j=0; j<2; j++)
                {
                    if (pos==true) {
                        w=130;
                        pos=false;
                    }
                    else
                    {
                        w=150;
                        pos=true;
                    }
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    if (localdata) {
                        button.tag=[[[dataarray objectAtIndex:position]valueForKey:@"categoryId"] integerValue];
                    }
                    else
                    {
                        button.tag=[[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"id"] integerValue];
                    }
                    [button addTarget:self
                               action:@selector(tap:)
                     forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:[UIColor colorWithRed:(115.0f/255.0) green:(115.0f/255.0) blue:(115.0f/255.0) alpha:3] forState:UIControlStateNormal];
                    [button.titleLabel setFont:[UIFont fontWithName:@"Lato Regular" size:10.0f]];
                    button.titleLabel.adjustsFontSizeToFitWidth = YES;
                    if (localdata) {
                        [button setTitle:[[dataarray objectAtIndex:position]valueForKey:@"categoryName"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [button setTitle:[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"category_name"] forState:UIControlStateNormal];
                    }

                    [button setBackgroundColor:[UIColor whiteColor]];
                    button.layer.cornerRadius=20;
                    [[button layer] setBorderWidth:0.5f];
                    [[button layer] setBorderColor:[UIColor colorWithRed:(171.0f/255.0) green:(171.0f/255.0) blue:(171.0f/255.0) alpha:1].CGColor];
                    button.frame =CGRectMake(x, y, w, 40.0);
                    x=x+w+8;
                    [_findscrollview addSubview:button];
                    position++;
                    
                }
                y=y+48;
                if (pos==true) {
                    pos=false;
                }
                else
                {
                    pos=true;
                }
                
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            if (localdata) {
                button.tag=[[[dataarray objectAtIndex:position]valueForKey:@"categoryId"] integerValue];
            }
            else
            {
                button.tag=[[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"id"] integerValue];
            }
            [button addTarget:self
                       action:@selector(tap:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor colorWithRed:(115.0f/255.0) green:(115.0f/255.0) blue:(115.0f/255.0) alpha:3] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"Lato Regular" size:10.0]];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            if (localdata) {
                [button setTitle:[[dataarray objectAtIndex:position]valueForKey:@"categoryName"] forState:UIControlStateNormal];
            }
            else
            {
                [button setTitle:[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"category_name"] forState:UIControlStateNormal];
            }

            button.layer.cornerRadius=20;
            button.frame =CGRectMake(x-250, y, 160.0, 40.0) ;
            [[button layer] setBorderWidth:0.5f];
            [[button layer] setBorderColor:[UIColor colorWithRed:(171.0f/255.0) green:(171.0f/255.0) blue:(171.0f/255.0) alpha:1].CGColor];
            x=x+160+10;
            [_findscrollview addSubview:button];
            NSInteger p=[maindic count];
            [_findscrollview setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, p*30)];
        }
        
    }
    
    else if(screenBounds.size.height == 736 && screenBounds.size.width == 414)
    {
        int  w=120;
        if ((maindic.count%2)==0)
        {
            NSInteger position=0;
            int y=20;
            int x=20;
            NSLog(@"i am from button%lu",(unsigned long)maindic.count);
            NSInteger loop=maindic.count/2;
            NSLog(@"%ld",(long)loop);
            for (int i=0; i<loop; i++)
            {
                x=30;
                for (int j=0; j<2; j++)
                {
                    if (pos==true) {
                        w=150;
                        pos=false;
                    }
                    else
                    {
                        w=200;
                        pos=true;
                    }
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    if (localdata) {
                        button.tag=[[[dataarray objectAtIndex:position]valueForKey:@"categoryId"] integerValue];
                    }
                    else
                    {
                        button.tag=[[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"id"] integerValue];
                    }
                    [button addTarget:self
                               action:@selector(tap:)
                     forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:[UIColor colorWithRed:(115.0f/255.0) green:(115.0f/255.0) blue:(115.0f/255.0) alpha:3] forState:UIControlStateNormal];
                    [button.titleLabel setFont:[UIFont fontWithName:@"Lato Regular" size:10.0]];
                    button.titleLabel.adjustsFontSizeToFitWidth = YES;
                    if (localdata) {
                        [button setTitle:[[dataarray objectAtIndex:position]valueForKey:@"categoryName"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [button setTitle:[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"category_name"] forState:UIControlStateNormal];
                    }
                    [button setBackgroundColor:[UIColor whiteColor]];
                    button.layer.cornerRadius=20;
                    [[button layer] setBorderWidth:0.5f];
                    [[button layer] setBorderColor:[UIColor colorWithRed:(171.0f/255.0) green:(171.0f/255.0) blue:(171.0f/255.0) alpha:1].CGColor];
                    button.frame =CGRectMake(x, y, w, 40.0) ;
                    x=x+w+8;
                    [_findscrollview addSubview:button];
                    position++;
                    
                }
                y=y+50;
                if (pos==true) {
                    pos=false;
                }
                else
                {
                    pos=true;
                }
                
            }
            NSInteger p=[maindic count];
            [_findscrollview setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, p*30)];
            
        }
        else
        {
            NSInteger position=0;
            int y=20;
            int x=20;
            NSLog(@"i am from button%lu",(unsigned long)maindic.count);
            NSInteger loop=maindic.count/2;
            NSLog(@"%ld",(long)loop);
            for (int i=0; i<loop; i++)
            {
                x=30;
                for (int j=0; j<2; j++)
                {
                    if (pos==true) {
                        w=150;
                        pos=false;
                    }
                    else
                    {
                        w=200;
                        pos=true;
                    }
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    if (localdata) {
                        button.tag=[[[dataarray objectAtIndex:position]valueForKey:@"categoryId"] integerValue];
                    }
                    else
                    {
                        button.tag=[[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"id"] integerValue];
                    }

                    [button addTarget:self
                               action:@selector(tap:)
                     forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:[UIColor colorWithRed:(115.0f/255.0) green:(115.0f/255.0) blue:(115.0f/255.0) alpha:3] forState:UIControlStateNormal];
                    [button.titleLabel setFont:[UIFont fontWithName:@"Lato Regular" size:10.0]];
                    button.titleLabel.adjustsFontSizeToFitWidth = YES;
                    if (localdata) {
                        [button setTitle:[[dataarray objectAtIndex:position]valueForKey:@"categoryName"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [button setTitle:[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"category_name"] forState:UIControlStateNormal];
                    }
                    [button setBackgroundColor:[UIColor whiteColor]];
                    button.layer.cornerRadius=20;
                    [[button layer] setBorderWidth:0.5f];
                    [[button layer] setBorderColor:[UIColor colorWithRed:(171.0f/255.0) green:(171.0f/255.0) blue:(171.0f/255.0) alpha:1].CGColor];
                    button.frame =CGRectMake(x, y, w, 37.0) ;
                    x=x+w+8;
                    [_findscrollview addSubview:button];
                    position++;
                    
                }
                y=y+50;
                if (pos==true) {
                    pos=false;
                }
                else
                {
                    pos=true;
                }
                
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            if (localdata) {
                button.tag=[[[dataarray objectAtIndex:position]valueForKey:@"categoryId"] integerValue];
            }
            else
            {
                button.tag=[[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"id"] integerValue];
            }
            [button addTarget:self
                       action:@selector(tap:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor colorWithRed:(115.0f/255.0) green:(115.0f/255.0) blue:(115.0f/255.0) alpha:3] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"Lato Regular" size:10.0]];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            if (localdata) {
                [button setTitle:[[dataarray objectAtIndex:position]valueForKey:@"categoryName"] forState:UIControlStateNormal];
            }
            else
            {
                [button setTitle:[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"category_name"] forState:UIControlStateNormal];
            }
            button.layer.cornerRadius=20;
            button.frame =CGRectMake(x-270, y, 160.0, 40.0) ;
            [[button layer] setBorderWidth:0.5f];
            [[button layer] setBorderColor:[UIColor colorWithRed:(171.0f/255.0) green:(171.0f/255.0) blue:(171.0f/255.0) alpha:1].CGColor];
            x=x+160+10;
            [_findscrollview addSubview:button];
            NSInteger p=[maindic count];
            [_findscrollview setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, p*30)];
        }
        
    }
    else if(screenBounds.size.height == 480 && screenBounds.size.width == 320)
    {
        
        int  w=120;
        if ((maindic.count%2)==0)
        {
            NSInteger position=0;
            int y=20;
            int x=18;
            NSLog(@"i am from button%lu",(unsigned long)maindic.count);
            NSInteger loop=maindic.count/2;
            NSLog(@"%ld",(long)loop);
            for (int i=0; i<loop; i++)
            {
                x=18;
                for (int j=0; j<2; j++)
                {
                    if (pos==true) {
                        w=130;
                        pos=false;
                    }
                    else
                    {
                        w=150;
                        pos=true;
                    }
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    if (localdata) {
                        button.tag=[[[dataarray objectAtIndex:position]valueForKey:@"categoryId"] integerValue];
                    }
                    else
                    {
                        button.tag=[[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"id"] integerValue];
                    }
                    [button addTarget:self
                               action:@selector(tap:)
                     forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:[UIColor colorWithRed:(115.0f/255.0) green:(115.0f/255.0) blue:(115.0f/255.0) alpha:3] forState:UIControlStateNormal];
                    [button.titleLabel setFont:[UIFont fontWithName:@"Lato Regular" size:10.0]];
                    button.titleLabel.adjustsFontSizeToFitWidth = YES;
                    if (localdata) {
                        [button setTitle:[[dataarray objectAtIndex:position]valueForKey:@"categoryName"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [button setTitle:[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"category_name"] forState:UIControlStateNormal];
                    }
                    [button setBackgroundColor:[UIColor whiteColor]];
                    button.layer.cornerRadius=20;
                    [[button layer] setBorderWidth:0.5f];
                    [[button layer] setBorderColor:[UIColor colorWithRed:(171.0f/255.0) green:(171.0f/255.0) blue:(171.0f/255.0) alpha:1].CGColor];
                    button.frame =CGRectMake(x, y, w, 40.0) ;
                    x=x+w+8;
                    [_findscrollview addSubview:button];
                    position++;
                    
                }
                y=y+48;
                if (pos==true) {
                    pos=false;
                }
                else
                {
                    pos=true;
                }
                
            }
            NSInteger p=[maindic count];
            [_findscrollview setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, p*30)];
            
        }
        else
        {
            NSInteger position=0;
            int y=20;
            int x=20;
            NSLog(@"i am from button%lu",(unsigned long)maindic.count);
            NSInteger loop=maindic.count/2;
            NSLog(@"%ld",(long)loop);
            for (int i=0; i<loop; i++)
            {
                x=18;
                for (int j=0; j<2; j++)
                {
                    if (pos==true) {
                        w=130;
                        pos=false;
                    }
                    else
                    {
                        w=150;
                        pos=true;
                    }
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    if (localdata) {
                        button.tag=[[[dataarray objectAtIndex:position]valueForKey:@"categoryId"] integerValue];
                    }
                    else
                    {
                        button.tag=[[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"id"] integerValue];
                    }
                    [button addTarget:self
                               action:@selector(tap:)
                     forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:[UIColor colorWithRed:(115.0f/255.0) green:(115.0f/255.0) blue:(115.0f/255.0) alpha:3] forState:UIControlStateNormal];
                    [button.titleLabel setFont:[UIFont fontWithName:@"Lato Regular" size:10.0f]];
                    button.titleLabel.adjustsFontSizeToFitWidth = YES;
                    if (localdata) {
                        [button setTitle:[[dataarray objectAtIndex:position]valueForKey:@"categoryName"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [button setTitle:[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"category_name"] forState:UIControlStateNormal];
                    }
                    [button setBackgroundColor:[UIColor whiteColor]];
                    button.layer.cornerRadius=20;
                    [[button layer] setBorderWidth:0.5f];
                    [[button layer] setBorderColor:[UIColor colorWithRed:(171.0f/255.0) green:(171.0f/255.0) blue:(171.0f/255.0) alpha:1].CGColor];
                    button.frame =CGRectMake(x, y, w, 40.0);
                    x=x+w+8;
                    [_findscrollview addSubview:button];
                    position++;
                    
                }
                y=y+48;
                if (pos==true) {
                    pos=false;
                }
                else
                {
                    pos=true;
                }
                
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            if (localdata) {
                button.tag=[[[dataarray objectAtIndex:position]valueForKey:@"categoryId"] integerValue];
            }
            else
            {
                button.tag=[[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"id"] integerValue];
            }
            [button addTarget:self
                       action:@selector(tap:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor colorWithRed:(115.0f/255.0) green:(115.0f/255.0) blue:(115.0f/255.0) alpha:3] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"Lato Regular" size:10.0]];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            if (localdata) {
                [button setTitle:[[dataarray objectAtIndex:position]valueForKey:@"categoryName"] forState:UIControlStateNormal];
            }
            else
            {
                [button setTitle:[[[dataarray valueForKey:@"infoaray"] objectAtIndex:position]valueForKey:@"category_name"] forState:UIControlStateNormal];
            }
            button.layer.cornerRadius=20;
            button.frame =CGRectMake(x-250, y, 160.0, 40.0) ;
            [[button layer] setBorderWidth:0.5f];
            [[button layer] setBorderColor:[UIColor colorWithRed:(171.0f/255.0) green:(171.0f/255.0) blue:(171.0f/255.0) alpha:1].CGColor];
            x=x+160+10;
            [_findscrollview addSubview:button];
            NSInteger p=[maindic count];
            [_findscrollview setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, p*30)];
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
}
-(void)tap:(id)sender
{
    UIButton *tapbutton=(UIButton *)(id)sender;
    tapbutton.selected=YES;
    
    NSLog(@"Tapped button tag....%ld",tapbutton.tag);
    
    /*
    if (tapbutton.tag==1) {
        tapbutton.tag=0;
    }
    else
    {
        tapbutton.tag=1;
    }
     */
    if (tapbutton.selected==YES)
    {
        [tapbutton setBackgroundColor:[UIColor colorWithRed:(0.0f/255.0) green:(189.0f/255.0) blue:(138.0f/255.0) alpha:1]];
        tapbutton.tintColor=[UIColor colorWithRed:(0.0f/255.0) green:(189.0f/255.0) blue:(138.0f/255.0) alpha:1];
        [tapbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    else
    {
        [tapbutton setTitleColor:[UIColor colorWithRed:(115.0f/255.0) green:(115.0f/255.0) blue:(115.0f/255.0) alpha:3] forState:UIControlStateNormal];
        [[tapbutton layer] setBorderWidth:0.5f];
        [[tapbutton layer] setBorderColor:[UIColor colorWithRed:(171.0f/255.0) green:(171.0f/255.0) blue:(171.0f/255.0) alpha:1].CGColor];
        [tapbutton setBackgroundColor:[UIColor whiteColor]];
    }
  //  tapbutton.tintColor=[UIColor clearColor];
    ProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Product_Page"];
    obj.CategoryId=[NSString stringWithFormat:@"%ld",(long)tapbutton.tag];
    [self.navigationController pushViewController:obj animated:YES];

    
}




-(void)pushmethod:(UIButton *)sender
{
    
    NSLog(@"Button tag....> %ld",sender.tag);
    
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
        
        FindInterestsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"add_service_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==3)
    {
        
        FindInterestsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"msg_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==2)
    {
        
        FindInterestsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchProductViewControllersid"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    /*
    else if (sender.tag==1)
    {
        
        FindInterestsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Dashboard"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
     */
    
    
    
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
             FindInterestsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Invite_Friend"];
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
             
             FindInterestsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Login_Page"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==7)
         {
            
             
             FindInterestsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"WishlistViewControllersid"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==3)
         {
             
             FindInterestsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Edit_profile_page"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==5)
         {
             
             FindInterestsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ServiceListingViewControllersid"];
             
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
