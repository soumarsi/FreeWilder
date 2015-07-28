//
//  InviteFriendViewController.m
//  FreeWilder
//
//  Created by Soumen on 01/06/15.
//  Copyright (c) 2015 Sandeep Dutta. All rights reserved.
//

#import "FW_InviteFriendViewController.h"
#import "InviteFriendcell.h"
#import "Footer.h"
#import "Side_menu.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>

@interface FW_InviteFriendViewController ()<footerdelegate,Slide_menu_delegate,MFMailComposeViewControllerDelegate>
{
    InviteFriendcell *cell;
    NSMutableArray *arrindexpath;
    int i;
    BOOL flag;
    int selected;
    NSMutableArray *contactList,*ArrSearchList;
    AppDelegate *appDelegate;

}
@property (weak, nonatomic) IBOutlet UITableView *inviteTable;

@end

@implementation FW_InviteFriendViewController
@synthesize lblInviteFriend,btnSend,SearchBar,inviteTable,lblNoDataFound;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    contactList = [[NSMutableArray alloc]init];
    ArrSearchList = [[NSMutableArray alloc]init];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObjectContext *context1=[appDelegate managedObjectContext];
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"ContactList"];
   NSMutableArray *fetcharray=[[context1 executeFetchRequest:request error:nil] mutableCopy];
    NSInteger CoreDataCount=[fetcharray count];
    NSLog(@"core data count=%ld",(long)CoreDataCount);
    
    [contactList removeAllObjects];

    for(NSManagedObject *obj1 in fetcharray)
    {
        [contactList addObject:obj1];
    }

    [SearchBar setBackgroundColor:[UIColor clearColor]];
    //   searchbar.barTintColor = [UIColor colorWithRed:(35/255.0f) green:(154/255.0f) blue:(242/255.0f) alpha:1];
    UITextField *searchField = [SearchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor blackColor];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    lblNoDataFound.hidden=YES;
    i=0;
    flag=YES;
    selected=0;
    arrindexpath=[[NSMutableArray alloc]init];
    _searchtextfield.autocorrectionType=UITextAutocorrectionTypeNo;
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
  //  sidemenu.ProfileImage.contentMode=UIViewContentModeScaleAspectFit;
    sidemenu.hidden=YES;
    sidemenu.SlideDelegate=self;
    [self.view addSubview:sidemenu];

    lblInviteFriend.text=@"Invite Friend";
    [btnSend setTitle:@"Send" forState:UIControlStateNormal];
    [btnSend setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _searchtextfield.placeholder=@"Search";
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
        
        FW_InviteFriendViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"add_service_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==3)
    {
        
        FW_InviteFriendViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"msg_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==2)
    {
        
        FW_InviteFriendViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchProductViewControllersid"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==1)
    {
        
        FW_InviteFriendViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Interest_page"];
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
             FW_InviteFriendViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Invite_Friend"];
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
             
             
             FW_InviteFriendViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Login_Page"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==7)
         {
            
             
             FW_InviteFriendViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"WishlistViewControllersid"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==3)
         {
             
             FW_InviteFriendViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Edit_profile_page"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==5)
         {
             
             FW_InviteFriendViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ServiceListingViewControllersid"];
             
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (IsSearch==1)
    {
        return ArrSearchList.count;
    }
    else
    {
    return contactList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(InviteFriendcell *)[tableView dequeueReusableCellWithIdentifier:@"invitefriendcell"];
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];


    if (IsSearch==1)
    {
        cell.invitefriendName.text = [[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.invitefriendPhonenumber.text = [[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"email"];
        
        NSData *data = [[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"Image"];
        
        cell.invitefriendImage.image  =[UIImage imageWithData:data];
    }
    else
    {
    cell.invitefriendName.text = [[contactList objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.invitefriendPhonenumber.text = [[contactList objectAtIndex:indexPath.row] valueForKey:@"email"];

    NSData *data = [[contactList objectAtIndex:indexPath.row] valueForKey:@"Image"];
   
        cell.invitefriendImage.image  =[UIImage imageWithData:data];
    }
    cell.invitefriendImage.layer.cornerRadius = 50/2;
    cell.invitefriendImage.clipsToBounds = YES;
    
       return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IsSearch==1)
    {
        NSString *emailTitle = @"Invitation to join Freewilder";
        // Email Content
        NSString *messageBody = [NSString stringWithFormat:@"Hello,\n You have been invited to join Freewilder by your friend %@.Please click on the link below to visit the website.\n http://esolz.co.in/lab6/freewilder/> \n       Thanks & Regards Freewilder Team.",[[contactList objectAtIndex:indexPath.row] valueForKey:@"name"]];
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:[[ArrSearchList objectAtIndex:indexPath.row] valueForKey:@"email"]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else{
    NSString *emailTitle = @"Invitation to join Freewilder";
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"Hello,\n You have been invited to join Freewilder by your friend %@.Please click on the link below to visit the website.\n http://esolz.co.in/lab6/freewilder/> \n       Thanks & Regards Freewilder Team.",[[contactList objectAtIndex:indexPath.row] valueForKey:@"name"]];
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:[[contactList objectAtIndex:indexPath.row] valueForKey:@"email"]];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    }
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

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


- (IBAction)Back_button_action:(id)sender
{
    [self POPViewController];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    inviteTable.hidden=YES;
    IsSearch=1;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO];
    searchBar.text=@"";
    lblNoDataFound.hidden=YES;
    IsSearch=0;
    [inviteTable reloadData];
    inviteTable.hidden=NO;
    [searchBar resignFirstResponder];
    //   searchbar.hidden=YES;
    //   btnsearch.hidden=NO;
    //   btnsearchicon.hidden=NO;
    //   btnsearch.selected=NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    
    
    
    if(searchBar.text.length > 0) {
        NSLog(@"searchbar is");
        
        IsSearch=1;
        [searchBar setShowsCancelButton:YES];
        [ArrSearchList removeAllObjects];
        // Filter the array using NSPredicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@",searchText];
        ArrSearchList = [NSMutableArray arrayWithArray:[contactList filteredArrayUsingPredicate:predicate]];
        if (ArrSearchList.count==0)
        {
            lblNoDataFound.hidden=NO;
        }
        else
        {
            lblNoDataFound.hidden=YES;
        }
        [inviteTable reloadData];
        inviteTable.hidden=NO;
     
        
    }
    else {
        NSLog(@"searchbar is NOT");
        
        
    }
    
    
    
    
}
@end
