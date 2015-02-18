//
//  addPostViewController.m
//  spudy
//
//  Created by Ayush Mehra on 9/7/14.
//  Copyright (c) 2014 spuds. All rights reserved.
//

#import "addPostViewController.h"
#import <Firebase/Firebase.h>

@interface addPostViewController ()

@end

@implementation addPostViewController

@synthesize addPostClassPicker;
@synthesize addPostClassNameField;
@synthesize addPostPageField;
@synthesize addPostTextbookField;

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
    
    classList = [[NSMutableArray alloc] init];
    [classList addObject:@"Math"];
    [classList addObject:@"Chemistry"];
    [classList addObject:@"Physics"];
    [classList addObject:@"Engineering"];
    [classList addObject:@"Literature"];
    [classList addObject:@"Foreign Language"];
    [classList addObject:@"Business"];
    [classList addObject:@"Other"];
    
    [addPostClassPicker setDataSource: self];
    [addPostClassPicker setDelegate: self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addPostButtonPressed:(id)sender {
    
    NSString *subject = [classList objectAtIndex:[addPostClassPicker selectedRowInComponent:0]];
    NSString *className = addPostClassNameField.text;
    NSString *textbookName = addPostTextbookField.text;
    NSString *pageName = addPostPageField.text;
    
    if(([subject length]*[className length]*[textbookName length]*[pageName length])>0) {
        
        // Create a reference to a Firebase location
        Firebase* ref = [[Firebase alloc] initWithUrl:@"https://spudy2.firebaseio.com/"];
        // Write data to Firebase
       // [myRootRef setValue:@"Do you have data? You'll love Firebase."];
        
        
        NSString *post = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentText"];
        NSDictionary *newPost = @{
                                        @"subject" : subject,
                                        @"class": className,
                                        @"textbook": textbookName,
                                        @"page": pageName,
                                        @"post": post,
                                        @"user": @"ayush"
                                        };
        
        Firebase* postsRef = [ref childByAppendingPath: @"posts"];
        NSDictionary *posts = @{
                                @"ayush": newPost
                                };
        
        [postsRef setValue: posts];
        
        [self performSegueWithIdentifier:@"viewHomePage" sender:self];

        
        
    }
    else {
        UIAlertView * alrt = [[UIAlertView alloc] initWithTitle:@"Uh-oh" message:@"Please fill out all fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
    }
    
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"viewHomePage" sender:self];
}

// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [classList count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [classList objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSLog(@"You selected this: %@", [frequencyData objectAtIndex: row]);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




@end
