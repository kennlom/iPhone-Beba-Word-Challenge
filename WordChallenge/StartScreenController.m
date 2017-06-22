//
//  StartScreenController.m
//  WordChallenge
//
//  Created by Nguyen on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StartScreenController.h"
#import "WordChallengeAppDelegate.h"

@implementation StartScreenController

@synthesize buttonOLogo;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//[NSTimer scheduledTimerWithTimeInterval: 1.2 target:self selector:@selector(logoClicked) userInfo:nil repeats:NO];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	NSLog(@"StartScreen dealloc()");
	self.buttonOLogo		= nil;

    [super dealloc];
}


/*`
 ` This function allows us to switch active views dynamically with ui animation applied
 ` viewFadeIn: The view to fade in, alpha 0.0
 ` viewFadeOut: The view to fade out to the screen, alpha 1.0
 ` removeFromSuperView: boolean value, remove the FadeIn view from the superview
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) StartGame_Clicked:(id) sender {
	NSLog(@"Starting Game");
	UIAppDelegate
	
	[app initXibScreen: GAME_MODE_SCREEN];
	[app viewTransition: [app addressOf_viewStartScreen]: [app addressOf_viewGameModeScreen]: true];
}

/*`
 ` This is only a fun feature implemented. We should spin the logo to create an animation
 ` effect and display a random funny quote to the player for their amusement.
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) logoClicked {
	//NSLog(@"Clicked on the logo!");
	
	CGAffineTransform transform;
	transform = CGAffineTransformMakeScale(0.1, 0.1);
	self.buttonOLogo.transform = transform;
	[self.buttonOLogo setHidden: false];
	
	// Randomly tilt the button to create a hard level effect
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration: 0.5]; // Number of seconds for animation	
	transform = CGAffineTransformMakeScale(1.0, 1.0);
	self.buttonOLogo.transform = transform;	
	[UIView commitAnimations];
}

/*`
 ` Shows the game help screen
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) help {
	UIAppDelegate
	
	// Initialize the end game screen
	[app initXibScreen: HELP_SCREEN];
	[app viewTransition: [app addressOf_viewStartScreen]: [app addressOf_viewHelpScreen]: true];
}

/*`
 ` Shows the top score screen
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) gotoTopScore {
	UIAppDelegate

	// Initialize the end game screen
	[app initXibScreen: TOP_SCORE_SCREEN];
	[app viewTransition: [app addressOf_viewStartScreen]: [app addressOf_viewTopScoreScreen]: false];
}







@end