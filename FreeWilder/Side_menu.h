//
//  Side_menu.h
//  FreeWilder
//
//  Created by Rahul Singha Roy on 27/05/15.
//  Copyright (c) 2015 Esolz Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Slide_menu_delegate<NSObject>
@optional
-(void)action_method:(UIButton *)sender;
@end

@interface Side_menu : UIView

- (IBAction)Slide_button_tap:(UIButton *)sender;

@property(assign)id<Slide_menu_delegate>SlideDelegate;
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;


@end
