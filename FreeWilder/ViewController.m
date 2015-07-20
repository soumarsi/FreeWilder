//
//  ViewController.m
//  FreeWilder
//
//  Created by Rahul Singha Roy on 27/05/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
@interface ViewController ()<UITextFieldDelegate,UIAlertViewDelegate>


{
    NSMutableArray *contactList;
    AppDelegate *appDelegate;
    FW_JsonClass *globalobj;

}


@property (strong, nonatomic) IBOutlet UITextField *email;


@property (strong, nonatomic) IBOutlet UITextField *password;

@property (strong, nonatomic)NSMutableArray *jsonResult;

@end

@implementation ViewController

@synthesize email,password,lbldontHaveAccount,lblFacebook,lblLogin,btnSignUp,btnForgetPassword,btnlogin;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    contactList = [[NSMutableArray alloc]init];
    
    appDelegate  = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,NULL);
    
    __block BOOL accessGranted = NO;
    
    if (&ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    }
    
    else { // We are on iOS 5 or Older
        accessGranted = YES;
        [self getContactsWithAddressBook:addressBook];
    }
    if (accessGranted) {
        [self getContactsWithAddressBook:addressBook];
    }

    
    globalobj=[[FW_JsonClass alloc]init];
    _jsonResult = [[NSMutableArray alloc]init];
    forgotArray = [[NSMutableArray alloc]init];
    
    email.placeholder=@"Username";
    password.placeholder=@"Password";
    lblLogin.text=@"Login with your";
    lblFacebook.text=@"Facebook";
    lbldontHaveAccount.text=@"Don't have an account ?";
    
    [btnSignUp setTitle:@"Sign up" forState:UIControlStateNormal];
    [btnForgetPassword setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [btnlogin setTitle:@"LOG IN" forState:UIControlStateNormal];
    
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

// Get the contacts.
- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int j=0;j < nPeople;j++) {
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,j);
        
        //For username and surname
        //  ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        
        
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        
        if (ABRecordCopyValue(ref, kABPersonLastNameProperty) != NULL)
        {
            lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
            [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        }
        else
        {
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", firstName] forKey:@"name"];
        }
        
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
        }
        //For Image
        
        UIImage *contactImage = [self imageForContact:ref];
        NSData *cpontactimagedata = UIImageJPEGRepresentation(contactImage, 1.0f);
        UIImage *img = [UIImage imageNamed:@"ProfileImage"];
        NSData *imgdata = UIImageJPEGRepresentation(img, 1.0f);
        if (contactImage != nil)
        {
            [dOfPerson setObject:cpontactimagedata forKey:@"image"];
        }
        else
        {
            [dOfPerson setObject:imgdata forKey:@"image"];
        }
        
   /*     ABMultiValueRef phoneNumbers = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        
        for (CFIndex j=0; j < ABMultiValueGetCount(phoneNumbers); j++)
            
        {
            
            NSString* phoneLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phoneNumbers, j);
            
            NSString* phoneNumber = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phoneNumbers, j));
            
            if([phoneLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
                
            {
                
                mobileno = phoneNumber;
                break;
                
            }
            
            else if([phoneLabel isEqualToString:@"_$!<Home>!$_"])
                
            {
                
                homeno = phoneNumber;
            }
            
            else if([phoneLabel isEqualToString:@"_$!<Work>!$_"])
                
            {
                
                workno = phoneNumber;
            }
            
            else
                
            {
                otherno = phoneNumber;
                
            }
            
        }
        
        CFRelease(phoneNumbers);
        
        if (![mobileno isKindOfClass:[NSNull class]] && [mobileno length] > 0)
            
            newstringph = mobileno;
        
        else if (![homeno isKindOfClass:[NSNull class]] && [homeno length] > 0)
            
            newstringph = homeno;
        
        else if (![workno isKindOfClass:[NSNull class]] && [workno length] > 0)
            
            newstringph = workno;
        
        else
            
            newstringph = otherno;        // [contactList addObject:dOfPerson];
        
        //  NSLog(@"---- %@", newstringph);
        [dOfPerson setObject:newstringph forKey:@"Phone"];
        
        */
        
        if ([[dOfPerson objectForKey:@"email"] length] != 0)
        {
            [contactList addObject:dOfPerson];
        }
       }
    
    NSManagedObjectContext *context3=[appDelegate managedObjectContext];
    NSFetchRequest *request3=[[NSFetchRequest alloc] initWithEntityName:@"ContactList"];
    NSMutableArray *fetchrequest3=[[context3 executeFetchRequest:request3 error:nil] mutableCopy];
    for (NSManagedObject *obj3 in fetchrequest3)
    {
        
        [context3 deleteObject:obj3];
        
        
    }
        NSOperationQueue *myQueue11 = [[NSOperationQueue alloc] init];
        [myQueue11 addOperationWithBlock:^{
             for (int k = 0; k < contactList.count; k++)
            {
                NSLog(@"putting image data in core data.");
                NSManagedObjectContext *context=[appDelegate managedObjectContext];
                NSManagedObject *manageobject=[NSEntityDescription insertNewObjectForEntityForName:@"ContactList" inManagedObjectContext:context];
                
                [manageobject setValue:[[contactList objectAtIndex:k] valueForKey:@"email"] forKey:@"email"];
                [manageobject setValue:[[contactList objectAtIndex:k] valueForKey:@"name"] forKey:@"name"];
                [manageobject setValue:[[contactList objectAtIndex:k] valueForKey:@"image"] forKey:@"image"];

                [appDelegate saveContext];
           }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            }];
        }];

      
        
    }


- (UIImage*)imageForContact: (ABRecordRef)contactRef {
    UIImage *img = nil;
    
    // can't get image from a ABRecordRef copy
    ABRecordID contactID = ABRecordGetRecordID(contactRef);
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    ABRecordRef origContactRef = ABAddressBookGetPersonWithRecordID(addressBook, contactID);
    
    if (ABPersonHasImageData(origContactRef)) {
        NSData *imgData = (__bridge NSData*)ABPersonCopyImageDataWithFormat(origContactRef, kABPersonImageFormatThumbnail);
        img = [UIImage imageWithData: imgData];
        
        
    }
    
    CFRelease(addressBook);
    
    return img;
}


@end
