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
#import <FacebookSDK/FacebookSDK.h>
@interface EditProfileViewController ()<footerdelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

@end

@implementation EditProfileViewController
@synthesize txtEmail,txtUserName,txtPhone,lblUserName,ProfileImg,mainscroll,lblPagetitle,btnSave;
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
 //   sidemenu.ProfileImage.contentMode=UIViewContentModeScaleAspectFit;
    sidemenu.hidden=YES;
    sidemenu.SlideDelegate=self;
    [self.view addSubview:sidemenu];

    globalobj=[[FW_JsonClass alloc]init];
    urlobj=[[UrlconnectionObject alloc]init];
    UserId=[prefs valueForKey:@"UserId"];
    //  NSLog(@"userid=%@",UserId);
    
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    lblPagetitle.text=@"Edit Profile";
    
    //done button on numeric keyboard
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 35.0f)];
    toolbar.barStyle=UIBarStyleDefault;
    //    // Create a flexible space to align buttons to the right
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //    // Create a cancel button to dismiss the keyboard
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resetView)];
    //    // Add buttons to the toolbar
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, barButtonItem, nil]];
    // Set the toolbar as accessory view of an UITextField object
    txtPhone.inputAccessoryView = toolbar;

    
    
    [self ProfileDetailUrl];
    
}
-(void)resetView
{
    [txtPhone resignFirstResponder];
    [UIView animateWithDuration:0.4f
     // delay:0.1f
     // options:UIViewAnimationTransitionNone
                     animations:^{
                         
                         [self.mainscroll setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                     }
     ];
}
-(void)ProfileDetailUrl
{
    NSString *urlstring=[NSString stringWithFormat:@"%@verify_app_profile?user_id=%@",App_Domain_Url,[UserId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    BOOL net=[globalobj connectedToNetwork];
    if (net==YES)
    {
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
            
         
           
           
           ProfileImg.userInteractionEnabled=YES;
                    [ProfileImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[result valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"demo_image"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
            ProfileImg.contentMode=UIViewContentModeScaleAspectFill;
             ProfileImg.clipsToBounds = YES;
             ProfileImg.layer.cornerRadius = ProfileImg.frame.size.width/2;

            
        }
        else
        {
            
            UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:[result valueForKey:@"message" ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [loginAlert show];
            
        }
        
        
    }];
    }
    else{
        
        UIAlertView *aler=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Network Connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aler show];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        lblUserName.text=[prefs valueForKey:@"UserName"];
        txtUserName.text=[prefs valueForKey:@"UserName"];
        ProfileImg.userInteractionEnabled=YES;
        [ProfileImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[prefs valueForKey:@"UserImage"]]] placeholderImage:[UIImage imageNamed:@"demo_image"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
        ProfileImg.contentMode=UIViewContentModeScaleAspectFill;
        ProfileImg.clipsToBounds = YES;
        ProfileImg.layer.cornerRadius = ProfileImg.frame.size.width/2;
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
        
        EditProfileViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchProductViewControllersid"];
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
             
             
             [[FBSession activeSession] closeAndClearTokenInformation];
             
             NSUserDefaults *userData=[NSUserDefaults standardUserDefaults];
             
             [userData removeObjectForKey:@"status"];

             [userData removeObjectForKey:@"logInCheck"];
             
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
                                 [self.mainscroll setContentOffset:CGPointMake(0.0f, 150.0f) animated:YES];
                             }
                             else
                             {
                                 [self.mainscroll setContentOffset:CGPointMake(0.0f, 170.0f) animated:YES];
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
-(NSString *)TarminateWhiteSpace:(NSString *)Str
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [Str stringByTrimmingCharactersInSet:whitespace];
    return trimmed;
}
- (BOOL)validateEmail:(NSString *)emailStr{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if(![emailTest evaluateWithObject:txtEmail.text])
    {
        ////NSLog(@"Invalid email address found");
        //        UIAlertView *objAlert = [[UIAlertView alloc] initWithTitle:@"Mail alert" message:@"Please enter valid Emailid." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close",nil];
        //        [objAlert show];
        
        txtEmail.text=@"";
        txtEmail.placeholder=@"Please enter valid email id";
        
        return FALSE;
    }
    return TRUE;
}

- (IBAction)SaveClick:(id)sender
{
    if ([self TarminateWhiteSpace:txtUserName.text].length==0)
    {
        txtUserName.placeholder=@"Enter Name";
    }
    
    else if (![self validateEmail:[txtEmail text]])
    {
        
    }
    else if ([self TarminateWhiteSpace:txtPhone.text].length==0)
    {
        txtPhone.placeholder=@"Enter Phone Number";
    }
    else
    {
        [self UpdateProfileUrl];
    }
    
        
}
-(void)UpdateProfileUrl
{
    BOOL net=[urlobj connectedToNetwork];
    if (net==YES)
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
                                                               NSLog(@"Data = %@",result);
                                        if([[result valueForKey:@"response"] isEqualToString:@"Success"])
                                                                   
                                                    {
                                                                   UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Account Updated Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                                   [loginAlert show];
                                                                   lblUserName.text=[result valueForKey:@"name"];
                                                                   txtUserName.text=[result valueForKey:@"name"];
                                                                   txtEmail.text=[result valueForKey:@"email"];
                                                                    [[NSUserDefaults standardUserDefaults] setObject:[result valueForKey:@"name"]  forKey:@"UserName"];
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
    }
    else{
       
        UIAlertView *aler=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Network Connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aler show];
    }
   }
- (IBAction)ImageClick:(id)sender
{
    actionsheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    [actionsheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = (id)self;
    picker.allowsEditing = YES;
    
    switch (buttonIndex) {
            
        case 0:
            
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:picker animated:YES completion:NULL];
            
            break;
            
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.navigationController presentViewController:picker animated:YES completion:NULL];
            break;
            
        default:
            break;
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    ProfileImg.image=info[UIImagePickerControllerEditedImage];
    ProfileImg.contentMode=UIViewContentModeScaleAspectFill;
    ProfileImg.clipsToBounds = YES;
    ProfileImg.layer.cornerRadius = ProfileImg.frame.size.width/2;
   
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
}

@end
