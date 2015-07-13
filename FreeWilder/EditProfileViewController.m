//
//  EditProfileViewController.m
//  FreeWilder
//
//  Created by Rahul Singha Roy on 01/06/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Footer.h"
#import "Side_menu.h"
@interface EditProfileViewController ()<footerdelegate>

@end

@implementation EditProfileViewController
@synthesize txtEmail,txtUserName,txtPhone,lblUserName,ProfileImg,mainscroll;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /// initializing app footer view
    if (self.view.frame.size.width==320)
    {
          mainscroll.contentSize=CGSizeMake(0,441);
    }
    else
    {
        mainscroll.contentSize=CGSizeMake(0,500);
    }
  
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
    sidemenu.ProfileImage.contentMode=UIViewContentModeScaleAspectFit;
    sidemenu.hidden=YES;
    sidemenu.SlideDelegate=self;
    [self.view addSubview:sidemenu];

    globalobj=[[FW_JsonClass alloc]init];
    urlobj=[[UrlconnectionObject alloc]init];
    UserId=[prefs valueForKey:@"UserId"];
    //  NSLog(@"userid=%@",UserId);
    
    [self ProfileDetailUrl];
    
}
-(void)ProfileDetailUrl
{
    NSString *urlstring=[NSString stringWithFormat:@"%@verify_app_profile?user_id=%@",App_Domain_Url,[UserId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [globalobj GlobalDict:urlstring Globalstr:@"array" Withblock:^(id result, NSError *error) {
        
        NSLog(@"result=%@",result);
        if([[result valueForKey:@"response"] isEqualToString:@"Success"])
            
        {
            lblUserName.text=[result valueForKey:@"name"];
            txtUserName.text=[result valueForKey:@"name"];
            txtEmail.text=[result valueForKey:@"email"];
         //   NSLog(@"ph=%@",[result valueForKey:@"ph"]);
            if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"ph"]] isEqualToString:@"<null>"])
            {
                
            }
            else
            {
                txtPhone.text=[result valueForKey:@"ph"];
            }
            
        }
        else
        {
            
            UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:[result valueForKey:@"message" ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [loginAlert show];
            
        }
        
        
    }];
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
        
        EditProfileViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"add_service_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==3)
    {
        
        EditProfileViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"msg_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==2)
    {
        
        EditProfileViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"search_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==1)
    {
        
        EditProfileViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Interest_page"];
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
             EditProfileViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Invite_Friend"];
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         
         else if (sender.tag==8)
         {
             NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
             [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
             EditProfileViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Login_Page"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==7)
         {
            
             
             EditProfileViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"WishlistViewControllersid"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==3)
         {
             
             EditProfileViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Edit_profile_page"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==5)
         {
             
             EditProfileViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ServiceListingViewControllersid"];
             
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
  //  self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+20, self.view.frame.size.width, self.view.frame.size.width);
    [textField becomeFirstResponder];
    [UIView animateWithDuration:0.4f
     // delay:0.1f
     // options:UIViewAnimationTransitionNone
                     animations:^{
                         
                         if(textField==txtPhone)
                         {
                             
                             if ([UIScreen mainScreen].bounds.size.width>320)
                             {
                                 [self.mainscroll setContentOffset:CGPointMake(0.0f, 50.0f) animated:YES];
                             }
                             else
                             {
                                 [self.mainscroll setContentOffset:CGPointMake(0.0f, 100.0f) animated:YES];
                             }
                         }
                         else if(textField==txtEmail)
                         {
                             
                             if ([UIScreen mainScreen].bounds.size.width==320)
                             {
                                 [self.mainscroll setContentOffset:CGPointMake(0.0f, 50.0f) animated:YES];
                             }
                        }
                     }
                     completion:^(BOOL finished){
                         
                     }
     ];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.4f
     // delay:0.1f
     // options:UIViewAnimationTransitionNone
                     animations:^{
 
                                [self.mainscroll setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
                         
                        
                     }
                     completion:^(BOOL finished){
                         
                     }
     ];
    return YES;
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

- (IBAction)SaveClick:(id)sender
{
    [self UpdateProfileUrl];
}
-(void)UpdateProfileUrl
{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@app_edit_profile",App_Domain_Url]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * params =[NSString stringWithFormat:@"user_id=%@&name=%@&email=%@&phone_no=%@",[UserId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[txtUserName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[txtEmail.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[txtPhone.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  //  @"user_id=%@&name=%@&email=%@&phone_no=%@",;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                      //     NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                            //   NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            id  result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                             //  NSLog(@"Data = %@",result);
                                                               if([[result valueForKey:@"response"] isEqualToString:@"Success"])
                                                                   
                                                               {
                                                                   UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Account Updated Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                                   [loginAlert show];
                                                                   lblUserName.text=[result valueForKey:@"name"];
                                                                   txtUserName.text=[result valueForKey:@"name"];
                                                                   txtEmail.text=[result valueForKey:@"email"];
                                                                   //   NSLog(@"ph=%@",[result valueForKey:@"ph"]);
                                                                   if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"ph"]] isEqualToString:@"<null>"])
                                                                   {
                                                                       
                                                                   }
                                                                   else
                                                                   {
                                                                       txtPhone.text=[result valueForKey:@"ph"];
                                                                   }
                                                                   
                                                               }
                                                               else
                                                               {
                                                                   
                                                                   UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:[result valueForKey:@"message" ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                                   [loginAlert show];
                                                                   
                                                               }
                                                           }
                                                           
                                                       }];
    [dataTask resume];
     
    /*
   NSDictionary *tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:[UserId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"user_id",[txtUserName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"name",[txtEmail.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"email",[txtPhone.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"phone_no",nil];
      NSLog(@"tempdic=%@",tempDict);
    NSString *urlstring = [NSString stringWithFormat:@"%@app_edit_profile",App_Domain_Url];
    NSLog(@"str=%@",urlstring);
    NSError *localErr;
    
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:(NSDictionary *) tempDict options:NSJSONWritingPrettyPrinted error:&localErr];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
    
    NSString *params = jsonString; //[jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [request setHTTPShouldHandleCookies:NO];
    
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    BOOL net=[urlobj connectedToNetwork];
    if (net==YES) {
        //   [self checkLoader];
      [urlobj globalPost:request typerequest:@"array" withblock:^(id result, NSError *error,BOOL completed) {
            
            NSLog(@"event result----- %@", result);
            //    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            //    dic=[result valueForKey:@"response"];
            
            
            
            
            
        }];
    }
    else{
        
        UIAlertView *aler=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Network Connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aler show];
    }
    */
    /*
    BOOL net=[globalobj connectedToNetwork];
    if (net==YES) {
       
       
       [globalobj globalPost:urlstring Dictionary:tempDict typerequest:@"array" Withblock:^(id result, NSError *error) {
            
            NSLog(@"event result----- %@", result);
            //    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            //    dic=[result valueForKey:@"response"];
            
            
     
            if ([[result valueForKey:@"IsSuccess"] integerValue]==1) {
                
               
                
                UIAlertView *aler=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Your Account Updated Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
               [aler show];
               
            }
            else
            {
                //  [self checkLoader];
              
                
                UIAlertView *aler=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unsucessful...." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [aler show];
            }
     
            
        }];
    }
    else{
        
        
        UIAlertView *aler=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Network Connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aler show];
    }
*/
}
@end
