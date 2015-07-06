//
//  ViewController.m
//  FreeWilder
//
//  Created by Rahul Singha Roy on 27/05/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate,UIAlertViewDelegate>


{

    FW_JsonClass *globalobj;

}


@property (strong, nonatomic) IBOutlet UITextField *email;


@property (strong, nonatomic) IBOutlet UITextField *password;

@property (strong, nonatomic)NSMutableArray *jsonResult;

@end

@implementation ViewController

@synthesize email,password;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    globalobj=[[FW_JsonClass alloc]init];
    _jsonResult = [[NSMutableArray alloc]init];
    forgotArray = [[NSMutableArray alloc]init];
    
    
    // Do any additional setup after loading the view, typically from a nib.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login_button:(id)sender
{//_jsonResult=[[NSMutableArray alloc]init];
    
  //   NSString *urlstring=[NSString stringWithFormat:@"%@verify_app_login?email=%@&password=%@",App_Domain_Url,email.text,password.text];
    
    NSString *urlstring=[NSString stringWithFormat:@"%@verify_app_login?email=%@&password=%@",App_Domain_Url,[email.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[password.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [globalobj GlobalDict:urlstring Globalstr:@"array" Withblock:^(id result, NSError *error) {
        
        
        
        _jsonResult=[result mutableCopy];
        
    NSLog(@"jsonResult... : %@",result);
        
        if([[_jsonResult valueForKey:@"response" ] isEqualToString:@"success"])
        
        {
            
        [[NSUserDefaults standardUserDefaults] setObject:[_jsonResult valueForKey:@"site_user_id"]  forKey:@"UserId"];
            [[NSUserDefaults standardUserDefaults] setObject:[_jsonResult valueForKey:@"user_name"]  forKey:@"UserName"];
            [[NSUserDefaults standardUserDefaults] setObject:[_jsonResult valueForKey:@"user_image"]  forKey:@"UserImage"];
            ViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Dashboard"];
            [self.navigationController pushViewController:obj animated:YES];
        
        }
        else
        {
        
            UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:[_jsonResult valueForKey:@"message" ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [loginAlert show];
        
        }
        
        
    }];
    
    
//    ViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Dashboard"];
//    [self.navigationController pushViewController:obj animated:YES];

}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//
//
//    if(buttonIndex==0)
//    {
//        email.text=@"";
//    
//        password.text=@"";
//        
//    }
//
//}



- (IBAction)sign_up:(id)sender
{
    ViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"signup_Page"];
    [self.navigationController pushViewController:obj animated:YES];
}


- (IBAction)forgot_Password:(id)sender
{
    
//    NSString *urlForgot=[NSString stringWithFormat:@"%@verify_app_forgot?email=%@",App_Domain_Url,forgot_Password.text];
//     [globalobj GlobalDict:urlForgot Globalstr:@"array" Withblock:^(id result, NSError *error) {
//    
//         forgotArray = [result mutableCopy];
//         NSLog(@"ForgotArray%@",forgotArray);
//         
//         
//    }];
    
    
    ForgotpasswordViewController *obj1=[self.storyboard instantiateViewControllerWithIdentifier:@"Forgor_Password"];
    [self.navigationController pushViewController:obj1 animated:YES];

    
    
    
}

@end
