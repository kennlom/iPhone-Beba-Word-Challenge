//
//  PausedController.m
//  WordChallenge
//
//  Created by Nguyen on 10/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PausedController.h"
#import "WordChallengeAppDelegate.h"

@implementation PausedController

@synthesize labelFoundWord6, labelFoundWord5, labelFoundWord4, labelFoundWord3, labelWordsRemaining, labelGamePaused, labelGameRunning;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
	NSLog(@"Paused dealloc()");
	self.labelFoundWord6		= nil;
	self.labelFoundWord5		= nil;
	self.labelFoundWord4		= nil;
	self.labelFoundWord3		= nil;
	self.labelWordsRemaining	= nil;
	self.labelGamePaused		= nil;
	self.labelGameRunning		= nil;
    [super dealloc];
}


- (IBAction) resumeGame {
	UIAppDelegate
	[app.viewGameScreen resumeGame];
	[app viewTransition: [app addressOf_viewPausedScreen]: [app addressOf_viewGameScreen]: true];
}

- (IBAction) back {
	UIAppDelegate

	UIViewController **viewPointer;
	UIViewController *view;
	// Initialize the end game screen
	[app initXibScreen: START_SCREEN];
	[app.viewGameScreen quitGame];
	[app.viewGameScreen.view removeFromSuperview];
	viewPointer = [app addressOf_viewGameScreen];
	view = *viewPointer;
	[view release];
	*viewPointer = nil;
	
	[app viewTransition: [app addressOf_viewPausedScreen]: [app addressOf_viewStartScreen]: true];
}

@end
