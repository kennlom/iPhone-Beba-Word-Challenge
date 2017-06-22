//
//  PostScoreController.m
//  WordChallenge
//
//  Created by Nguyen on 10/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PostScoreController.h"
#import "WordChallengeAppDelegate.h"

@implementation PostScoreController

@synthesize labelPlayerScore, labelPlayerStats;
@synthesize iconSpinner;

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
	
	
	// Update the player stats
	[self.labelPlayerScore	setText: [NSString stringWithFormat:@"Your score: %d", [[global_lastGameData objectForKey:GAME_DATA_PLAYER_SCORE] intValue]]  ];
	[self.labelPlayerStats	setText: [NSString stringWithFormat:@"%d words found.", [[global_lastGameData objectForKey:GAME_DATA_WORDS_FOUND] intValue]]  ];
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
	NSLog(@"PostScore dealloc()");
//	[connection cancel];
//    [connection release];
    [requestData release];
	
	self.labelPlayerScore	= nil;
	self.labelPlayerStats	= nil;
	self.iconSpinner		= nil;
    [super dealloc];
}




- (void) globalDisplayAlert: (NSString*) text {
	displayAlert(@"", text);
}

- (IBAction) postScore {
	NSString *playerName	= [textName text];
	NSString *playerMessage = [textMessage text];
	
	if([playerName length] == 0)
		return displayAlert(@"", @"Please enter your name");
	else if([[textName text] length] > 40)
		return displayAlert(@"What a long name", @"Please use only up to 40 characters for your name. Try removing some letters.");
	else if([playerMessage length] >= 60)
		return displayAlert(@"", @"Your message is too long. 60 chars max.");
	
	[self.iconSpinner startAnimating];
	[buttonPostScore setEnabled:false];
	[self postScoreAsync];
//	[NSThread detachNewThreadSelector: @selector(postScoreAsync) toTarget:self withObject:nil];
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

	NSString *text = @"Unable to contact server, please try again later.";
	[self performSelectorOnMainThread:@selector(globalDisplayAlert:)  withObject:text waitUntilDone:NO];
}


- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	NSLog(@"finished getting data");
//    [connection release];
//    connection = nil;
		
	NSString	*dataString			= [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
	NSArray		*arrayReturnData	= arrayFromSplittedString(dataString, @"\n");
	NSString	*playerRank;
	BOOL contentRetrieved = false;
	
	if([[arrayReturnData objectAtIndex:0] isEqualToString: POST_SCORE_SUCCESS])
	{
		contentRetrieved = true;
		if([arrayReturnData count] >= 2)
			playerRank = [arrayReturnData objectAtIndex:1];
	}
	
	if(contentRetrieved) {
		[buttonPostScore setEnabled:false];
		[iconSpinner stopAnimating];
		[buttonPostScore setAlpha:0.0];
		NSString *text = [NSString stringWithFormat:@"Just to let you know that your score have been successfully posted.\n\nYour rank: %@", playerRank];
		[self performSelectorOnMainThread:@selector(globalDisplayAlert:) withObject:text waitUntilDone:NO];
	}
	else {
		[buttonPostScore setEnabled:true];
		[iconSpinner stopAnimating];
		NSString *text = @"Unable to contact server, please try again later.";
		[self performSelectorOnMainThread:@selector(globalDisplayAlert:)  withObject:text waitUntilDone:NO];
	}
	
	NSLog(dataString);
	[dataString release];
    [requestData release];
    requestData=nil;
}





- (void) postScoreAsync {
	// Ok, we'll only select a random server from the list.. we won't do each and every server until we get data
	NSMutableArray *arrayApiServer = [NSMutableArray arrayWithObjects: API_SERVER_1, API_SERVER_2, API_SERVER_3, API_SERVER_4, API_SERVER_5, API_SERVER_6,
									  API_SERVER_7, API_SERVER_8, API_SERVER_9, nil];
	
	NSString *udid				= [[UIDevice currentDevice] uniqueIdentifier];
	NSString *requestParameter	= [NSString stringWithFormat:@"gameid=%d&udid=%@&name=%@&message=%@&score=%d&found=%d&bonus=%d&missed=%d&completed=%d&skipped=%d",
								  BEBA_GAME_ID, udid, [textName text], [textMessage text],
								  [[global_lastGameData objectForKey:GAME_DATA_PLAYER_SCORE] intValue],
								  [[global_lastGameData objectForKey:GAME_DATA_WORDS_FOUND] intValue],
								  [[global_lastGameData objectForKey:GAME_DATA_BONUS_WORDS] intValue],
								  [[global_lastGameData objectForKey:GAME_DATA_WORDS_MISSED] intValue],
								  [[global_lastGameData objectForKey:GAME_DATA_WORDS_COMPLETED] intValue],
								  [[global_lastGameData objectForKey:GAME_DATA_WORDS_SKIPPED] intValue]];
	
	NSString			*checkSum = md5( [NSString stringWithFormat:@"%@.%@", requestParameter, CHECKSUM_ENCRYPTION_KEY] );
	NSString			*postBody = [NSString stringWithFormat:@"%@&key=%@", requestParameter, checkSum];
	NSString			*fullRequestUrl;
	NSData				*postData = [postBody dataUsingEncoding:NSUTF8StringEncoding];
	NSURL				*url;
	NSMutableURLRequest	*request;
	int serverId = 0;
	
	// Pick a random server from the list of servers and place a request againsts it
	serverId		= arc4random() % [arrayApiServer count];
	fullRequestUrl	= [NSString stringWithFormat:@"http://%@%@", [arrayApiServer objectAtIndex:serverId], POST_SCORE_URL];
	url				= [NSURL URLWithString: fullRequestUrl];  
	request			= [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0]; 
	[request setValue:APP_USER_AGENT forHTTPHeaderField: @"User-Agent"];
	[request setHTTPMethod: @"POST"];
	[request setHTTPBody: postData];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
			
//	if (connection!=nil) { [connection release]; }
	if (requestData!=nil) { [requestData release]; }
	
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
	
	connection = [NSURLConnection connectionWithRequest:request delegate:self];
	//TODO error handling, what if connection is nil?
	if(connection == nil)
			NSLog(@"Cant get connection");
	
	// Release the request
	[request release]; request = nil;
}


- (IBAction) close {
	UIAppDelegate
	
	// Initialize the end game screen
	[app viewTransition: [app addressOf_viewPostScoreScreen]: [app addressOf_viewEndScreen]: true];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}




@end