//
//  TopScoreController.m
//  WordChallenge
//
//  Created by Nguyen on 10/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TopScoreController.h"
#import "WordChallengeAppDelegate.h"
#import "XmlParser.h"
#import "TopScoreCell.h"

@implementation TopScoreController

@synthesize iconSpinner, tableTopScore, buttonRefresh, buttonGoBack;
@synthesize labelLoadingFromServer, labelPleaseWait, imageLoadingBackground;

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
	[self loadCachedTopPlayerScore];
	[NSTimer scheduledTimerWithTimeInterval: 0.5 target:self selector:@selector(getTopScore) userInfo:nil repeats:NO];
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
	NSLog(@"TopScore dealloc");
//	if(connection)
//		[connection cancel];
//    [connection release];
    [requestData release];
	
	[self.tableTopScore removeFromSuperview];
//	[self.tableTopScore release];
	[arrayTopScores removeAllObjects];
	[arrayTopScores release];
//	[self.iconSpinner release];

	previousView = nil;
	
//	[self.labelLoadingFromServer release];
//	[self.labelPleaseWait release];
//	[self.imageLoadingBackground release];
//	[self.buttonRefresh release];
	
	self.tableTopScore			= nil;
	arrayTopScores				= nil;
	self.iconSpinner			= nil;
	self.labelPleaseWait		= nil;
	self.labelLoadingFromServer	= nil;
	self.imageLoadingBackground	= nil;
	self.buttonRefresh			= nil;
	self.buttonGoBack			= nil;
	
    [super dealloc];
}


- (void) getTopScore {
	NSLog(@"getTopScore()");
	isLoading = true;
	[tableTopScore setUserInteractionEnabled:false];
	
	// Disable the refresh button until we're done downloading data otherwise
	// the user will send too many requests to the server. This is unnecessary.
	[buttonRefresh setEnabled:false];
	//[buttonGoBack setEnabled:false];
	
	[imageLoadingBackground setHidden: false];
	[labelPleaseWait setHidden: false];
	[labelLoadingFromServer setHidden: false];
	[iconSpinner startAnimating];

	[self getTopScoreAsync];
	//[NSThread detachNewThreadSelector: @selector(getTopScoreAsync) toTarget:self withObject:nil];
}


- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	NSLog(@"data returning...");
    if (requestData==nil)
		requestData = [NSMutableData new];
	
    [requestData appendData:incrementalData];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
//    [connection release];
//    connection = nil;
    [requestData release];
    requestData=nil;
	
	displayAlert (@"Oops!",@"Unable to contact server, please try again later.");
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	NSLog(@"finished getting data");
//    [connection release];
//    connection = nil;
	
	// Check whether we can parse the xml data returned
	BOOL contentRetrieved = [self parseTopScoreXml: requestData];
		
	if(! contentRetrieved)
		displayAlert (@"Oops!",@"Unable to contact server, please try again later.");
	else
		[self refreshScore];
	
	[requestData release];
    requestData = nil;
}



- (void) getTopScoreAsync {
	// Ok, we'll only select a random server from the list.. we won't do each and every server until we get data
	NSMutableArray *arrayApiServer = [NSMutableArray arrayWithObjects: API_SERVER_1, API_SERVER_2, API_SERVER_3, API_SERVER_4, API_SERVER_5, API_SERVER_6,
									  API_SERVER_7, API_SERVER_8, API_SERVER_9, nil];
		
	NSLog(@"Trying server.........");
	
	int serverId					= arc4random() % [arrayApiServer count];
	NSString	*udid				= [[UIDevice currentDevice] uniqueIdentifier];
	NSString	*requestUrl			= [NSString stringWithFormat:@"http://%@%@?udid=%@", [arrayApiServer objectAtIndex:serverId], TOP_SCORE_XML_FILEURL, udid];
	NSURL		*url				= [NSURL URLWithString:requestUrl];  
	NSMutableURLRequest *request	= [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0]; 
	[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"]; 
	[request setValue:APP_USER_AGENT forHTTPHeaderField: @"User-Agent"];
		
		// Get the return data
//		if (connection!=nil) { [connection release]; }
		if (requestData!=nil) { [requestData release]; }
	
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
	
		connection = [NSURLConnection  connectionWithRequest:request delegate:self];
		//TODO error handling, what if connection is nil?
		if(connection == nil)
			NSLog(@"Cant get connection");
	
		// Release the request
		[request release]; request = nil;
}


- (void) refreshScore {
	// Refreshing scores...	
	NSLog(@"Refreshing scores");
	[self saveTopPlayersToDb: arrayTopScores];
	
	[iconSpinner stopAnimating];
	
	[imageLoadingBackground setHidden: true];
	[labelPleaseWait setHidden: true];
	[labelLoadingFromServer setHidden: true];
	[buttonRefresh setEnabled:true];
	//[buttonGoBack setEnabled:true];
	
	isLoading = false;
	[tableTopScore reloadData];
	[tableTopScore setUserInteractionEnabled:true];
}


- (BOOL) parseTopScoreXml: (NSData *) xmlData {
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: xmlData];
	//Initialize the delegate.
	XmlParser *parser = [[XmlParser alloc] initXMLParser];
	
	
	//Set delegate
	[xmlParser setDelegate:parser];
	//Start parsing the XML file.
	BOOL success = [xmlParser parse];
	
	if(success) {
		if(arrayTopScores) {
			[arrayTopScores removeAllObjects];
			[arrayTopScores release];
		}
		
		arrayTopScores = [[NSMutableArray alloc] initWithArray: [parser getXmlObject] copyItems: YES];
		//NSLog([arrayTopScores description]);
		
		NSLog(@"parse success");
	}
	else {
		NSLog(@"parse error");
	}

	[xmlParser release];
	[parser release];
	NSLog(@"Return success");
	return success;
}







- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//	return 0;
	NSLog(@"Getting rows");
	if(isLoading==false)
		return [arrayTopScores count];
	else
		return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *cellId = @"TopScoreCell";
	TopScoreCell *cell = (TopScoreCell *) [tableView dequeueReusableCellWithIdentifier: cellId];
//	NSLog(@"Getting cell");
	
	if (cell == nil){
		NSLog(@"New Cell Made");
		
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TopScoreCell" owner:nil options:nil];
		
		for(id currentObject in topLevelObjects)
		{
			if([currentObject isKindOfClass:[TopScoreCell class]])
			{
				//NSLog(@"found cell");
				cell = (TopScoreCell *)currentObject;
				break;
			}
		}
		
		//[topLevelObjects release];
	}

	

	NSMutableDictionary *topScore = [arrayTopScores objectAtIndex:[indexPath row]];

	cell.labelRank.text			= [NSString stringWithFormat:@"%d", [indexPath row] + 1];
	cell.labelPlayerInfo.text	= [topScore objectForKey:@"name"];
	cell.labelPlayerScore.text	= [NSString stringWithFormat:@"%d", [[topScore objectForKey: @"score"] intValue]];
	cell.labelWordsFound.text	= [NSString stringWithFormat:@"%d", [[topScore objectForKey: @"found"] intValue]];
	cell.labelPlayerDesc.text	= [NSString stringWithFormat:@"%@", [topScore objectForKey: @"message"]];

	return cell;
}


- (IBAction) back {
	UIAppDelegate
	
	if(previousView == nil)
	{
		//NSLog(@"No previous view found");
		previousView = [app addressOf_viewStartScreen];
	}

	// Initialize the end game screen
	[app viewTransition: [app addressOf_viewTopScoreScreen]: previousView: true]; 
}


- (void) setAddressOfPreviousView: (UIViewController **) view {
	previousView = view;
}





/*`
 ` 
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) saveTopPlayersToDb: (NSArray *) arrayTopPlayerScore {
	UIAppDelegate
	
	NSLog(@"Connecting to db");
	[app initDatabase: DB_SAVED_GAME];
	
	sqlite3_stmt *statement;
	static const char* removeSql = "DELETE FROM TopPlayers";

	NSLog(@"Deleting from db");
	if(sqlite3_prepare_v2(global_savedGameDb, removeSql, -1, &statement, NULL) == SQLITE_OK)
	{
		// We "step" through the results - once for each row.
		while(sqlite3_step(statement) != SQLITE_DONE) {
			// Assign the current game the new insert row id, so if we save it again
			// it gets updated instead of creating a new record
		}		
		// "Finalize" the statement - release the resources associated with the statement.
		sqlite3_finalize(statement);
	}
	else
		NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_savedGameDb));
	
	
	NSLog(@"Saving top scores");
	
	NSString *sql;
	for(int i=0; i<[arrayTopPlayerScore count]; i++)
	{
		
		NSDictionary *dict = [arrayTopPlayerScore objectAtIndex:i];
		int score = [[dict objectForKey:@"score"] intValue];
		NSLog([dict description]);
		
		sql = [NSString stringWithFormat:@"INSERT INTO TopPlayers (Id,Rank,Score,Data) VALUES(NULL,%d,%d,?)", i+1, score];

		// Prepare the data for archiving
		NSMutableData *data = [[NSMutableData alloc] init];
		NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		[archiver encodeObject:dict forKey:@"data"];
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
			
			// "Finalize" the statement - release the resources associated with the statement.
			sqlite3_finalize(statement);
		}
		//else
		//	NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_savedGameDb));
		
		[data release];
		
		
	}
	
	
	NSLog(@"end of save----------------");
}


/*`
 ` Load the cached version of the top player scores
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) loadCachedTopPlayerScore {
	// We'll have to make a connection to the database and select a random word to use in
	// our game. We'll only select ONE word from the list.
	NSLog(@"Loading saved top player scores");

	UIAppDelegate
	[app initDatabase: DB_SAVED_GAME];
	
	// Initialize the query
	NSString *sql = [NSString stringWithFormat:@"SELECT Data FROM TopPlayers ORDER BY Rank ASC"];
	NSMutableArray *arrayTempTopScore = [NSMutableArray new];
	sqlite3_stmt *statement;

	// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library,
	// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
	if(sqlite3_prepare_v2(global_savedGameDb, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		// We "step" through the results - once for each row.
		while(sqlite3_step(statement) == SQLITE_ROW)
		{	
			@try {
				NSData *data						= [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length: sqlite3_column_bytes(statement, 0)];
				NSKeyedUnarchiver *unarchiver		= [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
				NSMutableDictionary *myDictionary	= [[unarchiver decodeObjectForKey:@"data"] retain];
				[unarchiver finishDecoding];
				[unarchiver release];
				[data release];
			
				[arrayTempTopScore addObject: myDictionary];
			
				// Release the temporary dictionary
				[myDictionary release];
			}
			@catch (NSException *exception) {
				
			}
		}
		
		// "Finalize" the statement - release the resources associated with the statement.
		sqlite3_finalize(statement);
	}
	//	else
	//		NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_savedGameDb));
	
	if(arrayTopScores) {
		[arrayTopScores removeAllObjects];
		[arrayTopScores release];
	}
	
	arrayTopScores = [[NSMutableArray alloc] initWithArray: arrayTempTopScore copyItems: YES];
	[arrayTempTopScore release];
	[self.tableTopScore reloadData];
}



@end