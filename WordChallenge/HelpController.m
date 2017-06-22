//
//  HelpController.m
//  WordChallenge
//
//  Created by Nguyen on 10/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HelpController.h"
#import "WordChallengeAppDelegate.h"

@implementation HelpController

@synthesize buttonBack;


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
	NSLog(@"HelpScreen dealloc()");
//	[self.buttonBack release];
	self.buttonBack = nil;
    [super dealloc];
}


- (IBAction) back {
	UIAppDelegate
	
	// Initialize the end game screen
	[app initXibScreen: START_SCREEN];
	[app viewTransition: [app addressOf_viewHelpScreen]: [app addressOf_viewStartScreen]: true];
}

@end
