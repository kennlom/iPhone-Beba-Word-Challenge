//
//  GameModeController.m
//  WordChallenge
//
//  Created by Nguyen on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameModeController.h"
#import "WordChallengeAppDelegate.h"

@implementation GameModeController

@synthesize buttonContinueGame;



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
	NSLog(@"GameMode dealloc()");
	self.buttonContinueGame = nil;
    [super dealloc];
}



/*`
 ` Continue saved game
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) continueSavedGame {
	NSLog(@"Continue saved game");
	
	
	UIAppDelegate
	[app initXibScreen: SAVED_GAME_SCREEN];
	[app viewTransition: [app addressOf_viewGameModeScreen]: [app addressOf_viewSavedGameScreen]: true];
}


/*`
 ` Start game
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) startGame: (id) sender {
	int tag = [sender tag];
	
	UIAppDelegate
	[app initXibScreen: GAME_SCREEN];
	
	switch(tag) {
		case 1:	[app.viewGameScreen initGame: EASY];			break;
		case 2:	[app.viewGameScreen initGame: NORMAL];			break;
		case 3:	[app.viewGameScreen initGame: HARD];			break;
		case 4:	[app.viewGameScreen initGame: TIME_CHALLENGE];	break;
	}
	
	[app viewTransition: [app addressOf_viewGameModeScreen]: [app addressOf_viewGameScreen]: true];
	[app.viewGameScreen initGameLevel: 1];
}

/*`
 ` Go back to start screen
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) goBackToStartScreen {
	UIAppDelegate

	// Switch back to the start screen and release this xib from memory
	[app initXibScreen:START_SCREEN];
	[app viewTransition: [app addressOf_viewGameModeScreen]: [app addressOf_viewStartScreen]: true];
}


@end