//
//  readingViewController.h
//  spudy
//
//  Created by Ayush Mehra on 9/6/14.
//  Copyright (c) 2014 spuds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface readingViewController : UIViewController
- (IBAction)startReadingButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *readButton;
@property (strong, nonatomic) IBOutlet UILabel *wpmLabel;
@property (strong, nonatomic) IBOutlet UISlider *wpmSlider;
- (IBAction)wpmSliderChanged:(UISlider *)sender;
- (IBAction)setAsDefaultButtonPressed:(id)sender;
- (IBAction)viewAddPostPage:(id)sender;

@end
