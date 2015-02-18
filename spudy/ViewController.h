//
//  ViewController.h
//  spudy
//
//  Created by Ayush Mehra on 9/6/14.
//  Copyright (c) 2014 spuds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UIView *vImagePreview;
    int glassPos;
    NSTimer *animationTimer;
}
@property(nonatomic, retain) IBOutlet UIView *vImagePreview;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UIButton *cameraGlassesButton;
- (IBAction)cameraGlassesButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;

@property (strong, nonatomic) IBOutlet UIImageView *animatedGlassesImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *animatedGlassesBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *animatedGlassesTopConstraint;

@end
