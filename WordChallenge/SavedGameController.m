//
//  SavedGameController.m
//  WordChallenge
//
//  Created by Nguyen on 9/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SavedGameController.h"
#import "WordChallengeAppDelegate.h"
#import "SavedGameCell.h"


@implementation SavedGameController

@synthesize tableGameList;
@synthesize arraySavedGames;
@synthesize viewLoadGame;
@synthesize selectedGameId, selectedGameIndex;
@synthesize labelNoSavedGameFound;
@synthesize imageArrow;
@synthesize	labelWordsFound, labelWordsSkipped, labelWordsMissed, labelWordsCompleted, labelBonusWords, labelPlayerScore, labelGameLevel, labelGameMode;

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
	[self initSavedGames];
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
	NSLog(@"SavedGame dealloc()");
	[arraySavedGames removeAllObjects];
	[arraySavedGames release];
	self.arraySavedGames		= nil;
	self.imageArrow				= nil;
	self.labelNoSavedGameFound	= nil;
	self.viewLoadGame			= nil;
	self.tableGameList			= nil;
	
	self.labelWordsFound		= nil;
	self.labelWordsSkipped		= nil;
	self.labelWordsMissed		= nil;
	self.labelWordsCompleted	= nil;
	self.labelBonusWords		= nil;
	self.labelPlayerScore		= nil;
	self.labelGameLevel			= nil;
	self.labelGameMode			= nil;
	
    [super dealloc];
}


/*`
 ` Go back to start screen
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) goBackToStartScreen {
	UIAppDelegate
	
	// Switch back to the start screen and release this xib from memory
	[app initXibScreen: GAME_MODE_SCREEN];
	[app viewTransition: [app addressOf_viewSavedGameScreen]: [app addressOf_viewGameModeScreen]: true];
}

/*`
 ` Initialize saved games
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) initSavedGames {
	UIAppDelegate
	
	[app initDatabase: DB_SAVED_GAME];	
	self.arraySavedGames = [NSMutableArray new];
	[self loadSavedGames];
}

/*`
 ` User decides to discard the saved game data
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) discardGame {
	// Notify the player that the game is saved
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Discard Game?" message:@"Are you sure you want to remove this saved game? You cannot undo." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
	[alert show];
	[alert release];
}

/*`
 ` Check to see if the user really wants to remove the saved game data
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// The user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		NSLog(@"removing game");
		[self discardGameFromDb: self.selectedGameId];
		[self.arraySavedGames removeObjectAtIndex: self.selectedGameIndex];
		[self.tableGameList reloadData];
		[self hideLoadScreen];
	}
}


/*`
 ` Discard a saved game from the database
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) discardGameFromDb: (int) gameId {
	// We'll have to make a connection to the database and select a random word to use in
	// our game. We'll only select ONE word from the list.
	
	// Initialize the query
	NSString *sql = [NSString stringWithFormat:@"DELETE FROM Game WHERE Id=%d", gameId];
	sqlite3_stmt *statement;
	
	// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library,
	// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
	if(sqlite3_prepare_v2(global_savedGameDb, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		// We "step" through the results - once for each row.
		while(sqlite3_step(statement) == SQLITE_ROW) {	
		}
		
		// "Finalize" the statement - release the resources associated with the statement.
		sqlite3_finalize(statement);
	}
	//else
	//	NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_savedGameDb));
}

/*`
 ` Hide the popup saved game info screen
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) hideLoadScreen {
	
	[UIView beginAnimations:nil	context:nil];	// begin animation block
	[UIView setAnimationDuration: 0.15];			// sets animation duration
	[UIView setAnimationDelegate: self];		// sets delegate for this block
	[self.viewLoadGame setAlpha: 0.00];
	[UIView commitAnimations];					// commits the animation block

}

/*`
 ` Return a random game word chosen from the database
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) loadSavedGames {
	// We'll have to make a connection to the database and select a random word to use in
	// our game. We'll only select ONE word from the list.
	NSLog(@"Loading saved games");
	
	// Initialize the query
	NSString *sql = [NSString stringWithFormat:@"SELECT Id,Data,CheckSum,DateAccessed FROM Game ORDER BY DateAccessed DESC"];
	NSString *lastPlayedDate;
	sqlite3_stmt *statement;
	int gameId = 0;

	// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library,
	// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
	if(sqlite3_prepare_v2(global_savedGameDb, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		// We "step" through the results - once for each row.
		while(sqlite3_step(statement) == SQLITE_ROW)
		{	
			gameId				= sqlite3_column_int(statement, 0);
			NSData *data		= [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 1) length: sqlite3_column_bytes(statement, 1)];
			NSString *checkSum	= [NSString stringWithUTF8String: (char *) sqlite3_column_text(statement, 2)];
			lastPlayedDate		= [NSString stringWithUTF8String: (char *) sqlite3_column_text(statement, 3)];
			
			
			NSKeyedUnarchiver *unarchiver		= [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			NSMutableDictionary *myDictionary	= [[unarchiver decodeObjectForKey:@"game"] retain];
			[unarchiver finishDecoding];
			[unarchiver release];
			[data release];
			
			// If the saved game version is the same as the one we released
			if([[myDictionary objectForKey: GAME_VERSION] intValue] == RELEASE_VERSION)
			{
				// Check to see if the md5 hash key is the same as when we saved it
				if([checkSum isEqualToString: md5( [NSString stringWithFormat:@"%@.%@", [myDictionary description], CHECKSUM_ENCRYPTION_KEY])])
				{
					[myDictionary setObject:NumberFromInt(gameId) forKey: GAME_ID];
					[myDictionary setObject:dateDiff(lastPlayedDate) forKey: LAST_PLAYED_DATE];
					[self.arraySavedGames addObject:myDictionary];
				}
			}
			
			// Release the temporary dictionary
			[myDictionary release];
			//[lastPlayedDate release];
		}
		
		// "Finalize" the statement - release the resources associated with the statement.
		sqlite3_finalize(statement);
	}
//	else
//		NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_savedGameDb));
	
	
	NSLog(@"Load founded %d games saved", [self.arraySavedGames count]);	
}

/*`
 ` Save or update the game to the database
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) saveGameLastAccessed: (int) gameId {
	UIAppDelegate
	[app initDatabase: DB_SAVED_GAME];
	
	// Create a checksum of the game data dictionary to prevent people from hacking it
	NSDate *date	= [NSDate date];
	NSString *sql	= [NSString stringWithFormat:@"UPDATE Game SET DateAccessed='%@' WHERE Id=%d", GetDBDateFormatForDate(date), gameId];
	sqlite3_stmt *statement;
	
	// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library,
	// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
	if(sqlite3_prepare_v2(global_savedGameDb, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		// We "step" through the results - once for each row.
		while(sqlite3_step(statement) != SQLITE_DONE) {
			// Assign the current game the new insert row id, so if we save it again
			// it gets updated instead of creating a new record
		}		
		// "Finalize" the statement - release the resources associated with the statement.
		sqlite3_finalize(statement);
	}
	//else
	//	NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_savedGameDb));
}


/*`
 ` Return total number of rows in data table
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int count = [self.arraySavedGames count];
	
	if(count == 0)	[labelNoSavedGameFound setHidden: false];
	else			[labelNoSavedGameFound setHidden: true];
	
	return count;
}


/*`
 ` Get the custom cell view for item
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellId = @"SavedGameCell";
	SavedGameCell *cell = (SavedGameCell *) [tableView dequeueReusableCellWithIdentifier: cellId];
	
	if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SavedGameCellScreen" owner:nil options:nil];
		for(id currentObject in topLevelObjects)
		{
			if([currentObject isKindOfClass:[SavedGameCell class]])
			{
				cell = (SavedGameCell *)currentObject;
				break;
			}
		}
	}
	

	NSMutableDictionary *gameDataDictionary = [self.arraySavedGames objectAtIndex:[indexPath row]];
			
	cell.labelGameLevel.text	= [NSString stringWithFormat:@"Level: %d", [[gameDataDictionary objectForKey: GAME_LEVEL] intValue]];
	cell.labelGameMode.text		= GameModeFromId([[gameDataDictionary objectForKey: GAME_MODE] intValue]);
	cell.labelPlayerScore.text	= [NSString stringWithFormat:@"Score: %d", [[gameDataDictionary objectForKey: PLAYER_SCORE] intValue]];
	cell.labelLastPlayed.text	= [gameDataDictionary objectForKey: LAST_PLAYED_DATE];

	return cell;
}


/*`
 ` We're being cute here and determine to move the pointer up and down as the user scroll
 ` the list data table
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void)scrollViewDidScroll: (UIScrollView *)scrollView {
	
	float contentOffset			= [scrollView contentOffset].y;
	float rowHeight				= [tableGameList rowHeight];
	float estimatedYPosition	= 20 + (selectedRow * rowHeight - contentOffset);
	
	if(estimatedYPosition < 20) return;			//estimatedYPosition = 20;
	else if(estimatedYPosition > 220) return;	//estimatedYPosition = 220;
	
	imageArrow.frame = CGRectMake(imageArrow.frame.origin.x, estimatedYPosition, imageArrow.frame.size.width, imageArrow.frame.size.height);
}

/*
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}
*/

/*`
 ` The player selected an item in the data table
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	selectedRow = [indexPath row];
	
	NSMutableDictionary *gameDataDictionary = [self.arraySavedGames objectAtIndex: selectedRow];
	self.selectedGameId		= [[gameDataDictionary objectForKey: GAME_ID] intValue];
	self.selectedGameIndex	= selectedRow;
	
	// Update the labels
	labelWordsFound.text		= StringFromInt([[gameDataDictionary objectForKey: WORDS_FOUND] intValue]);
	labelWordsSkipped.text		= StringFromInt([[gameDataDictionary objectForKey: WORDS_SKIPPED] intValue]);
	labelWordsMissed.text		= StringFromInt([[gameDataDictionary objectForKey: WORDS_MISSED] intValue]);
	labelWordsCompleted.text	= StringFromInt([[gameDataDictionary objectForKey: WORDS_COMPLETED] intValue]);
	labelBonusWords.text		= StringFromInt([[gameDataDictionary objectForKey: BONUS_WORDS] intValue]);
	labelPlayerScore.text		= StringFromInt([[gameDataDictionary objectForKey: PLAYER_SCORE] intValue]);
	labelGameLevel.text			= StringFromInt([[gameDataDictionary objectForKey: GAME_LEVEL] intValue]);
	labelGameMode.text			= GameModeFromId([[gameDataDictionary objectForKey: GAME_MODE] intValue]);

	// Move the arrow image
	float contentOffset			= [tableView contentOffset].y;
	float rowHeight				= [tableView rowHeight];
	float estimatedYPosition	= 20 + (selectedRow * rowHeight - contentOffset);
	
	imageArrow.frame = CGRectMake(imageArrow.frame.origin.x, estimatedYPosition, imageArrow.frame.size.width, imageArrow.frame.size.height);
	
	[self.viewLoadGame setAlpha:0.0];						// set the view alpha to 0.0 so we can animate	
	[UIView beginAnimations:nil	context:nil];				// begin animation block
	[UIView setAnimationDuration: 0.15];					// sets animation duration
	[UIView setAnimationDelegate: self];					// sets delegate for this block
		[self.viewLoadGame setAlpha: 1.00];
	[UIView commitAnimations];								// commits the animation block
}


/*`
 ` Continue saved game
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) continueSavedGame {
	NSLog(@"Continue saved game");
	
	UIAppDelegate
	[app initXibScreen: GAME_SCREEN];
	
	NSMutableDictionary *gameDataDictionary = [self.arraySavedGames objectAtIndex:self.selectedGameIndex];
	
	int gameId		= [[gameDataDictionary objectForKey: GAME_ID] intValue];
	int gameModeId	= [[gameDataDictionary objectForKey: GAME_MODE] intValue];
	int gameLevel	= [[gameDataDictionary objectForKey: GAME_LEVEL] intValue];
	int playerScore	= [[gameDataDictionary objectForKey: PLAYER_SCORE] intValue];
	
	[self saveGameLastAccessed: gameId];
	app.viewGameScreen.currentGameId = gameId;
	[app.viewGameScreen adjustPlayerScore: playerScore];
	app.viewGameScreen.totalWordsFound		= [[gameDataDictionary objectForKey: WORDS_FOUND] intValue];
	app.viewGameScreen.totalWordsMissed		= [[gameDataDictionary objectForKey: WORDS_MISSED] intValue];
	app.viewGameScreen.totalWordsCompleted	= [[gameDataDictionary objectForKey: WORDS_COMPLETED] intValue];
	app.viewGameScreen.totalWordsSkipped	= [[gameDataDictionary objectForKey: WORDS_SKIPPED] intValue];
	app.viewGameScreen.totalBonusWords		= [[gameDataDictionary objectForKey: BONUS_WORDS] intValue];
	
	// Initialize the saved game
	[app.viewGameScreen initGame: gameModeId];
	[app.viewGameScreen	initGameLevel: gameLevel];
	[app viewTransition: [app addressOf_viewSavedGameScreen]: [app addressOf_viewGameScreen]: true];
}



















@end
