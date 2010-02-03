//
//  iTwinkleViewController.m
//  iTwinkle
//
//  Created by Seth Raphael on 1/31/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "iTwinkleViewController.h"
#import <QuartzCore/QuartzCore.h>

extern  CGImageRef UIGetScreenImage();

@implementation iTwinkleViewController

@synthesize overview, imgView, thebutton, colors, colorpicker, currentColor;
@synthesize player, theframe, bgImage, toolbar; 


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		
	radius = 10; 
	numnotes = 20;
	muted = NO;
	hsvDistance = NO;
	samplepoint = CGPointMake(150, 150);
	
	
	colors = [[NSMutableArray alloc] init];
	for (int i = 0; i < numnotes; i++) {
		[colors addObject:[UIColor clearColor]];
	}
	
	[self setupView];

	NSTimer * timer;
//	timer = [NSTimer scheduledTimerWithTimeInterval: 0.01
//											 target: self
//										   selector: @selector(showCamera)
//										   userInfo: nil
//											repeats: NO];	
	timer = [NSTimer scheduledTimerWithTimeInterval: 0.5
											 target: self
										   selector: @selector(screenshot:)
										   userInfo: nil
											repeats: NO];
}

-(void) setButtonColor:(UIButton *)sender {
	[sender setBackgroundColor:colorpicker.backgroundColor];
	[colors replaceObjectAtIndex:(sender.tag - 100) withObject:sender.backgroundColor];
}

- (void) setupView {
	[self resize];
	int buttonwidth = 70;
	float buttonheight = 42;
	float spacebetween = 14.3;
	int yoffset = 0;
	NSArray * notes =  [NSArray arrayWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"notes.plist"]];
	for (int i = 0; i< 8; i++) {
		
		UIButton * pusher = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:CGRectMake(260, i*(buttonheight + spacebetween) + yoffset,buttonwidth, buttonheight)];
		[pusher setTitle:[notes objectAtIndex:i] forState:UIControlStateNormal];
		[pusher addTarget:self action:@selector(setButtonColor:) forControlEvents:UIControlEventTouchUpInside];
		[overview addSubview:pusher];
		[pusher setTag:100+i];
		[pusher setBackgroundColor:[UIColor whiteColor]];
		[pusher setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		//		[pusher setBackgroundColor:[UIColor lightGrayColor]];
		CALayer * l = [pusher layer];
		[l setMasksToBounds:YES];
		[l setCornerRadius:10.0];
		
		// You can even add a border
		[l setBorderWidth:1.0];
		[l setBorderColor:[[UIColor blackColor] CGColor]];
		
		
	}
	
	for (int i = 0; i< 6; i++) {
		
		UIButton * pusher = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:CGRectMake(295, (i+0.5)*(buttonheight + spacebetween) + yoffset ,buttonwidth, buttonheight)];
		[pusher setTitle:[notes objectAtIndex:i] forState:UIControlStateNormal];
		[pusher addTarget:self action:@selector(setButtonColor:) forControlEvents:UIControlEventTouchUpInside];
		if (i != 2) [overview addSubview:pusher];
		[pusher setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[pusher setBackgroundColor:[UIColor blackColor]];

		[pusher setTag:107+i];
		//		[pusher setBackgroundColor:[UIColor lightGrayColor]];
		CALayer * l = [pusher layer];
		[l setMasksToBounds:YES];
		[l setCornerRadius:10.0];
		
		// You can even add a border
		[l setBorderWidth:1.0];
		[l setBorderColor:[[UIColor blackColor] CGColor]];
	}
}

- (IBAction) loadPhoto:(id) sender {
	UIActionSheet * actionsheet = [[UIActionSheet alloc] initWithTitle:@"Load Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Album", @"From Camera", @"Live View", nil];
	[actionsheet showFromToolbar:toolbar];
	[actionsheet release];
}
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
		if (buttonIndex == 0) {
			[self pickImage];
		} else if (buttonIndex == 1) {
			[self showCamera];
		} else if (buttonIndex == 2) {
			[self showLiveCamera];
		}
}


- (void) pickImage {
	[imagePickerController dismissModalViewControllerAnimated:NO];
	[bgImage setAlpha:0];
	[overview setFrame:CGRectMake(0, 0, 320, 480)];
	[self.view addSubview:overview];
	imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
	imagePickerController.delegate = self;
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:imagePickerController animated:YES];
	
}
- (void) showCamera {
	[imagePickerController dismissModalViewControllerAnimated:NO];
	[bgImage setAlpha:0];
	[overview setFrame:CGRectMake(0, 0, 320, 480)];
	[self.view addSubview:overview];
	imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
	imagePickerController.delegate = self;
	imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:imagePickerController animated:YES];
}
-(void) showLiveCamera {
	[imagePickerController dismissModalViewControllerAnimated:YES];
	[bgImage setAlpha:0];
	[overview setFrame:CGRectMake(0, -10, 320, 480)];
	imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
	imagePickerController.delegate = self;
	imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	[imagePickerController setShowsCameraControls:NO];
	[imagePickerController setCameraOverlayView:overview];
	[imagePickerController setCameraViewTransform:CGAffineTransformTranslate(CGAffineTransformMakeScale(1.1, 1.1), 100, 100)];

	[self presentModalViewController:imagePickerController animated:YES];	
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
	UIImage *newImage = [UIImage imageWithData:imageData];
	[newImage retain];
	if (imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
		UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
	}
	[bgImage setImage:newImage];
	[bgImage setAlpha:1];

	[imagePickerController dismissModalViewControllerAnimated:YES];
}

-(void) resize {
	[theframe setFrame:CGRectMake(samplepoint.x-1, samplepoint.y-1, radius+2, radius+2)];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint newpoint = [[touches anyObject] locationInView:self.view];
	newpoint.y=newpoint.y - 40;
	samplepoint = newpoint;
	[self resize];
	[player stop];
	playingsound = -1;
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint newpoint = [[touches anyObject] locationInView:self.view];
	newpoint.y=newpoint.y - 40;
	samplepoint = newpoint;
	[self resize];

}


-(void) playSound:(int)i {
	if (playingsound == i || muted || i >6) {
		return;//keep on playing the sound.
	}
	if (playingsound != -1) {// let's switch sounds.
		[player stop];
	}
	playingsound = i;
	NSArray * soundfiles = [NSArray arrayWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"wavfiles.plist"]];
	NSString *soundFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[soundfiles objectAtIndex:i]];
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];

	AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
	[fileURL release];
	
	self.player = newPlayer;
	
	[newPlayer release];

	[player prepareToPlay];
	[player play];
	[player setDelegate: self];	
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	playingsound = -1; // we're done
}

CFDataRef CopyImagePixels(CGImageRef inImage)
{
    return CGDataProviderCopyData(CGImageGetDataProvider(inImage));
}

-(IBAction) toggleView:(UISegmentedControl*) sender {
	if ([sender selectedSegmentIndex] == 0) {
		[bgImage setAlpha:0.0];
	} else {
		[bgImage setAlpha:1.0];
	}
}

-(IBAction) toggleDistance:(UIBarButtonItem*) sender {
	hsvDistance = !hsvDistance;
	if (hsvDistance) {
		[sender setStyle:UIBarButtonItemStyleDone];
	} else {
		[sender setStyle:UIBarButtonItemStyleBordered];
	}
}

-(IBAction) mute:(UIBarButtonItem*) sender {
	muted = !muted;
	if (muted) {
		[sender setImage:[UIImage imageNamed:@"muted.png"]];
		[sender setStyle:UIBarButtonItemStyleDone];
		[player stop];
	} else {
		[sender setImage:[UIImage imageNamed:@"65-note.png"]];
		[sender setStyle:UIBarButtonItemStyleBordered];
	}
}

-(void) screenshot: (NSTimer*)timer {
	CGImageRef screenshot = UIGetScreenImage();
	
	CFDataRef imgDataRef = CopyImagePixels(screenshot);
	if (imgDataRef) {
		const UInt8 * screenshotData = CFDataGetBytePtr(imgDataRef);
		
		int BPR = CGImageGetBytesPerRow(screenshot);
			
		int rtotal=0;
		int gtotal=0;
		int btotal=0;
		int numpixels = 0;
		// average all of the pixels in a sqaure, centered at samplepoint	
		int xoffset = samplepoint.x;
		int yoffset = samplepoint.y;
		for ( int x = 0; x < radius; x++ ) {
			for (int y = 0; y< radius; y++) {
				if (x+xoffset >0 && y+yoffset>0){//minimal bounds checking
					int pixel = (x+xoffset)*4 + (y+yoffset)*BPR;
					btotal += screenshotData[pixel];
					gtotal += screenshotData[pixel + 1];
					rtotal += screenshotData[pixel + 2];
					numpixels++;
				}
			}
		}
		CGFloat r = rtotal / numpixels;
		CGFloat g = gtotal / numpixels;
		CGFloat b = btotal / numpixels;

		currentColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
		
		CALayer * l = [theframe layer];
		
		[l setBorderColor:[[UIColor blackColor] CGColor]];

		[l setBorderWidth:1.0];

		float bestdistance = 9999999;
		int matchingcolorindex = 100;
		bestdistance = [self colorDistanceFrom:currentColor To:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
		for (int i =0; i<numnotes; i++) {
			float thisdist;
			if (hsvDistance)
				thisdist = [self HSVDistanceFrom:currentColor To:[colors objectAtIndex:i]];
			else
				thisdist= [self colorDistanceFrom:currentColor To:[colors objectAtIndex:i]];
			
			if (thisdist < bestdistance && CGColorGetAlpha([[colors objectAtIndex:i] CGColor])) {
				bestdistance = thisdist;
				matchingcolorindex = i;
			}
		}
		NSLog(@"best difference is %f", bestdistance);

		for (int i = 0; i< numnotes; i++ ) {
			if (i==matchingcolorindex) {
				[[overview viewWithTag:100+i] setTransform:CGAffineTransformMakeScale(1.5, 1.5)] ;
				[self playSound:i];
			} else {
				[[overview viewWithTag:100+i] setTransform:CGAffineTransformMakeScale(1.0, 1.0)] ;
			}	
		}
		if (matchingcolorindex == 100) [player stop];
		[colorpicker setBackgroundColor:currentColor];
		
		CFRelease(imgDataRef);
		CFRelease(screenshot);
		
		timer = [NSTimer scheduledTimerWithTimeInterval: 0.01
												 target: self
											   selector: @selector(screenshot:)
											   userInfo: nil
												repeats: NO];
		
	}
	
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissModalViewControllerAnimated:YES];
}

- (float) colorDistanceFrom:(UIColor*)from To:(UIColor*)to {
	const float * fromComponents = CGColorGetComponents(from.CGColor);
	const float * toComponents = CGColorGetComponents(to.CGColor);
	
	float xdiff = fromComponents[0] - toComponents[0];
	float ydiff = fromComponents[1] - toComponents[1];
	float zdiff = fromComponents[2] - toComponents[2];
	float adiff = fromComponents[3] - toComponents[3];
	
	float total = pow(xdiff*255, 2) + pow(ydiff*255, 2) + pow(zdiff*255, 2) + pow(adiff*255, 2);
	return total;
	
}

- (float) HSVDistanceFrom:(UIColor*)from To:(UIColor*)to {
	const float * fromComponents = CGColorGetComponents(from.CGColor);
	const float * toComponents = CGColorGetComponents(to.CGColor);
	
	float fH, fS, fV;// From HSV values
	RGBtoHSV(fromComponents[2],fromComponents[1],fromComponents[0], &fH, &fS, &fV);

	float tH, tS, tV;// To HSV values
	RGBtoHSV(toComponents[2],toComponents[1],toComponents[0], &tH, &tS, &tV);
	
	fH = fH/360.0; //normalize
	tH = tH/360.0; //normalize
	
	float xdiff = (fS * cos(2* M_PI * fH) - tS * cos(2* M_PI * tH));
	
	float ydiff = (fS * sin(2 * M_PI * fH) - tS * sin(2 * M_PI * tH));
	

	
	float total = pow(xdiff, 2) + pow(ydiff*255, 2);
	return total;
	
}

// r,g,b values are from 0 to 1
// h = [0,360], s = [0,1], v = [0,1]
//		if s == 0, then h = -1 (undefined)

void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
	float min, max, delta;
	
	min = MIN( r, MIN(g, b) );
	max = MAX( r, MAX(g, b) );
	*v = max;				// v
	
	delta = max - min;
	
	if( max != 0 )
		*s = delta / max;		// s
	else {
		// r = g = b = 0		// s = 0, v is undefined
		*s = 0;
		*h = -1;
		return;
	}
	
	if( r == max )
		*h = ( g - b ) / delta;		// between yellow & magenta
	else if( g == max )
		*h = 2 + ( b - r ) / delta;	// between cyan & yellow
	else
		*h = 4 + ( r - g ) / delta;	// between magenta & cyan
	
	*h *= 60;				// degrees
	if( *h < 0 )
		*h += 360;
	
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (IBAction) radiusSliderMoved:(UISlider*)sender {
	float newval = [sender value];
	radius = floor(newval);
	[self resize];
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
