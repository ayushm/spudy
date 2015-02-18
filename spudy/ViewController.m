//
//  ViewController.m
//  spudy
//
//  Created by Ayush Mehra on 9/6/14.
//  Copyright (c) 2014 spuds. All rights reserved.
//

#import "ViewController.h"
#import "OSSpritzLabel.h"
#import <AviarySDK/AviarySDK.h>
#import "AviarySDK/AFPhotoEditorCustomization.h"



@interface ViewController ()  {
    UIImagePickerController *picker;
    UIButton *glassesImage;
    UIImageView *finalImageView;
}

@end


@implementation ViewController

@synthesize mainImageView;
@synthesize cameraGlassesButton;
@synthesize activitySpinner;
@synthesize animatedGlassesTopConstraint;
@synthesize animatedGlassesImage;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    cameraGlassesButton.hidden = YES;
    
    [AFPhotoEditorCustomization setToolOrder:@[kAFDraw]];
    
    glassPos = 25;

    
}

-(void)viewDidAppear:(BOOL)animated {
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    activitySpinner.hidden = YES;
    
    cameraGlassesButton.hidden = NO;
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    

    activitySpinner.hidden = NO;
    NSLog(@"1");
	[self dismissModalViewControllerAnimated:NO];
    NSLog(@"2");
	//mainImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *capturedImage = info[UIImagePickerControllerOriginalImage];
    NSLog(@"3");
    //[self processImage:mainImageView.image];
    NSLog(@"4");
    //[self performSegueWithIdentifier:@"viewReadingPage" sender:self];
    NSLog(@"5");
    
    [self displayEditorForImage:capturedImage];
    
    activitySpinner.hidden = YES;
}


- (void)processImage:(UIImage *)img {
    
    //UIImage *img = [self rotateImage:imageToProcess];
    
    //UIImage *img = imageToProcess;
    
    //UIImage *img = [UIImage imageNamed:@"textbook02.jpg"];
    
    //UIImage *img = [UIImage imageNamed:@"textbook02.jpg"];
    
    NSString *url = @"URL FROM WHERE TO PULL API KEY";
    
    NSData *keyData = [[NSData alloc] initWithContentsOfURL:
                     [NSURL URLWithString:url]];
    
    NSString *key = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
    
    NSString *languageCode = @"en";
    
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:key forKey:@"apikey"];
    [_params setObject:languageCode forKey:@"language"];
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"screentext.png";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* postUrl = [NSURL URLWithString:@"http://api.ocrapiservice.com/1.0/rest/ocr"];
    //NSURL* postUrl = [NSURL URLWithString:@"192.168.173.1:8080"];
    
    
    //-------------------
    // NSURL * postUrl = [NSURL URLWithString:kApiURL];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:postUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    
    // Generate message body
    NSMutableData *postData = [NSMutableData data];
    
    NSString *shortBoundary = @"---------------------------14737809831466499882746641349";
    NSString *boundary = [NSString stringWithFormat:@"--%@", shortBoundary];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", shortBoundary];
    
    // file
    //    NSData *imageData = UIImagePNGRepresentation(myImage);
    NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
    [postData appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\nContent-Disposition: form-data; name=\"image\"; filename=\"mytest.jpg\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\nContent-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:imageData];
    
    // Language parameter
    [postData appendData:[[NSString stringWithFormat:@"\r\n%@", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"language\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[languageCode dataUsingEncoding:NSUTF8StringEncoding]];
    
    // APIKey parameter
    [postData appendData:[[NSString stringWithFormat:@"\r\n%@", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"apikey\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithString:key] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Close post data
    [postData appendData:[[NSString stringWithFormat:@"\r\n%@--", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Post data information
    [serviceRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [serviceRequest setHTTPMethod:@"POST"];
    [serviceRequest setHTTPBody:postData];
    
    // Create the connection with the request
    //NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:serviceRequest delegate:self];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:serviceRequest returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSString *trimmedString = [returnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([trimmedString length] > 0) {
        
        if([trimmedString rangeOfString:@"HTTP/1.1 500 Internal Server Error"].location == NSNotFound) {
            NSLog(@"return text: %@", returnString);
            [[NSUserDefaults standardUserDefaults] setValue:returnString forKey:@"currentText"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"asdfsadfasdf");
            //[self performSegueWithIdentifier:@"viewReadingPage" sender:self];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^(void){
                [self performSegueWithIdentifier:@"viewReadingPage" sender:self];
                
            });
            
            animatedGlassesImage.hidden = YES;
            glassPos = 25;
            animatedGlassesImage.frame = CGRectMake(45, 25, 231, 72);
        }
        else {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^(void){
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hmmm" message:@"Service is temporarily unavailable. Please try again later. Sorry for the inconvenience." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                //[self performSegueWithIdentifier:@"viewHomePage" sender:self];
                [finalImageView removeFromSuperview];
                animatedGlassesImage.hidden = YES;
                glassPos = 25;
                animatedGlassesImage.frame = CGRectMake(45, 25, 231, 72);
                
            });
            
            
        }
        
        
        
    }
    else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^(void){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hmmm" message:@"Couldnt pick anything up. Make sure the text is straight and any marked over sections are done so neatly. Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            glassesImage.hidden = YES;
            finalImageView.hidden = YES;
            animatedGlassesImage.hidden = YES;
            
        });
        
        NSLog(@"reached");
        
        [self presentModalViewController:picker animated:YES];
        
    }
    
    
    
    
}
// END PROCESS IMAGE



-(NSString*)stringByTrimmingLeadingWhitespace: (NSString *)input {
    NSInteger i = 0;
    
    while ((i < [input length])
           && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[input characterAtIndex:i]]) {
        i++;
    }
    return [input substringFromIndex:i];
}




- (UIImage *)rotateImage:(UIImage*)image
{
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(M_PI/2);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    
    CGContextTranslateCTM(bitmap, rotatedSize.width, rotatedSize.height);
    
    CGContextRotateCTM(bitmap, M_PI/2);
    
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width, -image.size.height, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}



//START AVIARY


- (void)displayEditorForImage:(UIImage *)imageToEdit
{
    // kAviaryAPIKey and kAviarySecret are developer defined
    // and contain your API key and secret respectively
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [AFPhotoEditorController setAPIKey:@"f3336a22daeb0d3e" secret:@"e17651ab99d4ceb8"];
    });
    
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:imageToEdit];
    [editorController setDelegate:self];
    [self presentViewController:editorController animated:YES completion:nil];
}


- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    
    [editor dismissViewControllerAnimated:NO completion:nil];
    
    finalImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    finalImageView.image = image;
    [self.view addSubview:finalImageView];
    
    animatedGlassesImage.hidden = NO;
    [self.view bringSubviewToFront:animatedGlassesImage];
    
    
    
    
    animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                     target:self
                                   selector:@selector(animateGlasses)
                                   userInfo:nil
                                    repeats:YES];
    
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_queue_t processImageQueue = dispatch_queue_create("ProcessImage", DISPATCH_QUEUE_SERIAL);
    
    dispatch_after(popTime, processImageQueue, ^(void){
        // code to be executed on main thread
        [self processImage:image];
        
    });

    

    
    
    
    
}


- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    // Handle cancellation here
    [editor dismissViewControllerAnimated:YES completion:nil];
    
}




//END AVIARY


-(void)animateGlasses {
    if(glassPos<450) {
        glassPos+=1;
        animatedGlassesImage.frame = CGRectMake(45, glassPos, 231, 72);
    }
    else {
        [animationTimer invalidate];
        animationTimer = nil;
        glassPos = 25;
    }
    
}



-(void)oscillation:(UIImageView *)imageView{
    
    CGPoint PosA = CGPointMake(45, self.view.frame.size.height-70); //Assume Position A is at [160,50]
    CGPoint PosB = CGPointMake(45, 30); //Assume Position B is at [160,300]
    CGPoint newPos; //Define new position
    
    
    
    
    if (CGPointEqualToPoint(imageView.center, PosA)){
        newPos = PosB; //If the imageView is at Position A, set the new position at Position B
    } else if (CGPointEqualToPoint(imageView.center, PosB)){
        newPos = PosA; //If the imageView is at Position B, set the new position at Position A
    }
    
    //Animate the imageView to move to the new position and take 2 seconds to do it. Once done, call the oscillation method again
    NSLog(@"animation");
    [UIView animateWithDuration:2.5 animations:^{
        imageView.center = newPos;
    } completion:^(BOOL finished) {
        [self oscillation: imageView];
    }];
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cameraGlassesButtonPressed:(id)sender {
    
    [self presentModalViewController:picker animated:YES];
    //[picker takePicture];
   // [picker dismissModalViewControllerAnimated:YES];
    
    
}
- (IBAction)viewPersonalPageButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"viewPersonalPage" sender:self];
}
@end
