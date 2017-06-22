//
//  NextLevelController.m
//  WordChallenge
//
//  Created by Nguyen on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NextLevelController.h"
#import "WordChallengeAppDelegate.h"

@implementation NextLevelController

@synthesize labelLevel, labelMessage, labelLuckyNumber;


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
	
	int numbers = 0;
	int randomNumber;
	int pickedNumber;
	BOOL alreadyUsed;
	NSMutableArray *arrayNumbers = [NSMutableArray new];
	NSMutableString *luckyNumbers = [NSMutableString new];
	// Generate lucky numbers
	while(numbers < 6)
	{
		while(TRUE)
		{
			randomNumber	= arc4random() % 49 + 1;
			alreadyUsed		= false;
			
			for (int i=0; i<numbers; i++) {
				pickedNumber = [[arrayNumbers objectAtIndex:i] intValue];
				if(pickedNumber == randomNumber) { alreadyUsed=true; break; }
			}
			
			if(alreadyUsed==true) continue;
			[arrayNumbers addObject:NumberFromInt(randomNumber)];
			numbers++;
			break;
		}
	}
	
	for (int i=0; i<numbers; i++) {
		pickedNumber = [[arrayNumbers objectAtIndex:i] intValue];
		[luckyNumbers appendString:[NSString stringWithFormat:@"%d  ", pickedNumber]];
	}
	
	UIAppDelegate
	[self.labelMessage setText:[app getRandomWinnerMessage]];
	[self.labelLuckyNumber setText:luckyNumbers];
	[arrayNumbers release];
	[luckyNumbers release];
	NSLog(luckyNumbers);
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
	NSLog(@"NextLevel dealloc()");
	self.labelLevel			= nil;
	self.labelMessage		= nil;
	self.labelLuckyNumber	= nil;
    [super dealloc];
}


/*`
 ` Save player game
 ``````````````````````````````````````````````````````````````````````````````````````````*/
 - (void) saveGame {
	 UIAppDelegate
	 
	 // Prepare the game data dictionary for binary save
	 NSMutableDictionary *gameDataDictionary = [self prepareGameDataDictionary];
	 // Save or update the current game (if continued game) to the database
	 [self saveGameDataToDb: gameDataDictionary: app.viewGameScreen.currentGameId];
	 
	 [gameDataDictionary removeAllObjects];
	 [gameDataDictionary release];
	 NSLog(@"Game Id: %d", app.viewGameScreen.currentGameId);
}


/*`
 ` Prepare the game data dictionary for binary save into the database
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (NSMutableDictionary *) prepareGameDataDictionary {
	UIAppDelegate
	
	// Prepare the game data dictionary so we can save into the db
	NSMutableDictionary *gameDataDictionary = [NSMutableDictionary new];
	
	[gameDataDictionary setObject:[NSNumber numberWithInt: app.viewGameScreen.playerScore] forKey: PLAYER_SCORE];
	[gameDataDictionary setObject:[NSNumber numberWithInt: app.viewGameScreen.totalWordsFound] forKey: WORDS_FOUND];
	[gameDataDictionary setObject:[NSNumber numberWithInt: app.viewGameScreen.totalWordsMissed] forKey: WORDS_MISSED];
	[gameDataDictionary setObject:[NSNumber numberWithInt: app.viewGameScreen.totalWordsCompleted] forKey: WORDS_COMPLETED];
	[gameDataDictionary setObject:[NSNumber numberWithInt: app.viewGameScreen.totalWordsSkipped] forKey: WORDS_SKIPPED];
	[gameDataDictionary setObject:[NSNumber numberWithInt: app.viewGameScreen.totalBonusWords] forKey: BONUS_WORDS];
	[gameDataDictionary setObject:[NSNumber numberWithInt: app.viewGameScreen.gameMode] forKey: GAME_MODE];
	[gameDataDictionary setObject:[NSNumber numberWithInt: app.viewGameScreen.gameLevel] forKey: GAME_LEVEL];
	[gameDataDictionary setObject:[NSNumber numberWithInt: RELEASE_VERSION] forKey: GAME_VERSION];
	
	return gameDataDictionary;
}


/*`
 ` Save or update the game to the database
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) saveGameDataToDb: (NSMutableDictionary *) gameDataDictionary: (int) gameId {
	UIAppDelegate
	
	[app initDatabase: DB_SAVED_GAME];
	
	// Create a checksum of the game data dictionary to prevent people from hacking it
	NSString *checkSum = md5([NSString stringWithFormat:@"%@.%@", [gameDataDictionary description], CHECKSUM_ENCRYPTION_KEY]);
	NSString *sql;
	NSDate *date = [NSDate date];
	sqlite3_stmt *statement;
	
	// Initialize the query
	if(gameId)
		sql = [NSString stringWithFormat:@"UPDATE Game SET Data=?, CheckSum='%@', DateAccessed='%@' WHERE Id=%d", checkSum, GetDBDateFormatForDate(date), gameId];
	else
		sql = [NSString stringWithFormat:@"INSERT INTO Game (Id,Data,CheckSum,DateCreated,DateAccessed) VALUES(NULL,?,'%@','%@','%@')", checkSum, GetDBDateFormatForDate(date), GetDBDateFormatForDate(date)];
	
	NSLog(sql);
	
	// Prepare the data for archiving
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:gameDataDictionary forKey:@"game"];
	[archiver finishEncoding];
	[archiver release];
	
	
	// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library,
	// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
	if(sqlite3_prepare_v2(global_savedGameDb, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		sqlite3_bind_blob(statement, 1, [data bytes], [data length], SQLITE_TRANSIENT);
		
		// We "step" through the results - once for each row.
		while(sqlite3_step(statement) != SQLITE_DONE) {
			// Assign the current game the new insert row id, so if we save it again
			// it gets updated instead of creating a new record
		}
		
		NSLog(@"Created new record");
		if(! gameId)
			app.viewGameScreen.currentGameId = sqlite3_last_insert_rowid(global_savedGameDb);
		
		// "Finalize" the statement - release the resources associated with the statement.
		sqlite3_finalize(statement);
	}
//	else
//		NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_savedGameDb));

	// Release the temporary data
	[data release];
}




/*`
 ` Start next level
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) startNextLevel {
	NSLog(@"startNextLevel");
	UIAppDelegate
	[app.viewGameScreen initGameLevel: app.viewGameScreen.gameLevel];

	// Remove this screen from view
	[self.view removeFromSuperview];
	
	UIViewController **viewPointer;
	UIViewController *view;
	viewPointer = [app addressOf_viewNextLevelScreen];
	view = *viewPointer;
	[view release];
	*viewPointer = nil;
	
	
	NSLog(@"End of startNextLevel");
}

@end
