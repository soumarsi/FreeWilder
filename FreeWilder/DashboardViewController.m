//
//  DashboardViewController.m
//  FreeWilder
//
//  Created by Rahul Singha Roy on 27/05/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//


#import "AddServiceViewController.h"
#import "DashboardViewController.h"
#import "Footer.h"
#import "Side_menu.h"
@interface DashboardViewController ()<footerdelegate,Slide_menu_delegate>

{
    
    
    IBOutlet UIButton *btn1;
    
    
    IBOutlet UIButton *btn2;
    
    IBOutlet UIButton *btn3;
    
    IBOutlet UIButton *btn4;
    
    IBOutlet UIButton *moreBtn;
    
    UIButton *temp1;
    
    UIButton *temp2;
    
    int resultCount;
    
    BOOL smallBtn;
    
    BOOL alreadyTapped;
    
    //frame variables
    
    CGRect leftframe;
    
    CGRect rightframe;
    
    //title var
    
    int titleCount;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (strong, nonatomic)NSMutableArray *jsonResult;

@end

@implementation DashboardViewController

@synthesize scroll,jsonResult;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    resultCount=0;
    
    titleCount=4;
    
    smallBtn=YES;
    
    alreadyTapped=NO;
    
    // titleCount=0;
    
    //frame variables initialization
    
    leftframe=CGRectMake(0, 0, 0, 0);
    
    rightframe=CGRectMake(0, 0, 0, 0);
    
    
    //
    
    scroll.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, 959.0f);
    
    scroll.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    
    
    
    
    
    //initializing json class object
    
    
    
    
    globalobj=[[FW_JsonClass alloc]init];
    
    [self urlFire];
    
    
    
    /// initializing app footer view
    
    NSLog(@"Dashboard....");
    
    Footer *footer=[[Footer alloc]init];
    footer.frame=CGRectMake(0,0,_footer_base.frame.size.width,_footer_base.frame.size.height);
    footer.Delegate=self;
    [footer TapCheck:1];
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
    sidemenu.ProfileImage.contentMode=UIViewContentModeScaleAspectFit;
    sidemenu.hidden=YES;
    sidemenu.SlideDelegate=self;
    [self.view addSubview:sidemenu];
    
}


-(void)urlFire
{
    
    //firing url
    
    NSString *urlstring=[NSString stringWithFormat:@"%@verify_app_category?categorytype=toplevel",App_Domain_Url];
    
    [globalobj GlobalDict:urlstring Globalstr:@"array" Withblock:^(id result, NSError *error) {
        
        
        jsonResult=[[NSMutableArray alloc]init];
        
        jsonResult=[result mutableCopy];
        
    //    NSLog(@"jsonResult... : %@",jsonResult);
        
        NSLog(@"jsonResult count... %lu",(long)[[jsonResult valueForKey:@"infoaray"] count]);
        
        resultCount=(int)[[jsonResult valueForKey:@"infoaray"] count];
        
        resultCount-=4;
        
        
        
        [self btnCreate];
        
        //Modifying buttons which are created in storyboard
        
        //btn1
        
        [btn1 setTitle:[[[jsonResult valueForKey:@"infoaray"] objectAtIndex:(0) ]valueForKey:@"category_name"] forState:UIControlStateNormal];
        
        btn1.titleLabel.adjustsFontSizeToFitWidth=YES;
        
        [btn1.layer setBorderColor:[[UIColor colorWithRed:(171.0f/255.0f) green:(171.0f/255.0f) blue:(171.0f/255.0f) alpha:1] CGColor]];
        btn1.layer.borderWidth=0.5;
        
        [btn1 setTitleColor:[UIColor colorWithRed:(115.0f/255.0) green:(115.0f/255.0) blue:(115.0f/255.0) alpha:3] forState:UIControlStateNormal];
        [[btn1 layer] setBorderWidth:0.5f];
        [[btn1 layer] setBorderColor:[UIColor colorWithRed:(171.0f/255.0) green:(171.0f/255.0) blue:(171.0f/255.0) alpha:1].CGColor];
        [btn1 setBackgroundColor:[UIColor whiteColor]];
        
        
        [btn1 setTitleColor:[UIColor colorWithRed:(158.0f/255.0f) green:(158.0f/255.0f) blue:(158.0f/255.0f) alpha:1] forState:UIControlStateNormal];
        btn1.tag=[[[[jsonResult valueForKey:@"infoaray"] objectAtIndex:(0) ]valueForKey:@"id"] integerValue];
        
        
        [btn1 addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //btn2
        
        [btn2 setTitle:[[[jsonResult valueForKey:@"infoaray"] objectAtIndex:(1) ]valueForKey:@"category_name"] forState:UIControlStateNormal];
        
        btn2.titleLabel.adjustsFontSizeToFitWidth=YES;
        
        [btn2.layer setBorderColor:[[UIColor colorWithRed:(171.0f/255.0f) green:(171.0f/255.0f) blue:(171.0f/255.0f) alpha:1] CGColor]];
        btn2.layer.borderWidth=0.5;
        
        
        
        [btn2 setTitleColor:[UIColor colorWithRed:(158.0f/255.0f) green:(158.0f/255.0f) blue:(158.0f/255.0f) alpha:1] forState:UIControlStateNormal];
        btn2.tag=[[[[jsonResult valueForKey:@"infoaray"] objectAtIndex:(1) ]valueForKey:@"id"] integerValue];
        [btn2 addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        //btn3
        
        [btn3 setTitle:[[[jsonResult valueForKey:@"infoaray"] objectAtIndex:(2) ]valueForKey:@"category_name"] forState:UIControlStateNormal];
        
        btn3.titleLabel.adjustsFontSizeToFitWidth=YES;
        
        [btn3.layer setBorderColor:[[UIColor colorWithRed:(171.0f/255.0f) green:(171.0f/255.0f) blue:(171.0f/255.0f) alpha:1] CGColor]];
        btn3.layer.borderWidth=0.5;
        
        
        [btn3 setTitleColor:[UIColor colorWithRed:(158.0f/255.0f) green:(158.0f/255.0f) blue:(158.0f/255.0f) alpha:1] forState:UIControlStateNormal];
        
        btn3.tag=[[[[jsonResult valueForKey:@"infoaray"] objectAtIndex:(2) ]valueForKey:@"id"] integerValue];
        [btn3 addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        //btn4
        
        
        [btn4 setTitle:[[[jsonResult valueForKey:@"infoaray"] objectAtIndex:(3) ]valueForKey:@"category_name"] forState:UIControlStateNormal];
        
        btn4.titleLabel.adjustsFontSizeToFitWidth=YES;
        
        
        [btn4.layer setBorderColor:[[UIColor colorWithRed:(171.0f/255.0f) green:(171.0f/255.0f) blue:(171.0f/255.0f) alpha:1] CGColor]];
        btn4.layer.borderWidth=0.5;
        
        
        [btn4 setTitleColor:[UIColor colorWithRed:(158.0f/255.0f) green:(158.0f/255.0f) blue:(158.0f/255.0f) alpha:1] forState:UIControlStateNormal];
        btn4.tag=[[[[jsonResult valueForKey:@"infoaray"] objectAtIndex:(3) ]valueForKey:@"id"] integerValue];
        [btn4 addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
    }];
    
    
    
    
    
    
    
}

-(void)btnCreate
{
    leftframe=btn3.frame;
    rightframe=btn4.frame;
    
    int rows=resultCount/2;
    
    int oddRow = 0;
    
    if(resultCount%2)
    {
        rows+=1;
        
        oddRow=rows;
        
    }
    
    NSLog(@"Rows count: %d",rows);
    
    
    for (int i=0; i<rows; i++)
    {
        NSLog(@"creating button...");
        
        
        
        leftframe.origin.y=leftframe.origin.y+leftframe.size.height+6;
        
        
        if(smallBtn==YES)
        {
            temp1=[[UIButton alloc]initWithFrame:CGRectMake(leftframe.origin.x, leftframe.origin.y, btn4.bounds.size.width, leftframe.size.height)];
            
            smallBtn=NO;
        }
        else
        {
            temp1=[[UIButton alloc]initWithFrame:CGRectMake(leftframe.origin.x, leftframe.origin.y, btn3.bounds.size.width, leftframe.size.height)];//leftframe
            
            smallBtn=YES;
            
        }
        
        
        [temp1.layer setBorderColor:[[UIColor colorWithRed:(171.0f/255.0f) green:(171.0f/255.0f) blue:(171.0f/255.0f) alpha:1] CGColor]];
        temp1.layer.borderWidth=0.5;
        
        
        [temp1 setTitleColor:[UIColor colorWithRed:(158.0f/255.0f) green:(158.0f/255.0f) blue:(158.0f/255.0f) alpha:1] forState:UIControlStateNormal];
        
        //temp1.titleLabel.textColor=[UIColor colorWithRed:(158.0f/255.0f) green:(158.0f/255.0f) blue:(158.0f/255.0f) alpha:1];
        
        temp1.layer.cornerRadius=20.0f;
        
        temp1.tag=[[[[jsonResult valueForKey:@"infoaray"] objectAtIndex:(titleCount) ]valueForKey:@"id"] integerValue];
        
        [temp1 addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        // temp1.backgroundColor=[UIColor colorWithRed:(31.0f/255.0f) green:(173.0f/255.0f) blue:(121.0f/255.0f) alpha:1];
        
        
        
        
        [temp1 setTitle:[[[jsonResult valueForKey:@"infoaray"] objectAtIndex:(titleCount) ]valueForKey:@"category_name"] forState:UIControlStateNormal];
        
        temp1.titleLabel.adjustsFontSizeToFitWidth=YES;
        
        
        NSLog(@"Button title: %@",[[[jsonResult valueForKey:@"infoaray"] objectAtIndex:(titleCount) ]valueForKey:@"category_name"]);
        
        
        
        leftframe=temp1.frame;
        
        [scroll addSubview:temp1];
        
        titleCount++;
        
        
        if(i!=oddRow-1)
        {
            NSLog(@"odd row....");
            
            
            
            CGRect rightTempFrame=leftframe;
            
            rightTempFrame.origin.x=leftframe.origin.x+temp1.bounds.size.width+10;
            
            temp2=[[UIButton alloc]initWithFrame:CGRectMake(rightTempFrame.origin.x, rightTempFrame.origin.y, rightframe.origin.x+rightframe.size.width-rightTempFrame.origin.x, rightframe.size.height)];
            
            
            
            [temp2.layer setBorderColor:[[UIColor colorWithRed:(171.0f/255.0f) green:(171.0f/255.0f) blue:(171.0f/255.0f) alpha:1] CGColor]];
            temp2.layer.borderWidth=0.5;
            
            [temp2 setTitleColor:[UIColor colorWithRed:(158.0f/255.0f) green:(158.0f/255.0f) blue:(158.0f/255.0f) alpha:1] forState:UIControlStateNormal];
            
            
            temp2.tag=[[[[jsonResult valueForKey:@"infoaray"] objectAtIndex:(titleCount) ]valueForKey:@"id"] integerValue];
            
            
            
            // temp2.backgroundColor=[UIColor colorWithRed:(31.0f/255.0f) green:(173.0f/255.0f) blue:(121.0f/255.0f) alpha:1];
            
            [temp2 addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            // temp2.titleLabel.textColor=[UIColor whiteColor];
            
            
            [temp2 setTitle:[[[jsonResult valueForKey:@"infoaray"] objectAtIndex:(titleCount) ]valueForKey:@"category_name"] forState:UIControlStateNormal];
            
            NSLog(@"Button title: %@",[[[jsonResult valueForKey:@"infoaray"] objectAtIndex:(titleCount) ]valueForKey:@"category_name"]);
            
            temp2.titleLabel.adjustsFontSizeToFitWidth=YES;
            
            temp2.layer.cornerRadius=20.0f;
            
            rightframe=temp2.frame;
            
            [scroll addSubview:temp2];
            
            titleCount++;
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    CGRect frameMore=moreBtn.frame;
    
    frameMore.origin.y=temp1.frame.origin.y+temp1.bounds.size.height+14;
    
    moreBtn.frame=frameMore;
    
    
    scroll.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, moreBtn.frame.origin.y+moreBtn.bounds.size.height+10);
    
}



-(void)btnTapped:(id)sender
{
    
    UIButton *tappedBtn=(UIButton *)(id)sender;
    tappedBtn.selected=YES;
   /*
    if(tappedBtn.tag==0)
        tappedBtn.tag=1;
    else
        tappedBtn.tag=0;
    */
    if(tappedBtn.selected==YES)
    {
        
        tappedBtn.backgroundColor=[UIColor colorWithRed:(31.0f/255.0f) green:(173.0f/255.0f) blue:(121.0f/255.0f) alpha:1];
        
        [tappedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        tappedBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
        
        //shadow
        
        tappedBtn.layer.shadowOffset=CGSizeMake(0, 1);
        tappedBtn.layer.shadowRadius=3.5;
        tappedBtn.layer.shadowColor=[UIColor blackColor].CGColor;
        tappedBtn.layer.shadowOpacity=0.4;
        
        
    }
    
    else
    {
        
        [tappedBtn.layer setBorderColor:[[UIColor colorWithRed:(171.0f/255.0f) green:(171.0f/255.0f) blue:(171.0f/255.0f) alpha:1] CGColor]];
        tappedBtn.layer.borderWidth=0.5;
        
        [tappedBtn setTitleColor:[UIColor colorWithRed:(158.0f/255.0f) green:(158.0f/255.0f) blue:(158.0f/255.0f) alpha:1] forState:UIControlStateNormal];
        
        tappedBtn.backgroundColor=[UIColor whiteColor];
        
        tappedBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
        
        
        
        tappedBtn.layer.shadowOpacity=0.0;
        
        
        
    }
    ProductViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Product_Page"];
    obj.CategoryId=[NSString stringWithFormat:@"%ld",(long)tappedBtn.tag];
    [self.navigationController pushViewController:obj animated:YES];
    
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
        
        DashboardViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"add_service_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==3)
    {
        
        DashboardViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"msg_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==2)
    {
        
        DashboardViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"search_page"];
        [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
        
    }
    else if (sender.tag==1)
    {
        
        DashboardViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Dashboard"];
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
             DashboardViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Invite_Friend"];
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         
         else if (sender.tag==7)
         {
             DashboardViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Login_Page"];
             
             [self PushViewController:obj WithAnimation:kCAMediaTimingFunctionEaseIn];
         }
         else if (sender.tag==3)
         {
             
             DashboardViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Edit_profile_page"];
             
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

- (IBAction)more_interests:(id)sender
{
    DashboardViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"Interest_page"];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)get_started_button:(id)sender
{
    
    DashboardViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"add_service_page"];
    [self.navigationController pushViewController:obj animated:YES];
}
@end
