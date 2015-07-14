//
//  Side_menu.m
//  FreeWilder
//
//  Created by Rahul Singha Roy on 27/05/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import "Side_menu.h"

@implementation Side_menu
@synthesize SlideDelegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self=[[[NSBundle mainBundle] loadNibNamed:@"Side_menu" owner:self options:nil]objectAtIndex:0];
    }
    self.ProfileImage.layer.cornerRadius=self.ProfileImage.frame.size.height/2.0;
    self.ProfileImage.contentMode=UIViewContentModeScaleAspectFill;
     self.ProfileImage.clipsToBounds = YES;
    return self;
}

- (IBAction)Slide_button_tap:(UIButton *)sender
{
    
   // if ([SlideDelegate respondsToSelector:@selector(action_method:)])
  //  {
        NSLog(@"##### %ld",(long)sender.tag);
        
        [SlideDelegate action_method:sender];
        
  //  }

}
@end
