//
//  AddServiceViewController.m
//  FreeWilder
//
//  Created by Rahul Singha Roy on 01/06/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import "AddServiceViewController.h"
#import "Footer.h"
#import "Side_menu.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AddServiceViewController ()<footerdelegate,Slide_menu_delegate>

@end

@implementation AddServiceViewController
@synthesize lblPageTitle,lblPhoto,txtName,txtPrice,btnCategory,btnNext;
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f,[UIScreen mainScreen].bounds.size.width, 35.0f)];
    toolbar.barStyle=UIBarStyleBlackOpaque;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
   
   
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close_textview)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, barButtonItem, nil]];
    _description1.inputAccessoryView = toolbar;
    
    
    /// initializing app footer view
    
    Footer *footer=[[Footer alloc]init];
    footer.frame=CGRectMake(0,0,_footer_base.frame.size.width,_footer_base.frame.size.height);
    footer.Delegate=self;
    [footer TapCheck:4];
    [_footer_base addSubview:footer];
    
    
    /// Getting side from Xiv & creating a black overlay
    
    overlay=[[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    overlay.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:.6];
    overlay.hidden=YES;
    overlay.userInteractionEnabled=NO;
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
   // sidemenu.ProfileImage.contentMode=UIViewContentModeScaleAspectFit;
    sidemenu.hidden=YES;
    sidemenu.SlideDelegate=self;
    [self.view addSubview:sidemenu];
    
    lblPageTitle.text=@"Add a Service";
    lblPhoto.text=@"Add Photos";
    txtName.placeholder=@"Name";
    _description1.text=@"Description";
    txtPrice.placeholder=@"Price";
    [btnCategory setTitle:@"Select Category" forState:UIControlStateNormal];
    [btnNext setTitle:@"Next" forState:UIControlStateNormal];
}
-(void)pushmethod:(UIButton *)sender
{
    
    NSLog(@"Test_mode....%ld",(long)sender.tag);
    
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
        
        AddServiceViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"add_service_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==3)
    {
        
        AddServiceViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"msg_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==2)
    {
        
        AddServiceViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchProductViewControllersid"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==1)
    {
        
        AddServiceViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Interest_page"];
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
         overlay.userInteractionEnabled=NO;
         
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
             AddServiceViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Invite_Friend"];
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
             
             AddServiceViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Login_Page"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==7)
         {
             
             
             AddServiceViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"WishlistViewControllersid"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==3)
         {
             
             AddServiceViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Edit_profile_page"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==5)
         {
             
             AddServiceViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ServiceListingViewControllersid"];
             
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

-(void)close_textview
{
    if (_description1.text.length==0)
    {
        _description1.text=@"Description";
    }
    [_description1 resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
   _description1.text=@"";
}
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    
//    
//    return YES;
//}

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

- (IBAction)NextClick:(id)sender {
}
@end
