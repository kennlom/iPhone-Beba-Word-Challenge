//
//  EndGameController.m
//  WordChallenge
//
//  Created by Nguyen on 9/25/09.
//  Copyright 2009 Beba, Inc. All rights reserved.
//

#import "EndGameController.h"
#import "WordChallengeAppDelegate.h"

@implementation EndGameController

@synthesize labelPlayerScore, labelGameLevel, labelGameMode, labelWordsFound, labelWordsMissed, labelWordsSkipped, labelBonusWords, labelWordsCompleted;
@synthesize labelCustomMessage;
@synthesize labelEndTitle;

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
	UIAppDelegate
	
	int gameModeId = [[global_lastGameData objectForKey:GAME_DATA_GAME_MODE] intValue];
	if(gameModeId == TIME_CHALLENGE) {
		// Get random loser message and display that to the player
		[self.labelCustomMessage setText:@"Post your score online now to see how well you rank."];

		[buttonPostScore		setHidden:false];
		[buttonTopScore			setHidden:false];
		[labelEndTitle			setText:@"Time's up!"];
		[self.labelGameLevel	setText:@"n/a"];
	}
	else {
		[self.labelGameLevel	setText: StringFromInt([[global_lastGameData objectForKey:GAME_DATA_GAME_LEVEL] intValue])  ];
		// Get random loser message and display that to the player
		[self.labelCustomMessage setText:[app getRandomLoserMessage]];
	}
	
	// Update the player stats
	[self.labelPlayerScore	setText: StringFromInt([[global_lastGameData objectForKey:GAME_DATA_PLAYER_SCORE] intValue])  ];
	[self.labelWordsFound	setText: StringFromInt([[global_lastGameData objectForKey:GAME_DATA_WORDS_FOUND] intValue])  ];
	[self.labelBonusWords	setText: StringFromInt([[global_lastGameData objectForKey:GAME_DATA_BONUS_WORDS] intValue])  ];
	[self.labelWordsMissed	setText: StringFromInt([[global_lastGameData objectForKey:GAME_DATA_WORDS_MISSED] intValue])  ];
	[self.labelWordsSkipped	setText: StringFromInt([[global_lastGameData objectForKey:GAME_DATA_WORDS_SKIPPED] intValue])  ];
	[self.labelGameMode		setText: GameModeFromId(gameModeId)];
	[labelWordsCompleted	setText: StringFromInt([[global_lastGameData objectForKey:GAME_DATA_WORDS_COMPLETED] intValue])  ];

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
	NSLog(@"EndGame dealloc()");
	
	self.labelEndTitle			= nil;
	self.labelWordsCompleted	= nil;
	self.labelCustomMessage		= nil;
	self.labelPlayerScore		= nil;
	self.labelGameMode			= nil;
	self.labelGameLevel			= nil;
	self.labelWordsFound		= nil;
	self.labelWordsMissed		= nil;
	self.labelWordsSkipped		= nil;
	self.labelBonusWords		= nil;
    [super dealloc];
}


/*`
 ` Go back to start screen
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) goBackToStartScreen {
	UIAppDelegate
	
	// Initialize the end game screen
	[app initXibScreen: START_SCREEN];
	[app viewTransition: [app addressOf_viewEndScreen]: [app addressOf_viewStartScreen]: true];
}

/*`
 ` Shows the top score screen
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) gotoTopScore {
	UIAppDelegate
	
	// Initialize the end game screen
	[app initXibScreen: TOP_SCORE_SCREEN];
	
	[app.viewTopScoreScreen setAddressOfPreviousView: [app addressOf_viewEndScreen]];
	[app viewTransition: [app addressOf_viewEndScreen]: [app addressOf_viewTopScoreScreen]: false];
}

/*`
 ` Post score online
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) postScoreOnline {
	UIAppDelegate
	
	// Initialize the end game screen
	[app initXibScreen: POST_SCORE_SCREEN];
	[app viewTransition: [app addressOf_viewEndScreen]: [app addressOf_viewPostScoreScreen]: false];
}










/*


- (IBAction) test {
	UIAppDelegate
// Prompt the player that he/she didn't make it to the next level
NSString *textMessage = [app getRandomWinnerMessage];
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps!" message:textMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//	[alert show];
//	[alert release];

// Initialize the end game screen
//[app initXibScreen: END_GAME_SCREEN];
	[labelCustomMessage setText:textMessage];
	
	
	NSDate *test = [NSDate date];
	NSLog(GetDBDateFormatForDate(test));
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	
	
	
	NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:118800];
	
	
	
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	
	[dateFormatter setLocale:usLocale];
	
	
	
	NSLog(@"Date for locale %@: %@",
		  
		  [[dateFormatter locale] localeIdentifier], [dateFormatter stringFromDate:date]);
	
	// Output:
	
	// Date for locale en_US: Jan 2, 2001
	
	
	
	NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
	
	[dateFormatter setLocale:frLocale];
	
	NSLog(@"Date for locale %@: %@",
		  
		  [[dateFormatter locale] localeIdentifier], [dateFormatter stringFromDate:date]);
	
	// Output:
	
	// Date for locale fr_FR: 2 janv. 2001
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	[dateFormatter setDateFormat:@"MM/dd/yyyy hh:mma"];

	date = [NSDate dateWithTimeIntervalSinceNow:0];
	NSLog( [dateFormatter stringFromDate:date] );
	
	
}
*/


@end