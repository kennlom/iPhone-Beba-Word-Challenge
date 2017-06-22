//
//  WinnerController.m
//  WordChallenge
//
//  Created by Nguyen on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WinnerController.h"
#import "WordChallengeAppDelegate.h"

@implementation WinnerController

@synthesize labelScore, labelCompleted;
@synthesize timerPlayLoop;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
//	UIAppDelegate
//	[app playSoundEffect:SOUND_FX_AMBIENTAL];
//	timerPlayLoop = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(playLoopedSound) userInfo:nil repeats:YES];
	[self playLoopedSound];
}


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
	NSLog(@"Winner dealloc()");
	self.labelScore		= nil;
	self.labelCompleted	= nil;
	[audioPlayer release];
    [super dealloc];
}

- (void) playLoopedSound {
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"ambiental" ofType:@"mp3"];
	audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:NULL] retain];	
	audioPlayer.numberOfLoops = -1; 
	audioPlayer.delegate = self;
	[audioPlayer play];

}

/*`
 ` Go back to start screen
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) goBackToStartScreen {
	UIAppDelegate
	
	[audioPlayer stop];
	
	// Switch back to the start screen and release this xib from memory
	[app initXibScreen:START_SCREEN];
	[app viewTransition: [app addressOf_viewWinnerScreen]: [app addressOf_viewStartScreen]: true];
}

@end
