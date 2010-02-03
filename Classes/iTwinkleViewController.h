//
//  iTwinkleViewController.h
//  iTwinkle
//
//  Created by Seth Raphael on 1/31/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface iTwinkleViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate, UIActionSheetDelegate> {
	UIImagePickerController* imagePickerController;
	UIView *overview, * colorpicker;
	UIImageView *imgView;
	UIButton *thebutton;
	NSMutableArray *colors;
	int numnotes;
	UIColor * currentColor;
	AVAudioPlayer * player;
	int playingsound;
	BOOL muted;
	UIImageView * theframe;
	CGPoint samplepoint;
	UIImageView * bgImage;
	BOOL hsvDistance;
	int radius;
	UIToolbar * toolbar;

}
-(void) setButtonColor:(UIButton *)sender;
- (float) colorDistanceFrom:(UIColor*)from To:(UIColor*)to;


@property (nonatomic, retain) IBOutlet UIImageView * theframe;
@property (nonatomic, retain) IBOutlet UIImageView * bgImage;
@property (nonatomic, retain) NSMutableArray * colors;
@property (nonatomic, retain) AVAudioPlayer * player;
@property (nonatomic, retain) IBOutlet UIView * overview;
@property (nonatomic, retain) IBOutlet UIView * colorpicker;
@property (nonatomic, retain) UIColor * currentColor;
@property (nonatomic, retain) IBOutlet UIImageView * imgView;
@property (nonatomic, retain) IBOutlet UIButton * thebutton;
@property (nonatomic, retain) IBOutlet UIToolbar * toolbar;
- (IBAction) showCamera;
-(IBAction) showLiveCamera;
-(IBAction) mute:(UIBarButtonItem *) sender;
-(IBAction) toggleDistance:(UIBarButtonItem *) sender;
-(IBAction) toggleView:(UISegmentedControl*) sender;
-(IBAction) radiusSliderMoved:(UISlider*)sender;
-(IBAction) loadPhoto:(id) sender;
- (void) pickImage;
- (void) setupView;
-(void) resize;


void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v );
- (float) HSVDistanceFrom:(UIColor*)from To:(UIColor*)to;

@end

