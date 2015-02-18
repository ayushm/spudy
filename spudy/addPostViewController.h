//
//  addPostViewController.h
//  spudy
//
//  Created by Ayush Mehra on 9/7/14.
//  Copyright (c) 2014 spuds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addPostViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    NSMutableArray *classList;
}
@property (strong, nonatomic) IBOutlet UIPickerView *addPostClassPicker;
@property (strong, nonatomic) IBOutlet UITextField *addPostClassNameField;
@property (strong, nonatomic) IBOutlet UITextField *addPostTextbookField;
@property (strong, nonatomic) IBOutlet UITextField *addPostPageField;
- (IBAction)addPostButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
