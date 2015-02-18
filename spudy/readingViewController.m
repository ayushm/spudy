//
//  readingViewController.m
//  spudy
//
//  Created by Ayush Mehra on 9/6/14.
//  Copyright (c) 2014 spuds. All rights reserved.
//

#import "readingViewController.h"
#import "OSSpritzLabel.h"

@interface readingViewController () {
    OSSpritzLabel *osLabel;
    IBOutlet UILabel *wpmLabel;
    int reading;
}

@end

@implementation readingViewController

@synthesize readButton;
@synthesize wpmLabel;
@synthesize wpmSlider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    reading = 0;
    
    osLabel = [[OSSpritzLabel alloc] initWithFrame:CGRectMake(0, 175, 320.0f, 40)];
    osLabel.backgroundColor = [UIColor whiteColor];
    [osLabel setWordsPerMinute:300];
    [self.view addSubview:osLabel];
    
    osLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentText"];
    
    float defaultWpm = [[NSUserDefaults standardUserDefaults] floatForKey:@"defaultWpm"];
    
    if(defaultWpm) {
        [wpmSlider setValue:defaultWpm];
        wpmLabel.text = [NSString stringWithFormat:@"%d wpm", (int)defaultWpm];
    }
    
    
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    osLabel.text = segue.identifier;
    NSLog(@"text: %@", segue.identifier);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startReadingButtonPressed:(id)sender {
    if(reading<1) {
        [osLabel start];
        [readButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        reading = 1;
        
    }
    else {
        [osLabel pause];
        [readButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        reading = 0;
    }
    
}

- (IBAction)backButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"viewHomePage" sender:self];
}

- (IBAction)wpmSliderChanged:(UISlider *)sender {
    [osLabel setWordsPerMinute:round(sender.value)];
    wpmLabel.text = [NSString stringWithFormat:@"%d wpm",(int)sender.value];
}

- (IBAction)setAsDefaultButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setFloat:wpmSlider.value forKey:@"defaultWpm"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *successMessage = [NSString stringWithFormat:@"Set %d wpm as your default", (int)wpmSlider.value];
    UIAlertView * alrt = [[UIAlertView alloc] initWithTitle:@"Success" message:successMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alrt show];
}

- (IBAction)viewAddPostPage:(id)sender {
    [self performSegueWithIdentifier:@"viewAddPostPage" sender:self];
}
@end
