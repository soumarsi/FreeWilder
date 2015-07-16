//
//  SignUpViewController.m
//  FreeWilder
//
//  Created by Rahul Singha Roy on 27/05/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize lblDtOfBirth,lblGender,lblSignUp,btnSignUp;
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    obj = [[FW_JsonClass alloc]init];
    
    _jsonResult = [[NSMutableArray alloc]init];
    
    _Signup_confrmpwd.placeholder=@"Confirm Password";
    _Signup_email.placeholder=@"Email";
    _Signup_name.placeholder=@"Name";
    _Signup_password.placeholder=@"Password";
    lblSignUp.text=@"Sign up for Free";
    lblGender.text=@"Select your Gender";
    lblDtOfBirth.text=@"Date of Birth";
    [btnSignUp setTitle:@"SIGN UP" forState:UIControlStateNormal];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)Back_button:(id)sender
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

- (IBAction)Sugn_up:(id)sender {
    
    if ([self TarminateWhiteSpace:_Signup_name.text].length==0)
    {
        UIAlertView *alertreg=[[UIAlertView alloc]initWithTitle:@"Name Alert" message:@" Name field blank" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertreg show];
    }
    else if (![self validateEmail:[_Signup_email text]])
    {
        
    }
    else if (![_Signup_password.text isEqualToString:_Signup_confrmpwd.text])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Password Alert" message:@"Password  Mismatches" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if (gender.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Gender" message:@"Select Gender" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (dateShowlbl.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Date of Birth" message:@"Select Date of Birth" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    else
    {
        
        
        
     //   Signup_url = [NSString stringWithFormat:@"%@verify_app_signup?name=%@&email=%@&password=%@&confirm_password=%@&gender=%@&birth_date=%@",App_Domain_Url,_Signup_name.text,_Signup_email.text,_Signup_password.text,_Signup_confrmpwd.text,gen,dateShowlbl.text];
        
        Signup_url = [NSString stringWithFormat:@"%@verify_app_signup?name=%@&email=%@&password=%@&confirm_password=%@&gender=%@&birth_date=%@",App_Domain_Url,[_Signup_name.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_Signup_email.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_Signup_password.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_Signup_confrmpwd.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[gen stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[dateShowlbl.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [obj GlobalDict:Signup_url Globalstr:@"array" Withblock:^(id result, NSError *error)
         {
             
             _jsonResult = [result mutableCopy];
             NSLog(@"jsonResult%@",_jsonResult);
             
             
             if ([[_jsonResult valueForKey:@"response"] isEqualToString:@"Success"]) {
                 //             ViewController *obj_view=[self.storyboard instantiateViewControllerWithIdentifier:@"Login_Page"];
                 //             [self.navigationController pushViewController:obj_view animated:YES];
                 
                 [self back];
                 UIAlertView *objAlert = [[UIAlertView alloc] initWithTitle:[_jsonResult valueForKey:@"email"] message:[_jsonResult valueForKey:@"message"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close",nil];
                 [objAlert show];
                 
                 
                 
             }
             
             
             else{
                 
                 
                 UIAlertView *myAlert = [[UIAlertView alloc]
                                         initWithTitle:[_jsonResult valueForKey:@"response"]
                                         message:[_jsonResult valueForKey:@"message"]
                                         delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Ok",nil];
                 _Signup_name.text= @"";
                 _Signup_email.text=@"";
                 _Signup_password.text = @"";
                 _Signup_confrmpwd.text=@"";
                 dateShowlbl.text = @"";
                 gender.text =@"";
                 [myAlert show];
                 
             }
             
             
         }];
    }
    
}


-(void)LabelTitle:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"MMM/dd/yyyy"];
    
    strday=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:picker.date]];
    strmon=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:picker.date]];
    stryear=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:picker.date]];
    strday = [strday substringWithRange:NSMakeRange(4,2)];
    strmon = [strmon substringWithRange:NSMakeRange(0,3)];
    stryear = [stryear substringWithRange:NSMakeRange(7,4)];
   
}



- (IBAction)datebtn:(id)sender {
    
    [self.view endEditing:YES];
    
    CGRect screenBounds=[[UIScreen mainScreen] bounds];
    
    
    if (screenBounds.size.height == 568 && screenBounds.size.width == 320) {
        
        
        myview = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, self.view.bounds.size.height)];
        [myview setBackgroundColor:[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1]];
        
        
        picker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0,10,self.view.bounds.size.width, self.view.bounds.size.height)];
        [picker setBackgroundColor:[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:0.5f]];
        [myview addSubview:picker];
        
        //[picker setBackgroundColor:[UIColor clearColor]];
        [picker setBackgroundColor: [UIColor colorWithRed:(245.0f/255.0f) green:(245.0f/255.0f) blue:(245.0f/255.0f) alpha:1]];
        
        picker.datePickerMode=UIDatePickerModeDate;
        //    picker.hidden=NO;
        picker.date=[NSDate date];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(-15,225,187,42)];
        btn.backgroundColor=[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1];
        [btn setTitle: @"OK" forState: UIControlStateNormal];
        [btn addTarget:self action:@selector(ok:) forControlEvents:UIControlEventTouchUpInside];
        [picker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
        [myview addSubview:btn];
        
        
        UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(150,225,188,42)];
        btn1.backgroundColor=[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1];
        [btn1 addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitle: @"CANCEL" forState: UIControlStateNormal];
        [myview addSubview:btn1];
        
        [self.view addSubview:myview];
        
    }
    else if(screenBounds.size.height == 667 && screenBounds.size.width == 375)
    {
        myview = [[UIView alloc] initWithFrame:CGRectMake(0, 400, self.view.bounds.size.width, self.view.bounds.size.height)];
        [myview setBackgroundColor:[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1]];
        
        
        picker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0,10,self.view.bounds.size.width, self.view.bounds.size.height)];
        [picker setBackgroundColor:[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1]];
        [myview addSubview:picker];
        
        //[picker setBackgroundColor:[UIColor clearColor]];
        [picker setBackgroundColor: [UIColor colorWithRed:(245.0f/255.0f) green:(245.0f/255.0f) blue:(245.0f/255.0f) alpha:1]];
        
        picker.datePickerMode=UIDatePickerModeDate;
        //    picker.hidden=NO;
        picker.date=[NSDate date];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0,225,185,40)];
        btn.backgroundColor=[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1];
        [btn setTitle: @"OK" forState: UIControlStateNormal];
        [btn addTarget:self action:@selector(ok:) forControlEvents:UIControlEventTouchUpInside];
        [picker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
        [myview addSubview:btn];
        
        
        UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(187,225,185,40)];
        btn1.backgroundColor=[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1];
        [btn1 addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitle: @"CANCEL" forState: UIControlStateNormal];
        [myview addSubview:btn1];
        
        [self.view addSubview:myview];
        
    }
    
    
    else if(screenBounds.size.height == 480 && screenBounds.size.width == 320)
    {
        myview = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.height)];
        [myview setBackgroundColor:[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1]];
        
        
        picker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0,10,self.view.bounds.size.width, self.view.bounds.size.height)];
        [picker setBackgroundColor:[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1]];
        [myview addSubview:picker];
        
        //[picker setBackgroundColor:[UIColor clearColor]];
        [picker setBackgroundColor: [UIColor colorWithRed:(245.0f/255.0f) green:(245.0f/255.0f) blue:(245.0f/255.0f) alpha:1]];
        
        picker.datePickerMode=UIDatePickerModeDate;
        //    picker.hidden=NO;
        picker.date=[NSDate date];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(-7,225,187,42)];
        btn.backgroundColor=[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1];
        [btn setTitle: @"OK" forState: UIControlStateNormal];
        [btn addTarget:self action:@selector(ok:) forControlEvents:UIControlEventTouchUpInside];
        [picker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
        [myview addSubview:btn];
        
        
        UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(150,225,188,42)];
        btn1.backgroundColor=[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1];
        [btn1 addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitle: @"CANCEL" forState: UIControlStateNormal];
        [myview addSubview:btn1];
        
        [self.view addSubview:myview];
    }
    else
    {
        myview = [[UIView alloc] initWithFrame:CGRectMake(0, 450, self.view.bounds.size.width, self.view.bounds.size.height)];
        [myview setBackgroundColor:[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1]];
        
        
        picker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0,10,self.view.bounds.size.width, self.view.bounds.size.height)];
        [picker setBackgroundColor:[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1]];
        [myview addSubview:picker];
        
        //[picker setBackgroundColor:[UIColor clearColor]];
        [picker setBackgroundColor: [UIColor colorWithRed:(245.0f/255.0f) green:(245.0f/255.0f) blue:(245.0f/255.0f) alpha:1]];
        
        picker.datePickerMode=UIDatePickerModeDate;
        //    picker.hidden=NO;
        picker.date=[NSDate date];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(15,225,187,42)];
        btn.backgroundColor=[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1];
        [btn setTitle: @"OK" forState: UIControlStateNormal];
        [btn addTarget:self action:@selector(ok:) forControlEvents:UIControlEventTouchUpInside];
        [picker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
        [myview addSubview:btn];
        
        
        UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(210,225,188,42)];
        btn1.backgroundColor=[UIColor colorWithRed:(51.0f/255.0f) green:(26.0f/255.0f) blue:(47.0f/255.0f) alpha:1];
        [btn1 addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitle: @"CANCEL" forState: UIControlStateNormal];
        [myview addSubview:btn1];
        
        [self.view addSubview:myview];
        
    }
}

-(void)ok:(id)sender
{
    [UIView animateWithDuration:0.5f
     // delay:0.1f
     // options:UIViewAnimationTransitionNone
                     animations:^{
                         
                         [self.view setFrame:CGRectMake(0, 0,mainView.bounds.size.width, mainView.bounds.size.height)];
                     }
     
     ];
  //  [picker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
 //   NSLog(@".....%@",strday);
  //  NSLog(@"date=%@",picker.date);
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"MMM/dd/yyyy"];
    
    strday=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:picker.date]];
    strmon=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:picker.date]];
    stryear=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:picker.date]];
    strday = [strday substringWithRange:NSMakeRange(4,2)];
    strmon = [strmon substringWithRange:NSMakeRange(0,3)];
    stryear = [stryear substringWithRange:NSMakeRange(7,4)];
    [self monthcheck];
    dateShowlbl.text=[NSString stringWithFormat:@"%@/%@/%@",stryear,strmon,strday];
    
    [myview removeFromSuperview];
    
}
-(void)cancel:(id)sender
{
    [myview removeFromSuperview];
}

-(void)monthcheck
{
    if ([strmon isEqualToString:@"Jan"]) {
        strmon=@"1";
    }
    else if ([strmon isEqualToString:@"Feb"]) {
        strmon=@"2";
    }
    else if ([strmon isEqualToString:@"Mar"]) {
        strmon=@"3";
    }
    else if ([strmon isEqualToString:@"Apr"]) {
        strmon=@"4";
    }
    else if ([strmon isEqualToString:@"May"]) {
        strmon=@"5";
    }
    else if ([strmon isEqualToString:@"Jun"]) {
        strmon=@"6";
    }
    else if ([strmon isEqualToString:@"Jul"]) {
        strmon=@"7";
    }
    else if ([strmon isEqualToString:@"Aug"]) {
        strmon=@"8";
    }
    else if ([strmon isEqualToString:@"Sep"]) {
        strmon=@"9";
    }
    else if ([strmon isEqualToString:@"Oct"]) {
        strmon=@"10";
    }
    else if ([strmon isEqualToString:@"Nov"]) {
        strmon=@"11";
    }
    else if ([strmon isEqualToString:@"Dec"]) {
        strmon=@"12";
    }
}
- (IBAction)check:(id)sender
{
    
    NSString *actionSheetTitle = @"Select Your Gender"; //Action Sheet Title
    
    NSString *other1 = @"Male";
    NSString *other2 = @"Female";
    
    NSString *cancelTitle = @"OK";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, nil];
    
    [self.view endEditing:YES];
    [actionSheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            gender.text = @"Male";
            gen=@"M";
            
        }
            break;
        case 1:
        {
            gender.text= @"Female";
            gen=@"F";
        }
            break;
        default:
            break;
    }
    
    
    
    
    
    
}
- (BOOL)validateEmail:(NSString *)emailStr{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if(![emailTest evaluateWithObject:_Signup_email.text])
    {
        ////NSLog(@"Invalid email address found");
        UIAlertView *objAlert = [[UIAlertView alloc] initWithTitle:@"Mail alert" message:@"Please enter valid Emailid." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close",nil];
        [objAlert show];
        
        return FALSE;
    }
    return TRUE;
}


-(void)back
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


@end

