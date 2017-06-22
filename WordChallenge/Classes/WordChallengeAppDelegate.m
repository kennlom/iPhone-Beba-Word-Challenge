//
//  WordChallengeAppDelegate.m
//  WordChallenge
//
//  Created by Nguyen on 9/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "WordChallengeAppDelegate.h"

@implementation WordChallengeAppDelegate

@synthesize window;
@synthesize viewIntroScreen, viewStartScreen, viewGameScreen, viewEndScreen, viewNextLevelScreen, viewGameModeScreen, viewSavedGameScreen;
@synthesize viewHelpScreen, viewTopScoreScreen, viewPostScoreScreen, viewPausedScreen, viewWinnerScreen;
@synthesize soundEffectTouch, soundEffectSpin, soundEffectScore, soundEffectBonus, soundEffectTime, soundEffectLost, soundEffectAmbiental;
//@synthesize lastAcceleration;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
//	NSLog(@"Application Launching");
	
//	[UIAccelerometer sharedAccelerometer].delegate = self;
	
	// Initialize new last game data object
	global_lastGameData = [NSMutableDictionary new];
	
	[application setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
	
	// Create a new instance of the Intro Screen object
	[self initXibScreen: INTRO_SCREEN];
	
    // Override point for customization after application launch
	[window addSubview: [self.viewIntroScreen view]];
    [window makeKeyAndVisible];

	// Load the start screen after displaying the splash intro screen
	// Note: maybe we should load the screen with alpha of 0 then activate timer so the object is already loaded when
	// we displayed it, that way the user doesn't have to wait again for the object to load
	[self initXibScreen: START_SCREEN];	
	[NSTimer scheduledTimerWithTimeInterval: 0.4 target:self selector:@selector(switchToStartScreen) userInfo:nil repeats:NO];
}


- (void)dealloc {
	[viewIntroScreen release];
	[viewStartScreen release];
	[viewGameScreen release];
	
    [window release];
    [super dealloc];
}


/*`
 ` Object references
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (id *) addressOf_viewIntroScreen		{ return &viewIntroScreen; }
- (id *) addressOf_viewStartScreen		{ return &viewStartScreen; }
- (id *) addressOf_viewGameScreen		{ return &viewGameScreen; }
- (id *) addressOf_viewEndScreen		{ return &viewEndScreen; }
- (id *) addressOf_viewNextLevelScreen	{ return &viewNextLevelScreen; }
- (id *) addressOf_viewSavedGameScreen	{ return &viewSavedGameScreen; }
- (id *) addressOf_viewGameModeScreen	{ return &viewGameModeScreen; }
- (id *) addressOf_viewHelpScreen		{ return &viewHelpScreen; }
- (id *) addressOf_viewTopScoreScreen	{ return &viewTopScoreScreen; }
- (id *) addressOf_viewPostScoreScreen	{ return &viewPostScoreScreen; }
- (id *) addressOf_viewPausedScreen		{ return &viewPausedScreen; }
- (id *) addressOf_viewWinnerScreen		{ return &viewWinnerScreen; }

/*`
 ` Delayed trigger call, switch from intro to start screen
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) switchToStartScreen {
	[self viewTransition: [self addressOf_viewIntroScreen]: [self addressOf_viewStartScreen]: true];
}


/*`
 ` This function allows us to switch active views dynamically with ui animation applied
 ` viewFadeIn: The view to fade in, alpha 0.0
 ` viewFadeOut: The view to fade out to the screen, alpha 1.0
 ` removeFromSuperView: boolean value, remove the FadeIn view from the superview
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) initXibScreen: (int) nibId {
	NSLog(@"initXibScreen()");
	CGRect frame;
	
	switch (nibId) {
		case INTRO_SCREEN: {
			if(viewIntroScreen) return;
			NSLog(@"Creating viewIntroScreen");
			
			IntroScreenController *view = [[IntroScreenController alloc] initWithNibName:@"Intro" bundle:nil];
			frame = view.view.frame;
			frame.size.width = 320;
			frame.size.height = 480;
			frame.origin.x	= 0;
			frame.origin.y	= 0;
			view.view.frame = frame;
			
			self.viewIntroScreen = view;
			[view release];
		} break;
			
		case START_SCREEN: {
			if(viewStartScreen) return;
			NSLog(@"Creating viewStartScreen");
			
			StartScreenController *view = [[StartScreenController alloc] initWithNibName:@"Start" bundle:nil];
			frame = view.view.frame;
			frame.size.width = 480;
			frame.size.height = 320;
			frame.origin.x	= 0;
			frame.origin.y	= 0;
			view.view.frame = frame;
			
			self.viewStartScreen = view;
			[view release];
			
			CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
			rotate = CGAffineTransformTranslate (rotate, 80.0, 80.0);
			self.viewStartScreen.view.transform  = rotate;
		} break;
			
		case GAME_SCREEN: {
			if(viewGameScreen) return;
			NSLog(@"Creating viewGameScreen");
			
			GameScreenController *view = [[GameScreenController alloc] initWithNibName:@"Game" bundle:nil];
			frame = view.view.frame;
			frame.size.width = 480;
			frame.size.height = 320;
			frame.origin.x	= 0;
			frame.origin.y	= 0;
			view.view.frame = frame;
			
			self.viewGameScreen = view;
			[view release];
			
			CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
			rotate = CGAffineTransformTranslate (rotate, 80.0, 80.0);
			self.viewGameScreen.view.transform  = rotate;
		} break;
			
		case END_GAME_SCREEN: {
			if(viewEndScreen) return;
			NSLog(@"Creating viewEndScreen");
			
			EndGameController *view = [[EndGameController alloc] initWithNibName:@"EndGame" bundle:nil];
			frame = view.view.frame;
			frame.size.width = 480;
			frame.size.height = 320;
			frame.origin.x	= 0;
			frame.origin.y	= 0;
			view.view.frame = frame;
			
			self.viewEndScreen = view;
			[view release];
			
			CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
			rotate = CGAffineTransformTranslate (rotate, 80.0, 80.0);
			self.viewEndScreen.view.transform  = rotate;
		} break;
			
		case NEXT_LEVEL_SCREEN: {
			if(viewNextLevelScreen) return;
			NSLog(@"Creating viewNextLevelScreen");
			
			NextLevelController *view = [[NextLevelController alloc] initWithNibName:@"NextLevel" bundle:nil];
			frame = view.view.frame;
			frame.size.width = 480;
			frame.size.height = 320;
			frame.origin.x	= 0;
			frame.origin.y	= 0;
			view.view.frame = frame;
			
			self.viewNextLevelScreen = view;
			[view release];
			
			CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
			rotate = CGAffineTransformTranslate (rotate, 80.0, 80.0);
			self.viewNextLevelScreen.view.transform  = rotate;
		} break;
			
		case GAME_MODE_SCREEN: {
			if(viewGameModeScreen) return;
			NSLog(@"Creating viewGameModeScreen");
			
			GameModeController *view = [[GameModeController alloc] initWithNibName:@"GameMode" bundle:nil];
			frame = view.view.frame;
			frame.size.width = 480;
			frame.size.height = 320;
			frame.origin.x	= 0;
			frame.origin.y	= 0;
			view.view.frame = frame;
			
			self.viewGameModeScreen = view;
			[view release];
			
			CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
			rotate = CGAffineTransformTranslate (rotate, 80.0, 80.0);
			self.viewGameModeScreen.view.transform  = rotate;
		} break;
			
		case SAVED_GAME_SCREEN: {
			if(viewSavedGameScreen) return;
			NSLog(@"Creating viewSavedGameScreen");
			
			SavedGameController *view = [[SavedGameController alloc] initWithNibName:@"SavedGame" bundle:nil];
			frame = view.view.frame;
			frame.size.width = 480;
			frame.size.height = 320;
			frame.origin.x	= 0;
			frame.origin.y	= 0;
			view.view.frame = frame;
			
			self.viewSavedGameScreen = view;
			[view release];
			
			CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
			rotate = CGAffineTransformTranslate (rotate, 80.0, 80.0);
			self.viewSavedGameScreen.view.transform  = rotate;
		} break;
			
		case HELP_SCREEN: {
			if(viewHelpScreen) return;
			NSLog(@"Creating viewHelpScreen");
			
			HelpController *view = [[HelpController alloc] initWithNibName:@"Help" bundle:nil];
			frame = view.view.frame;
			frame.size.width = 480;
			frame.size.height = 320;
			frame.origin.x	= 0;
			frame.origin.y	= 0;
			view.view.frame = frame;
			
			self.viewHelpScreen = view;
			[view release];
			
			CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
			rotate = CGAffineTransformTranslate (rotate, 80.0, 80.0);
			self.viewHelpScreen.view.transform  = rotate;
		} break;
			
		case TOP_SCORE_SCREEN: {
			if(viewTopScoreScreen) return;
			NSLog(@"Creating viewTopScoreScreen");
			
			TopScoreController *view = [[TopScoreController alloc] initWithNibName:@"TopScore" bundle:nil];
			frame = view.view.frame;
			frame.size.width = 480;
			frame.size.height = 320;
			frame.origin.x	= 0;
			frame.origin.y	= 0;
			view.view.frame = frame;
			
			self.viewTopScoreScreen = view;
			[view release];
			
			CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
			rotate = CGAffineTransformTranslate (rotate, 80.0, 80.0);
			self.viewTopScoreScreen.view.transform  = rotate;
		} break;
			
		case POST_SCORE_SCREEN: {
			if(viewPostScoreScreen) return;
			NSLog(@"Creating viewPostScoreScreen");
			
			PostScoreController *view = [[PostScoreController alloc] initWithNibName:@"PostScore" bundle:nil];
			frame = view.view.frame;
			frame.size.width = 480;
			frame.size.height = 320;
			frame.origin.x	= 0;
			frame.origin.y	= 0;
			view.view.frame = frame;
			
			self.viewPostScoreScreen = view;
			[view release];
			
			CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
			rotate = CGAffineTransformTranslate (rotate, 80.0, 80.0);
			self.viewPostScoreScreen.view.transform  = rotate;
		} break;
			
		case PAUSED_SCREEN: {
			if(viewPausedScreen) return;
			NSLog(@"Creating viewPausedScreen");
			
			PausedController *view = [[PausedController alloc] initWithNibName:@"Paused" bundle:nil];
			frame = view.view.frame;
			frame.size.width = 480;
			frame.size.height = 320;
			frame.origin.x	= 0;
			frame.origin.y	= 0;
			view.view.frame = frame;
			
			self.viewPausedScreen = view;
			[view release];
			
			CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
			rotate = CGAffineTransformTranslate (rotate, 80.0, 80.0);
			self.viewPausedScreen.view.transform  = rotate;
		} break;
			
		case WINNER_SCREEN: {
			if(viewWinnerScreen) return;
			NSLog(@"Creating viewWinnerScreen");
			
			WinnerController *view = [[WinnerController alloc] initWithNibName:@"Winner" bundle:nil];
			frame = view.view.frame;
			frame.size.width = 480;
			frame.size.height = 320;
			frame.origin.x	= 0;
			frame.origin.y	= 0;
			view.view.frame = frame;
			
			self.viewWinnerScreen = view;
			[view release];
			
			CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
			rotate = CGAffineTransformTranslate (rotate, 80.0, 80.0);
			self.viewWinnerScreen.view.transform  = rotate;
		} break;
	}
	
	NSLog(@"Finished loading xib: %d\n\n", nibId);
}


/*`
 ` This function allows us to switch active views dynamically with ui animation applied
 ` viewFadeIn: The view to fade in, alpha 0.0
 ` viewFadeOut: The view to fade out to the screen, alpha 1.0
 ` removeFromSuperView: boolean value, remove the FadeIn view from the superview
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) viewTransition: (id *) viewFadeIn: (id *) viewFadeOut: (BOOL) removeFromMemory {
	
	NSDictionary *context = [[NSDictionary dictionaryWithObjectsAndKeys: [NSNumber valueWithPointer: viewFadeIn], @"viewFadeIn", [NSNumber valueWithPointer: viewFadeOut], @"viewFadeOut", [NSNumber numberWithBool:removeFromMemory], @"removeFromMemory",nil] retain];
	UIViewController *controller = *viewFadeIn;
	
	[UIView beginAnimations:nil context:context];				// begin animation block
	[UIView setAnimationDuration: VIEW_ANIMATION_DURATION];		// sets animation duration
	[UIView setAnimationDelegate: self];						// sets delegate for this block
	[UIView setAnimationDidStopSelector:
	 @selector(viewTransitionFadeOut:finished:context:)];	// function to call when animation finished
	[controller.view setAlpha:0.0];								// fades the alpha of the input view to 0.0
	[UIView commitAnimations];									// commits the animation block
	
}

- (void) viewTransitionFadeOut: (NSString*)animationID finished:(BOOL)finished context:(NSDictionary *)context {
	
	BOOL removeFromMemory		= [[context objectForKey:@"removeFromMemory"] boolValue];
	UIViewController **outView	= [[context objectForKey:@"viewFadeOut"] pointerValue];
	UIViewController **inView	= [[context objectForKey:@"viewFadeIn"] pointerValue];
	UIViewController *viewFadeIn	= *inView;
	UIViewController *viewFadeOut	= *outView;
	
	// Since the dictionary context was retained, i guess we should release it here
	[context release];
	
	
	[viewFadeOut.view setAlpha:0.0];			// set the view alpha to 0.0 so we can animate
	[window addSubview: viewFadeOut.view];		// add the view to the window
	
	[UIView beginAnimations:nil	context:nil];				// begin animation block
	[UIView setAnimationDuration: VIEW_ANIMATION_DURATION];	// sets animation duration
	[UIView setAnimationDelegate: self];					// sets delegate for this block
	[viewFadeOut.view setAlpha:1.0];						// fades the alpha of the view to 1.0
	[UIView commitAnimations];								// commits the animation block
	
	
	// If we're removing the old view from memory then let's release it
	if(removeFromMemory) {
		[viewFadeIn.view removeFromSuperview];
		[viewFadeIn release];
		*inView = nil;		
	}
	
}


/*`
 ` Loading Sqlite databases
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (BOOL) initDatabase: (int) databaseId {
	// If we're creating a writable version to the database then copy it to the application document
	// directory. Else if read-only db, the database is stored in the application bundle
	NSString *fullDbPath;
	NSArray		*paths;
	NSString	*documentsDirectory;
	BOOL		success;
	
	switch (databaseId) {
		case DB_BEBA:
			// If the database is already loaded then return
			if(global_bebaDb) return true;
			
			fullDbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"beba.sqlite"];
			
			// Open the database. The database was prepared outside the application
			if(sqlite3_open([fullDbPath UTF8String], &global_bebaDb) == SQLITE_OK) return true;
			
			break;
		case DB_SAVED_GAME:
			// If the database is already loaded then return
			if(global_savedGameDb) return true;
			
			paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			documentsDirectory = [paths objectAtIndex:0];
			fullDbPath = [documentsDirectory stringByAppendingPathComponent: @"game.sqlite"];
			
			success = [self copyDbToDocumentDirectoryIfNeeded: fullDbPath: @"game.sqlite"];
			if(success == false) return false;			
			
			// Open the database. The database was prepared outside the application
			if(sqlite3_open([fullDbPath UTF8String], &global_savedGameDb) == SQLITE_OK) return true;
			
			break;
	}
	
	return false;
}


/*`
 ` If we need to have a writable copy of the database, we need to copy the database to the
 ` application documents directory otherwise the iPhone code sign will detect a change in the
 ` application bundle and this will crash the app.
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (BOOL) copyDbToDocumentDirectoryIfNeeded: (NSString*) fullWritableDbPath: (NSString*) dbFilename {
	// First, test for existence.
	BOOL success;
	NSFileManager	*fileManager = [NSFileManager defaultManager];
	NSError			*error;
	
	NSLog(fullWritableDbPath);
	success = [fileManager fileExistsAtPath: fullWritableDbPath];
	if(success) return true;
	
	// The writable database does not exist, so copy the default to the appropriate location.
	NSString *defaultDbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: dbFilename];
	success	= [fileManager copyItemAtPath: defaultDbPath toPath: fullWritableDbPath	error:&error];
	
	if(success) return true; else return false;
}


/*`
 ` Return a random game word chosen from the database
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (NSString *) getRandomLoserMessage {
	[self initDatabase: DB_BEBA];
	
	// We'll have to make a connection to the database and select a random word to use in
	// our game. We'll only select ONE word from the list.
	int messageId = arc4random() % LOSER_MESSAGE_TOTAL + LOSER_MESSAGE_RANGE_START;
	
	// Initialize the query
	NSString *sql = [NSString stringWithFormat:@"SELECT Message FROM Messages WHERE Id=%d", messageId];
	NSString *word;
	sqlite3_stmt *statement;
	
	// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library,
	// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
	if(sqlite3_prepare_v2(global_bebaDb, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		// We "step" through the results - once for each row.
		while(sqlite3_step(statement) == SQLITE_ROW)
			// The second parameter indicates the column index into the result set.
			word = [NSString stringWithUTF8String: (char *) sqlite3_column_text(statement, 0)];
		
		// "Finalize" the statement - release the resources associated with the statement.
		sqlite3_finalize(statement);
	}
	else
		NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_bebaDb));
	
	return word;	
}


/*`
 ` Return a random game word chosen from the database
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (NSString *) getRandomWinnerMessage {
	[self initDatabase: DB_BEBA];
		
	// Initialize the query
	NSString *sql = [NSString stringWithFormat:@"SELECT Message FROM Messages WHERE TypeId=2 ORDER BY RANDOM() LIMIT 1"];
	NSString *word;
	sqlite3_stmt *statement;
	
	// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library,
	// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
	if(sqlite3_prepare_v2(global_bebaDb, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		// We "step" through the results - once for each row.
		while(sqlite3_step(statement) == SQLITE_ROW)
			// The second parameter indicates the column index into the result set.
			word = [NSString stringWithUTF8String: (char *) sqlite3_column_text(statement, 0)];
		
		// "Finalize" the statement - release the resources associated with the statement.
		sqlite3_finalize(statement);
	}
	else
		NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_bebaDb));
	
	return word;	
}



/*`
 ` 
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (int) getFirstRankPlayerScore {
	[self initDatabase: DB_SAVED_GAME];
	
	static const char* sql = "SELECT Score FROM TopPlayers WHERE Rank=1 LIMIT 1";
	sqlite3_stmt *statement;
	int score = 0;
	
	// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library,
	// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
	if(sqlite3_prepare_v2(global_savedGameDb, sql, -1, &statement, NULL) == SQLITE_OK)
	{
		// We "step" through the results - once for each row.
		while(sqlite3_step(statement) == SQLITE_ROW)
			// The second parameter indicates the column index into the result set.
			score = sqlite3_column_int(statement, 0);
		
		// "Finalize" the statement - release the resources associated with the statement.
		sqlite3_finalize(statement);
	}
	else
		NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_bebaDb));
	
	return score;	
}


/*`
 ` This function aggregates all sound effects and music being played on the app into one
 ` place. Simply call the function with the defined sound id to play the sound effect.
 ` Based on the Apple API, the system api used limit sound files to 30 secs.
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) playSoundEffect: (int) soundEffectId {
	
	NSString *soundPath;
	
	switch (soundEffectId) {
		case SOUND_FX_TOUCH:
			if(! self.soundEffectTouch)
			{
				soundPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"touch.aif"];
				AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundEffectTouch);
			}
			AudioServicesPlaySystemSound (self.soundEffectTouch);
			break;
		case SOUND_FX_SPIN:
			if(! self.soundEffectSpin)
			{
				soundPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"spin.aif"];
				AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundEffectSpin);
			}
			AudioServicesPlaySystemSound (self.soundEffectSpin);
			break;
		case SOUND_FX_SCORE:
			if(! self.soundEffectScore)
			{
				soundPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"score.aif"];
				AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundEffectScore);
			}
			AudioServicesPlaySystemSound (self.soundEffectScore);
			break;
		case SOUND_FX_BONUS:
			if(! self.soundEffectBonus)
			{
				soundPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bonus.aif"];
				AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundEffectBonus);
			}
			AudioServicesPlaySystemSound (self.soundEffectBonus);
			break;
			
		case SOUND_FX_TIME:
			if(! self.soundEffectTime)
			{
				soundPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"time.aif"];
				AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundEffectTime);
			}
			AudioServicesPlaySystemSound (self.soundEffectTime);
			break;
			
		case SOUND_FX_LOST:
			if(! self.soundEffectLost)
			{
				soundPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"lost.aif"];
				AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundEffectLost);
			}
			AudioServicesPlaySystemSound (self.soundEffectLost);
			break;
		case SOUND_FX_AMBIENTAL:
			if(! self.soundEffectAmbiental)
			{
				soundPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ambiental.aif"];
				AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundEffectAmbiental);
			}
			AudioServicesPlaySystemSound (self.soundEffectAmbiental);
			break;/*
		case SOUND_FX_AMBIENTAL:
			if(! self.soundEffectAmbiental)
			{
				soundPath = [[NSBundle mainBundle] pathForResource:@"ambiental.mp3" ofType:@"mp3"];
				AVAudioPlayer *player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:NULL];
				player.delegate = self;
				player.numberOfLoops = 0; 
				[player play];
				
			//	soundPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ambiental.aif"];
			//	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundEffectAmbiental);
			}
			//AudioServicesPlaySystemSound (self.soundEffectAmbiental);
			break; */
	}
	
}






















/*


- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
	/////////////////////

//		
//	return;
		//NSLog(@"x:  %f, y: %f", lastAcceleration.x, lastAcceleration.y);

	 
//
	
	static int shakeCount = 0;
	
	if (self.lastAcceleration) {
		if (!histeresisExcited && L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.3)) {
			
			if(shakeCount >=2)
			{
				histeresisExcited = YES;
				shakeCount = 0;
				
				// SHAKE DETECTED. DO HERE WHAT YOU WANT. 
				NSLog(@"iPhone is shaking");
				
				if(self.viewGameScreen){
					//histeresisExcited = YES;
				
					[self.viewGameScreen spin];
					//histeresisExcited = NO;
				
				}
			}
			else
				shakeCount++;
			
		} else if (histeresisExcited && !L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.2)) {
			histeresisExcited = NO;
			shakeCount = 0;
		}
	}
	
	self.lastAcceleration = acceleration;
}


*/








@end