//
//  GameScreenController.m
//  WordChallenge
//
//  Created by Nguyen on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WordChallengeAppDelegate.h"
#import "GameScreenController.h"





@implementation GameScreenController



@synthesize currentGameId;
@synthesize labelCountOfMaxWordsFound;
@synthesize buttonSpin, buttonCheckWord;
@synthesize labelPlayerScore, labelScore, labelCountdown, labelNextLevelMinScore, labelLevel, labelGameMode, labelPointDeduct;
@synthesize imageLetterBackground, imageLetterSlotBackground, imageBackground;
@synthesize countLetters;
@synthesize arrayWordLetterButtons;
@synthesize arrayTaggedLetter;
@synthesize arrayWordFound;
@synthesize gameWord;
@synthesize childWords, childWords3, childWords4, childWords5, childWords6;
@synthesize arrayGameLetters;
@synthesize arrayWordLetterSlots;
@synthesize playerScore;
@synthesize timerCountdown;
@synthesize totalBonusWords;
@synthesize timeUntilLevelEnds;
@synthesize gameMode, gameLevel;
@synthesize totalWordsFound, totalWordsMissed, totalWordsCompleted, totalWordsSkipped;
@synthesize shouldLetterRandomRotated;
@synthesize gameMaximumTime;
@synthesize labelCountdownStartGame, labelStartGameIn, imageLoading;
@synthesize labelPlaceScore;
@synthesize buttonSkipWord;


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
	
	// Tilt the "Found X of X words" label
	/*
	CGAffineTransform transform;
	transform = CGAffineTransformMakeRotation(0.04);
	labelCountOfMaxWordsFound.transform = transform;
	 */
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
	NSLog(@"iPhone recieved memory warning!!!");
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"GameScreen dealloc()");

	[arrayWordLetterButtons removeAllObjects];
	[arrayTaggedLetter removeAllObjects];
	[arrayWordLetterSlots removeAllObjects];
	[arrayGameLetters removeAllObjects];
	[arrayWordFound removeAllObjects];

/*	[arrayWordLetterButtons release];
	[arrayTaggedLetter release];
	[arrayWordLetterSlots release];
	[arrayGameLetters release];
	[arrayWordFound release];
*/	 
	self.arrayWordLetterButtons	= nil;
	self.arrayTaggedLetter		= nil;
	self.arrayWordLetterSlots	= nil;
	self.arrayGameLetters		= nil;
	self.arrayWordFound			= nil;
	
	[self.timerCountdown invalidate];
//	[self.timerCountdown release];
	self.timerCountdown = nil;
	
//	[gameWord release];
	self.gameWord = nil;
	
	self.labelPlaceScore			= nil;
	self.labelCountdownStartGame	= nil;
	self.labelStartGameIn			= nil;
	self.labelCountOfMaxWordsFound	= nil;
	self.labelPointDeduct			= nil;
	self.labelGameMode				= nil;
	self.labelLevel					= nil;
	self.labelNextLevelMinScore		= nil;
	self.labelCountdown				= nil;
	self.labelScore					= nil;
	self.labelPlayerScore			= nil;
	self.imageLoading				= nil;
	self.imageLetterBackground		= nil;
	self.imageLetterSlotBackground	= nil;
	self.imageBackground			= nil;
	self.buttonSpin					= nil;
	self.buttonCheckWord			= nil;
	self.buttonSkipWord				= nil;
	
    [super dealloc];
}



/*`
 ` Initialize game
 ` 1. We need to initialize all the letters and block images that are being used
 ` 2. We need to initialize the word database
 ` 3. Get the player current level (easy, medium, hard, etc)
 ` 4. Based on the player level, get the letter count, timer, etc
 ` 5. Generate a random word for this game
 ` 6. Place the placeholder images on the game screen
 ` 7. Start listening to player's touch events
 ` 8. Trigger the level countdown
 ` 9. Game ends when countdown reaches 0
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) initGame: (int) startGameMode {
	NSLog(@"initGame()");
	
	// Initialize the placeholder letter blocks and question mark images
	self.imageLetterSlotBackground		= [UIImage imageNamed:@"btnQuestion.png"];
	
	if(startGameMode == HARD)	self.imageLetterBackground		= [UIImage imageNamed:@"btnLetterUnderscore.png"];
	else						self.imageLetterBackground		= [UIImage imageNamed:@"btnLetter.png"];
	
	// Initialize database and game word
	[self initDatabase];
	
	// Intialize game objects
	arrayWordLetterButtons	= [NSMutableArray new];
	arrayTaggedLetter		= [NSMutableArray new];
	arrayWordLetterSlots	= [NSMutableArray new];
	arrayGameLetters		= [NSMutableArray new];
	arrayWordFound			= [NSMutableArray new];
	
	// Get current game mode and level
	[self initGameMode: startGameMode];
}

/*`
 ` Initialize the game database
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (BOOL) initDatabase {
	UIAppDelegate
	return [app initDatabase: DB_BEBA];
}

/*`
 ` Initialize game mode (easy, normal, hard, extreme)
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) initGameMode: (int) gameModeId {
	self.gameMode = gameModeId;
	NSString *gameModeDesc;
	
	switch(gameModeId) {
		case EASY:		gameModeDesc=GameModeFromId(gameModeId); self.gameMaximumTime=180; maxLevel=40; break;
		case NORMAL:	gameModeDesc=GameModeFromId(gameModeId); self.gameMaximumTime=180; maxLevel=100; break;
		case HARD:		gameModeDesc=GameModeFromId(gameModeId); self.gameMaximumTime=180; maxLevel=100; self.shouldLetterRandomRotated=TRUE; break;
		case TIME_CHALLENGE:	

			//[self.imageBackground setImage:[UIImage imageNamed:@"Game-Screen-Extreme.png"]];
			gameModeDesc = @"Score as much as you can before time runs out";
			self.gameMaximumTime=600;
			break;
	}
	
	[self.labelGameMode setText: gameModeDesc];
}

/*`
 ` Initialize game level. 1,2,3,4,5,6...
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) initGameLevel: (int) level {
	self.gameLevel = level;
	[self resetGame];
	
	// Update the screen labels
	//[self.labelNextLevelMinScore setText: [NSString stringWithFormat:@"%d", [self getLevelMinimumScore]]];
	[self.labelPlayerScore setText: StringFromInt(self.playerScore)];
	
	if(gameMode == TIME_CHALLENGE) {
		[self.labelPlaceScore setText:@"1st place score:"];	
		[self.labelLevel setText: @"Time Challenge"];
		
		UIAppDelegate
		int score = [app getFirstRankPlayerScore];
		[self.labelNextLevelMinScore setText: StringFromInt(score)];
	}
	else {
		[self.labelNextLevelMinScore setText: StringFromInt([self getLevelMinimumScore])  ];
		[self.labelLevel setText: [NSString stringWithFormat:@"Level %d", self.gameLevel]];
	}
	
	[labelStartGameIn setAlpha:1.0];
	[labelCountdownStartGame setAlpha:1.0];
	[imageLoading setAlpha:1.0];
	[labelCountdownStartGame setText:@"3"];
	[self.buttonSkipWord setEnabled:false];
	
	// Hides everything just in case it's shown
	for(int i=0; i<[arrayWordLetterButtons count]; i++)
	{
		[[arrayWordLetterButtons objectAtIndex:i] setHidden:true];
	}
	
	// Looks like we need to bring starting game in... layer to the front
	[self.view bringSubviewToFront:imageLoading];
	[self.view bringSubviewToFront:labelStartGameIn];
	[self.view bringSubviewToFront:labelCountdownStartGame];
	
	// Start the countdown until game starts
	timerStartGame = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(triggerTimerStartGame) userInfo:nil repeats:YES];
	
	NSLog(@"End of initGameLevel");
}

/*`
 ` Reset the game
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) resetGame {

	self.timeUntilLevelEnds		= self.gameMaximumTime; // Time in seconds
	self.childWords				= 0;
	self.countLetters			= 0;	
	secondsUntilGameStart		= 3;
	
	[self updateCountdown: timeUntilLevelEnds];
	
	// Refresh the list of words founded
	[self.arrayWordFound removeAllObjects];
	[self.arrayGameLetters removeAllObjects];
	[self.arrayTaggedLetter removeAllObjects];

	// Refresh images
	[self initQuestionMarkPlaceholder];
	[self initWordLetterPlaceholder];	
}


/*`
 ` Update the player score
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) updateCountdown: (int) timeRemaining {
	int minRemaining = timeRemaining / 60; // round it down
	int secRemaining = timeRemaining - (minRemaining*60);
	UIColor *red	= [UIColor redColor];
	UIColor *white	= [UIColor whiteColor];
	
	if(secRemaining < 10)
		[self.labelCountdown setText: [NSString stringWithFormat: @"%d:0%d", minRemaining, secRemaining]];
	else
		[self.labelCountdown setText: [NSString stringWithFormat: @"%d:%d", minRemaining, secRemaining]];
	
	// If countdown is only 10 seconds or less then create a blinking effect
	if(timeRemaining <= 10)
	{
		UIAppDelegate
		[app playSoundEffect:SOUND_FX_TIME];
		
		// Switch the red and white font to create a blinking effect
		if(self.labelCountdown.textColor != red)
			self.labelCountdown.textColor = red;
		else
			self.labelCountdown.textColor = white;
	}
	else
	{
		// Sometimes, rarely but it happens, the text will turn red at 0:00 and stay red for the next level
		// We'll just make sure it's switched back to white
		if(self.labelCountdown.textColor != white)
			self.labelCountdown.textColor = white;
	}
	

	[red release];
	[white	release];
}


/*`
 ` The start game countdown has triggered
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) triggerTimerStartGame {
	// We'll start the game in 3 seconds, but since the trigger will take 1 second
	// before it starts calling this function, we deducted the initial second from
	// the variable.
	
	secondsUntilGameStart--;
	
	NSLog(@"%d until game starts", secondsUntilGameStart);
	if(gamePaused == true) return;
	
	if(secondsUntilGameStart <= 0)
	{
		NSLog(@"Game starting...");
		secondsUntilGameStart = 3;
		[timerStartGame invalidate];
		timerStartGame = nil;
				
		[labelCountdownStartGame setText:@"0"];		
		labelScore.text			= @"";
		labelPointDeduct.text	= @"";
		
		// Hide the starting game timer labels
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration: 0.30]; // Number of seconds for animation
		[labelCountdownStartGame setAlpha:0.0];
		[labelStartGameIn setAlpha:0.0];
		[imageLoading setAlpha:0.0];
		[UIView commitAnimations];
		
		// Generate a new game word and start game countdown
		[self generateNewGameWord];
		[self startCountdownTimer];
		
	}
	else
		[labelCountdownStartGame setText:[NSString stringWithFormat:@"%d", secondsUntilGameStart]];
}


/*`
 ` Start the countdown timer in a new thread so the main thread can response faster and
 ` doesn't lock up touch events.
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) startCountdownTimer {
	//NSLog(@"Starting countdown timer");
	//Create a new thread
	//NSThread* timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(initAndStartTimer) object:nil];
	//[timerThread start];
	
	// Do processor intensive tasks here knowing that it will not block the main thread.
	[timerCountdown invalidate];
	[timerCountdown release];
	timerCountdown = nil;
	timerCountdown = [[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(triggerTimerCountdown:) userInfo:nil repeats:YES] retain];
	
	//[NSThread detachNewThreadSelector: @selector(initAndStartTimer) toTarget: self withObject: nil];
	//[[NSRunLoop currentRunLoop] addTimer:self.timerCountdown forMode: NSRunLoopCommonModes];
}

/*`
 ` Trigger timer countdown
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) triggerTimerCountdown: (NSTimer *) timer {
	// Decrement the timer
	self.timeUntilLevelEnds = self.timeUntilLevelEnds - 1;
	if(self.timeUntilLevelEnds <= 0) self.timeUntilLevelEnds = 0;
	
	NSLog(@"Time: %d", self.timeUntilLevelEnds);
	
	[self updateCountdown: self.timeUntilLevelEnds];
	
	
	
	
	static BOOL timeChallengeUpdated = false;

	// 2 minutes left in the time challenge and we're going to rotate the letters
	if(timeChallengeUpdated==false && self.gameMode == TIME_CHALLENGE && timeUntilLevelEnds <= 120) {
		timeChallengeUpdated = true;
		self.shouldLetterRandomRotated	= TRUE;
		self.imageLetterBackground		= nil;
		self.imageLetterBackground		= [UIImage imageNamed:@"btnLetterUnderscore.png"];
		
			// Switch the backgrounds to have the underscore
			for(int i=0; i<[self.arrayWordLetterButtons count]; i++)
			{
				UIButton *button = [self.arrayWordLetterButtons objectAtIndex:i];
				[button setBackgroundImage: self.imageLetterBackground forState:UIControlStateNormal];		
			}
		
	}
	
	
	
	// If the countdown reaches 0 then end the level
	if(self.timeUntilLevelEnds <= 0) {
		[self.timerCountdown invalidate];
		self.timerCountdown = nil;
		[self continueToNextLevel];
	}
}


/*`
 ` Get the level minimum score
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (int) getLevelMinimumScore {
	// We need to get all the possible words for the level current word.
	// Then, calculate the score for each word. The level minimum score should
	// be easy(30%), medium(50%), hard(80%)
	int minimumScore 	= 0;
	int baseScore		= 600;
	int extraScore		= 0;
	
	switch(self.gameMode) {
		case EASY:				baseScore = 180; break;
		case NORMAL:			baseScore = 240; break;
		case HARD:				baseScore = 360; break;
		case TIME_CHALLENGE:	baseScore = 999999999; break;
	}
	
	if(self.gameLevel > 8)	extraScore = 20;
	if(self.gameLevel > 15)	extraScore = 30;
	if(self.gameLevel > 20)	extraScore = 40;
	if(self.gameLevel > 30)	extraScore = 50;
	if(self.gameLevel > 40)	extraScore = 60;
	if(self.gameLevel > 50)	extraScore = 100;
	if(self.gameLevel > 60)	extraScore = 120;
	if(self.gameLevel > 70)	extraScore = 130;
	if(self.gameLevel > 80)	extraScore = 140;
	if(self.gameLevel > 90)	extraScore = 150;
	
	
	minimumScore = (self.gameLevel * baseScore) + (extraScore * self.gameLevel);
	return minimumScore;
}


/*`
 ` Generate a new game word
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) generateNewGameWord {
	NSLog(@"generateNewGameWord()");
	// Initialize game images placeholder
	[self initGameWord];
	[self initQuestionMarkPlaceholder];
	[self initWordLetterPlaceholder];
	
	// Spin the letters for the first time
	[self spinLetters];
	[self resetLetters];
	
	[self.buttonSkipWord setEnabled:true];
	// Hides everything just in case it's hidden
	for(int i=0; i<[arrayWordLetterButtons count]; i++)
	{
		[[arrayWordLetterButtons objectAtIndex:i] setHidden:false];
	}
	NSLog(@"End of generateNewGameWord");
}

/*`
 ` Return a random game word chosen from the database
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) initGameWord {
	// We'll have to make a connection to the database and select a random word to use in
	// our game. We'll only select ONE word from the list.
	NSLog(@"Starting to call getRandWord");

	NSDictionary* newGameWordData = [self getRandomWordFromDb];
	
	self.gameWord		= [newGameWordData objectForKey:@"GameWord"];
	self.childWords		= [[newGameWordData objectForKey:@"ChildWords"] intValue];
	childWords3			= [[newGameWordData objectForKey:@"Words3"] intValue];
	childWords4			= [[newGameWordData objectForKey:@"Words4"] intValue];
	childWords5			= [[newGameWordData objectForKey:@"Words5"] intValue];
	childWords6			= [[newGameWordData objectForKey:@"Words6"] intValue];
	self.countLetters	= [self.gameWord length];
	
	[newGameWordData release];
	
	// Refresh the list of words founded
	[self.arrayWordFound removeAllObjects];
	[self.arrayGameLetters removeAllObjects];
	
	// Update the labels
	[self.labelCountOfMaxWordsFound setText:[NSString stringWithFormat:@"Found 0 of %d words", self.childWords]];
	
	NSRange range;
	for(int i=0; i<self.countLetters; i++)
	{
		range = NSMakeRange(i, 1);
		[arrayGameLetters addObject: [self.gameWord substringWithRange:range ]];   // NSMakeRange (index, len)
	}
	
	NSLog(@"end of initGameWord");
}

/*`
 ` Return a random game word chosen from the database
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (NSDictionary *) getRandomWordFromDb {
	NSLog(@"Getting word from db");
	
	int wordId = arc4random() % TOTAL_6_LETTER_WORDS_IN_DICTIONARY + 1;
	
	// Initialize the query
	NSString *sql = [NSString stringWithFormat:@"SELECT GameWord, Words, Words3, Words4, Words5, Words6 FROM Word WHERE Id=%d", wordId];
	NSString *word;
	sqlite3_stmt *statement;
	int words=0, words3=0, words4=0, words5=0, words6=0;

	// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library,
	// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
	if(sqlite3_prepare_v2(global_bebaDb, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		// We "step" through the results - once for each row.
		while(sqlite3_step(statement) == SQLITE_ROW)
		{
			// The second parameter indicates the column index into the result set.
			word = [NSString stringWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
			words	= sqlite3_column_int(statement, 1);
			words3	= sqlite3_column_int(statement, 2);
			words4	= sqlite3_column_int(statement, 3);
			words5	= sqlite3_column_int(statement, 4);
			words6	= sqlite3_column_int(statement, 5);
		}
		
		// "Finalize" the statement - release the resources associated with the statement.
		sqlite3_finalize(statement);
	}
	//else
	//	NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_bebaDb));
	
	NSLog(@"Database picked the word: %@", word);

	return [[NSDictionary alloc] initWithObjectsAndKeys: word, @"GameWord", NumberFromInt(words), @"ChildWords", NumberFromInt(words3), @"Words3",
			NumberFromInt(words4), @"Words4", NumberFromInt(words5), @"Words5", NumberFromInt(words6), @"Words6", nil];
}

/*`
 ` Places the question mark images on the game board
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) initQuestionMarkPlaceholder {
	NSLog(@"Placing question mark images on the gameboard");
	
	// Remove all the buttons already created
	// If we start a new game level and we don't remove the buttons already created, we will
	// end up with more buttons then we needed.
	
	int positionY = 65; //= 188;
	int positionX = 8;
	
	if([arrayWordLetterSlots count])
	{	
		for(int i=0; i<[arrayWordLetterSlots count]; i++)
		{
			// Create a button
			UIButton *button = [arrayWordLetterSlots objectAtIndex:i];
			
			// Set the button background image
			[button setBackgroundImage: self.imageLetterSlotBackground forState:UIControlStateNormal];
			[button setTag: -1];
		}
	}
	else
	{
		for(int i=0; i<self.countLetters; i++)
		{
			// Create a button
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			
			// Set the position of the button
			button.frame = CGRectMake(positionX + (i * 66), positionY, 59, 59); // (x, y, width, height)
			
			// Set the button background image
			[button setBackgroundImage: self.imageLetterSlotBackground forState:UIControlStateNormal];
			[button setTag: -1];
			
			// Add the button to the view
			[self.view addSubview:button];
			[self.arrayWordLetterSlots addObject: button];
		}
	}
}

/*`
 ` Places the question mark images on the game board
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) initWordLetterPlaceholder {
	NSLog(@"Placing letter block placeholder images on the gameboard");
	// Remove all the buttons already created
	// If we start a new game level and we don't remove the buttons already created, we will
	// end up with more buttons then we needed.
	
	/*
	 * Now we'll create a loop and create the UIButton Object for each letter on the Game Board.
	 **/
	int firstLetterXPosition = SCREEN_WIDTH - (self.countLetters * (BUTTON_LETTER_WIDTH + BUTTON_LETTER_SPACING));
	firstLetterXPosition = firstLetterXPosition / 2;
	
	int positionY = BUTTON_LETTER_POSITIONY ;
	UIButton *button;
	
	if([arrayWordLetterButtons count]==0)
	{
		for(int i=0; i<self.countLetters; i++)
		{
			// Create a button
			button = [UIButton buttonWithType:UIButtonTypeCustom];
			
			/* randomly tilt the button to create a hard level effect */
			//positionY = 5+ arc4random() % 20;
			//positionY = 10;
			// Set the position of the button
			button.frame = CGRectMake(firstLetterXPosition + ( [self.arrayWordLetterButtons count] * (BUTTON_LETTER_WIDTH + BUTTON_LETTER_SPACING)), positionY, BUTTON_LETTER_WIDTH, BUTTON_LETTER_HEIGHT); // (x, y, width, height)
			
			// Listen for clicks
			[button addTarget:self action:@selector(buttonLetterPressed:) forControlEvents:UIControlEventTouchUpInside];
			[button setContentMode:UIViewContentModeCenter];
			[button setBackgroundImage: self.imageLetterBackground forState:UIControlStateNormal];

			button.tag	 = i;
			button.showsTouchWhenHighlighted = true;
			
			//add the button to the view
			[self.view addSubview:button];
			[self.arrayWordLetterButtons addObject: button];		
		}
	}
}

/*`
 ` Spin and rotate the letters on the game board
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) spinLetters {
	NSLog(@"Spinning Letters on Game Board");
	
	NSMutableArray *copyOfArrayGameLetters = [[NSMutableArray alloc] initWithArray: self.arrayGameLetters];
	UIButton	*button;
	UIImage		*image;
	NSString	*letterImage;
	NSString	*letter;
	int randomNumber;
	int rotationDegree;
	int count = [self.arrayWordLetterButtons count];
	
	// To transform the letter buttons
	CGAffineTransform transform;
	
	// We'll loop through all the letter buttons on the board and random pick
	// a new letter for each one.
	for(int i=0; i<count; i++)
	{
		randomNumber	= arc4random() % [copyOfArrayGameLetters count];
		letter			= [copyOfArrayGameLetters objectAtIndex: randomNumber];
		letterImage		= [NSString stringWithFormat: @"%@.png", letter];
		
		// Now that we used that letter, let's remove it.
		[copyOfArrayGameLetters removeObjectAtIndex: randomNumber];
		
		// Get the image for the letter picked and assign it to the button
		image = [UIImage imageNamed: letterImage];
		
		button = [self.arrayWordLetterButtons objectAtIndex: i];
		[self.arrayTaggedLetter insertObject:letter atIndex: button.tag];
		[button setImage:image forState:UIControlStateNormal];
		
		//[image release];
		
		// Randomly tilt the button to create a hard level effect
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration: 0.2]; // Number of seconds for animation
		
		// If the letters should be randomly rotated to create the "hard level" effect
		// then we'll start with it being at 0 position and rotate it to the random position.
		// Otherwise, we'll start at a random position and rotate it back to the 0 position.
		if(self.shouldLetterRandomRotated == TRUE)
		{
			// If it's the hard level then only rotate up to 3 degrees, otherwise rotate up to 5
			if(self.gameMode == HARD) rotationDegree = 3; else rotationDegree = 5;
			
			transform = CGAffineTransformMakeRotation(0);
			button.transform = transform;	
			transform = CGAffineTransformMakeRotation(arc4random() % rotationDegree);
			button.transform = transform;
		}
		else
		{
			transform = CGAffineTransformMakeRotation(arc4random()%5);
			button.transform = transform;	
			transform = CGAffineTransformMakeRotation(0);
			button.transform = transform;	
		}
		
		[UIView commitAnimations];
	}
	
	// Release the temporary copy	
	[copyOfArrayGameLetters release];
}

/*`
 ` Check the accuracy of the current word entered by the player. If the word is found in the
 ` dictionary, the player scores. Otherwise, an alert will prompt the player that the word
 ` does not exist.
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) resetLetters {
	NSLog(@"resetLetters()");
	int count;
	UIButton *button;

	// Reset all placeholder letter images with the original Question Mark image
	count = [self.arrayWordLetterSlots count];
	for(int i=0; i<count; i++)
	{
		button = [self.arrayWordLetterSlots objectAtIndex: i];
		[button setBackgroundImage: self.imageLetterSlotBackground forState:UIControlStateNormal];
		[button setImage:nil forState:UIControlStateNormal];
		[button setTag: -1];
	}
	
	// Reset the hit buttons to it's original opacity and re-enable it's touch events
	count = [self.arrayWordLetterButtons count];
	for(int i=0; i<count; i++)
	{
		button = [self.arrayWordLetterButtons objectAtIndex: i];
		[button setAlpha: 1.0];
		[button setUserInteractionEnabled: true];
	}
	
	NSLog(@"End of resetLetters");
}


/*`
 ` Continue to next level
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) continueToNextLevel {
	NSLog(@"continueToNextLevel()");
	
	[timerStartGame invalidate];
	[self.timerCountdown invalidate];
	timerStartGame = nil;
	self.timerCountdown = nil;
	
	
	// If the player score meets the minimum score to exceed to the next level
	// then we will proceed. Otherwise, the game will end.
	if(self.playerScore >= [self getLevelMinimumScore]) {
		// Display a random winner message and proceed to the next level.
		NSLog(@"You did it. Next level here we come...");
		UIAppDelegate
		
		self.gameLevel++;
		
		// If the player completed the game then show the Winner screen otherwise
		// show the next level screen
		if(gameLevel > maxLevel)
		{
			// Initialize the winner screen
			[app initXibScreen: WINNER_SCREEN];
			[app.viewWinnerScreen.labelCompleted setText:[NSString stringWithFormat:@"You completed the \"%@\" mode", GameModeFromId(gameMode)]];
			[app.viewWinnerScreen.labelScore setText:[NSString stringWithFormat:@"High score: %d", self.playerScore]];
			[app viewTransition: [app addressOf_viewGameScreen]: [app addressOf_viewWinnerScreen]: true];
		}
		else
		{
			[self resetLetters];
			// Initialize the end game screen
			[app initXibScreen: NEXT_LEVEL_SCREEN];
			[app.viewNextLevelScreen.labelLevel setText: StringFromInt(self.gameLevel)];
			[app.viewNextLevelScreen saveGame]; // auto-save		
			[app.viewNextLevelScreen.view setAlpha:0.0];
			[app.window addSubview: [app.viewNextLevelScreen view]]; // add the view to the window
		
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration: VIEW_ANIMATION_DURATION]; // Number of seconds for animation
			[app.viewNextLevelScreen.view setAlpha: 0.90];
			[UIView commitAnimations];
		}
	}
	else {
		// Display a random loser message and end the game.
		NSLog(@"Sorry, you didn't meet the minimum score this time. Try again.");
		[self quitGame];
		[self closePauseScreenIfRequired];
		[self endGame];
	}
	
	NSLog(@"End of continue to next level..");
}

/*`
 ` If the pause screen is still hanging around, we want to close it
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) closePauseScreenIfRequired {
	UIAppDelegate
	
	if(app.viewPausedScreen)
	{
		UIViewController **viewPointer;
		UIViewController *view;
		
		[app.viewPausedScreen.view removeFromSuperview];
		viewPointer = [app addressOf_viewPausedScreen];
		view = *viewPointer;
		[view release];
		*viewPointer = nil;
	}
}

/*`
 ` Quit current game, invalidate objects and timers
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) quitGame {
	[timerStartGame invalidate];
	[timerCountdown invalidate];
	[timerCountdown release];
	
	timerStartGame = nil;
	timerCountdown = nil;
}

/*`
 ` End game
 ` This function is called when the player cannot meet the minimum score to go to the
 ` next level. The end screen should display the player's top score and stats such as player
 ` level, words found, words missed, number of minutes played, see online top score list,
 ` post your score online.
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) endGame {
	NSLog(@"Ending game");
	UIAppDelegate
		
	// Update the player stats
	[global_lastGameData setObject: NumberFromInt(self.playerScore)			forKey:GAME_DATA_PLAYER_SCORE];
	[global_lastGameData setObject: NumberFromInt(self.gameLevel)			forKey:GAME_DATA_GAME_LEVEL];
	[global_lastGameData setObject: NumberFromInt(self.totalWordsFound)		forKey:GAME_DATA_WORDS_FOUND];
	[global_lastGameData setObject: NumberFromInt(self.totalBonusWords)		forKey:GAME_DATA_BONUS_WORDS];
	[global_lastGameData setObject: NumberFromInt(self.totalWordsSkipped)	forKey:GAME_DATA_WORDS_SKIPPED];
	[global_lastGameData setObject: NumberFromInt(self.totalWordsMissed)	forKey:GAME_DATA_WORDS_MISSED];
	[global_lastGameData setObject: NumberFromInt(self.totalWordsCompleted)	forKey:GAME_DATA_WORDS_COMPLETED];	
	[global_lastGameData setObject: NumberFromInt(self.gameMode)			forKey:GAME_DATA_GAME_MODE];
	
	// Initialize the end game screen
	[app playSoundEffect: SOUND_FX_LOST];
	[app initXibScreen: END_GAME_SCREEN];
	[app viewTransition: [app addressOf_viewGameScreen]: [app addressOf_viewEndScreen]: true];
}

/*`
 ` Skip the current game word
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) skipWord {
	UIAppDelegate
	
	// If we don't have a word yet, then don't do anything. Just return.
	// The game might not even started yet.
	if([self.gameWord length]==0) return;
	
	// Decide if we want to deduct the player score for skipping a word
	int pointToDeduct = self.playerScore * 0.05;
	if(pointToDeduct < 5) pointToDeduct = 5;
	else if(pointToDeduct > 250) pointToDeduct = 250;
	
	// Increase the number of times player skipped words
	self.totalWordsSkipped++;
	self.totalWordsMissed += (self.childWords - [self.arrayWordFound count]);
	self.playerScore -= pointToDeduct;
	
	[self adjustPlayerScore: self.playerScore];
	[app playSoundEffect:SOUND_FX_SPIN];
	
	// Generate a new game word
	[self generateNewGameWord];	

	// Point deduction animation
	self.labelPointDeduct.text = [NSString stringWithFormat: @"-%d", pointToDeduct];
	
	CGAffineTransform transform;
	transform = CGAffineTransformMakeScale(10.0, 10.0);
	self.labelPointDeduct.transform = transform;
	[self.labelPointDeduct setAlpha: 0.00];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration: 0.15]; // Number of seconds for animation
	transform = CGAffineTransformMakeScale(1.0, 1.0);
	self.labelPointDeduct.transform = transform;
	[self.labelPointDeduct setAlpha: 1.00];
	[UIView commitAnimations];
	
}

/*`
 ` The player pressed the letter to guess a word
 ``````````````````````````````````````````````````````````````````````````````````````````*/
-(void) buttonLetterPressed: (id) sender {
	UIAppDelegate
	[app playSoundEffect: SOUND_FX_TOUCH];
	
	[sender setAlpha: 0.40];
	[sender setUserInteractionEnabled: false];
		
	UIButton *currentButton;
	int tag					= [sender tag];
	NSString *letter		= [self.arrayTaggedLetter objectAtIndex: tag];
	NSString *pickedLetter	= [NSString stringWithFormat: @"%@.png", letter];	
	UIImage *image			= [UIImage imageNamed: pickedLetter];
	int letterGuessed		= 0;
	
	for(int i=0; i< self.countLetters; i++)
	{
		currentButton = [self.arrayWordLetterSlots objectAtIndex: i];
		
		if(currentButton.tag < 0)
		{
			letterGuessed++;
			currentButton.tag = tag;
			[currentButton setImage:image forState:UIControlStateNormal];
			[currentButton setBackgroundImage:imageLetterBackground	forState: UIControlStateNormal];
			break;
		}
		else
			letterGuessed++;
	}

	// If we have all available letters used then auto-check
	if(letterGuessed == countLetters)
		[self checkWordAccuracy];
}

/*`
 ` Check a word to see if the player have already founded that word
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (BOOL) isWordAlreadyFound: (NSString *) word {
	int count = [self.arrayWordFound count];
	NSString *wordFounded;
	
	for(int i=0; i<count; i++)
	{
		wordFounded = [self.arrayWordFound objectAtIndex: i];
		
		// If the word is already founded
		if([word isEqualToString: wordFounded]) return true;
	}
	
	return false;
}

/*`
 ` Adjust the player score
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) adjustPlayerScore: (int) newScore {
	if(newScore < 0) newScore = 0;
	self.playerScore = newScore;
	[self.labelPlayerScore setText: StringFromInt(newScore) ];
}

/*`
 ` Spin the letters on the game board
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) spin {
	UIAppDelegate
	[app playSoundEffect: SOUND_FX_TOUCH];
	
	CGAffineTransform transform;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration: 0.15]; // Number of seconds for animation
		transform = CGAffineTransformMakeScale(0.1, 0.1);
		self.buttonSpin.transform = transform;
		transform = CGAffineTransformMakeScale(1.0, 1.0);
		self.buttonSpin.transform = transform;
	[UIView commitAnimations];
	
	[self spinLetters];
	[self resetLetters];
}

/*`
 ` Update the player score
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) updatePlayerScore: (int) score {
	self.playerScore += score;
	[self.labelPlayerScore setText: StringFromInt(self.playerScore) ];
	NSLog(@"%d", self.playerScore);
}

/*`
 ` Get the current word guessed by the player
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (NSString *) getCurrentGuessedWord {
	int tag = 0;
	
	NSString *letter;
	UIButton *button;
	NSMutableString	*guessedWord = [NSMutableString new];
	
	// Loop through all the letter placeholder to determine the guessed word
	while(tag < self.countLetters)
	{
		button = [self.arrayWordLetterSlots objectAtIndex: tag];
		
		// If the button image is assigned a letter then we'll add that character to the word
		if(button.tag > -1)
		{
			letter = [self.arrayTaggedLetter objectAtIndex: button.tag];
			[guessedWord appendString: letter];
		}
		
		tag++;
	}
	
	NSString *word = [NSString stringWithFormat:@"%@", guessedWord];
	[guessedWord release];
	return word;
}

/*`
 ` Get score for word found
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (int) getWordScore: (NSString *) word {
	int len			= [word length];
	int baseScore	= 30;
	int bonusPoints;
	
	switch (len) {
		case 3: baseScore = 5; break;
		case 4: baseScore = 5; break;
		case 5: baseScore = 8; break;
		case 6: baseScore = 10; break;
		default: baseScore = 0; break;
	}
	
	int score = len * baseScore;
	bonusPoints = score * 0.5;
	
	// If the word found if the exact length of the current amount of available
	// letters on the game board then apply bonus points
	if(len == self.countLetters)
		score += bonusPoints;
	
	return score;
}



/*`
 ` Check the Word database to determine whether the word exist
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (BOOL) checkWordDictionary: (NSString *) word {
	// Initialize the query
	NSString *sql	= [NSString stringWithFormat:@"SELECT Id FROM Word WHERE GameWord='%@'", word];
	int	wordId		= 0;
	sqlite3_stmt *statement;

	// Preparing a statement compiles the SQL query into a bbyte-code program in the SQLite library,
	// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
	if(sqlite3_prepare_v2(global_bebaDb, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		// We "step" through the results - once for each row.
		while(sqlite3_step(statement) == SQLITE_ROW)
			wordId = sqlite3_column_int(statement, 0);
		
		// "Finalize" the statement - release the resources associated with the statement.
		sqlite3_finalize(statement);
	}
//	else
//		NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_bebaDb));

	if(wordId > 0)	return true;
	return false;
}

/*`
 ` Flash the score on the display screen
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void) flashWordScore: (NSString *) word: (int) score {
	NSLog(@"Flashing score on the screen");
	
	if(score == 0)
		self.labelScore.text = word;
	else
	{
		self.labelScore.text = [NSString stringWithFormat: @"Got %d points for %@", score, word];
		CGAffineTransform transform;
		transform = CGAffineTransformMakeScale(20.0, 20.0);
		self.labelScore.transform = transform;
		[self.labelScore setAlpha: 0.00];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration: 0.15]; // Number of seconds for animation
		transform = CGAffineTransformMakeScale(1.0, 1.0);
		self.labelScore.transform = transform;
		[self.labelScore setAlpha: 1.00];
		[UIView commitAnimations];
	}
}

/*`
 ` Check the accuracy of the current word entered by the player. If the word is found in the
 ` dictionary, the player scores. Otherwise, an alert will prompt the player that the word
 ` does not exist.
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) checkWordAccuracy {
	// Check to see if we still have a valid countdown time remaining. The player can check
	// a word at the last second. We do NOT want to score if the player checked the word
	// with a time remaining of 0.
	if(self.timeUntilLevelEnds <= 0) return;
	
	// Hide the point deduction label
	[self.labelPointDeduct setAlpha: 0.0];
	
	NSString *word	= [self getCurrentGuessedWord];
	
	// If the player didn't select a word, just prompt them to do so.
	if([word length]==0)
		[self flashWordScore: @"No word to check": 0];
	else if([word length]<=2)
		[self flashWordScore: @"Need at least 3 letters": 0];		
	else
	{
		UIAppDelegate
		
		// If the player have already founded this word then prompt them.
		if([self isWordAlreadyFound: word] == true)
		{
			[self flashWordScore: [NSString stringWithFormat:@"You have already found %@", word]: 0];
			[app playSoundEffect: SOUND_FX_TOUCH];
		}
		else
		{
			// Check to see if the word exist in the dictionary
			BOOL accurate = [self checkWordDictionary: word];
			
			if(accurate) {
				
				// Add the word to the list player have founded
				[self.arrayWordFound addObject: word];
				
				int score = [self getWordScore: word];
				self.totalWordsFound++;
				[self flashWordScore: word: score];
				[self updatePlayerScore: score];
				
				// Update the labels
				[self.labelCountOfMaxWordsFound setText:[NSString stringWithFormat:@"Found %d of %d words", [self.arrayWordFound count], self.childWords]];
				
				// If player founded a word with all available characters, then play the bonus sound effect
				// Otherwise, play the regular score sound effect
				if([word length] == self.countLetters) {
					self.totalBonusWords++;
					[app playSoundEffect: SOUND_FX_BONUS];
				}
				else
					[app playSoundEffect: SOUND_FX_SCORE];
				
				// If the player found all the child words for this word
				if(self.childWords == [arrayWordFound count])
				{
					int bonusPoints = childWords * 2 + 250;
					if(bonusPoints > 500) bonusPoints = 500;
					[self updatePlayerScore: bonusPoints];
					
					// Nore more words, so generate a new parent game word
					[self flashWordScore: [NSString stringWithFormat:@"Congratulations, you found all %d words. Got %d bonus points!", childWords, bonusPoints]: 0];
					self.totalWordsCompleted++;
					
					[self generateNewGameWord];
				}
			}
			else {
				// The word is not found in the database, so prompt the player.
				[self flashWordScore: [NSString stringWithFormat:@"%@ not found", word]: 0];
				[app playSoundEffect: SOUND_FX_TOUCH];
			}
		}
	}
	
	[self resetLetters];
}

/*`
 ` We're not using the default TouchUp event because we only wanted a portion of the 'spin'
 ` image to trigger the action.
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {  
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [self view]];
	
	// If we're touching inside the spin button bounds 
	if(point.x>=25 && point.x<=130 && point.y>=170 && point.y<=240) {
		[self spin];
	}
}  

/*`
 ` The player paused the game
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) pauseGame {
	// Make sure that if we're playing the Time Challenge mode, the countdown timer continues
	// to run in the background. We do not want the player to pause in Time Challenge mode.
	UIAppDelegate

	gamePaused = true;
	
	if(gameMode != TIME_CHALLENGE) {
		[timerCountdown invalidate];
		[timerCountdown release];
		timerCountdown = nil;
	}
	
	// Initialize the end game screen
	[app initXibScreen: PAUSED_SCREEN];
	
	int found3Words=0, found4Words=0, found5Words=0, found6Words=0, length=0;
	NSString *word;
	
	// Get total found
	for(int i=0; i<[arrayWordFound count]; i++)
	{
		word	= [arrayWordFound objectAtIndex:i];
		length	= [word length];
		
		switch (length) {
			case 3: found3Words++; break;
			case 4: found4Words++; break;
			case 5: found5Words++; break;
			case 6: found6Words++; break;
		}
	}

	if(gameMode == TIME_CHALLENGE) {
		[app.viewPausedScreen.labelGamePaused setText:@"Game Info"];
		[app.viewPausedScreen.labelGameRunning setHidden:false];
	}
	
	[app.viewPausedScreen.labelFoundWord6 setText:[NSString stringWithFormat:@"%d of %d", found6Words, childWords6]];
	[app.viewPausedScreen.labelFoundWord5 setText:[NSString stringWithFormat:@"%d of %d", found5Words, childWords5]];
	[app.viewPausedScreen.labelFoundWord4 setText:[NSString stringWithFormat:@"%d of %d", found4Words, childWords4]];
	[app.viewPausedScreen.labelFoundWord3 setText:[NSString stringWithFormat:@"%d of %d", found3Words, childWords3]];
	[app.viewPausedScreen.labelWordsRemaining setText:StringFromInt(childWords - [arrayWordFound count])];
	[app viewTransition: [app addressOf_viewGameScreen]: [app addressOf_viewPausedScreen]: false];
}

/*`
 ` Resume a paused game
 ``````````````````````````````````````````````````````````````````````````````````````````*/
- (IBAction) resumeGame {
	gamePaused = false;
	[self startCountdownTimer];
}















































/*
- (void) initAndStartTimer {
	NSLog(@"initAndStartTimer");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
	
    // Do processor intensive tasks here knowing that it will not block the main thread.
	[self.timerCountdown invalidate];
	 self.timerCountdown = nil;
	 self.timerCountdown = [[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(triggerTimerCountdown:) userInfo:nil repeats:YES] retain];
	 
	[runLoop run];
	[pool release];
	NSLog(@"End of timer");
}


//`
// ` Return a random game word chosen from the database
// ``````````````````````````````````````````````````````````````````````````````````````````
- (NSString *) getRandomWordFromDb_XXX: (int)x {
	// We'll have to make a connection to the database and select a random word to use in
	// our game. We'll only select ONE word from the list.
//	NSLog(@"Getting word from db");
	
	int wordId = x; //arc4random() % TOTAL_6_LETTER_WORDS_IN_DICTIONARY + 1;
	
	// Initialize the query
	NSString *sql = [NSString stringWithFormat:@"SELECT GameWord FROM Word WHERE Id<=15230 AND Words IS NULL LIMIT 1", wordId];
	NSString *word;
	sqlite3_stmt *statement;
	int found = 0;

	
//	NSLog(@"here");
	// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library,
	// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
	if(sqlite3_prepare_v2(global_bebaDb, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		NSLog(@"-----------");
		// We "step" through the results - once for each row.
		while(sqlite3_step(statement) == SQLITE_ROW)
		{
//			NSLog(@"--------Trying to get word from database");
			// The second parameter indicates the column index into the result set.
			word = [NSString stringWithUTF8String: (char *) sqlite3_column_text(statement, 0)];
			found++;
		}
//		NSLog(@"***************");
		// "Finalize" the statement - release the resources associated with the statement.
		sqlite3_finalize(statement);
	}
	else
		NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_bebaDb));
	
//	NSLog(@"$$$$$$$$$$$$$");
	if(! word) word = @"";
	
//	NSLog(@"Database picked the word: %@, founded: %d", word, found);
	return word;
}


//`
// ` Loop through the array and release all objects before removing it's reference from the array
// ``````````````````````````````````````````````````````````````````````````````````````````
- (void) removeAndReleaseAll: (NSMutableArray *) arrayItems: (int) itemType {
//	NSLog(@"removeAndReleaseAll()");
	id object;
//	NSLog(@"here");
	while([arrayItems count] > 0)
	{
		object = [arrayItems objectAtIndex: 0];
		
		if(object) {
			switch (itemType) {
				case TYPE_STRING:	{ [object release]; break; }
				case TYPE_BUTTON:	{ [object removeFromSuperview]; break; }
				case TYPE_IMAGE:	{ [object removeFromSuperview]; break; }
				case TYPE_LABEL:	{ [object removeFromSuperview]; break; }
			}
			
//			NSLog(@"object releaseed");
		}
		
				[arrayItems removeObjectAtIndex: 0];
	}
	
//	NSLog(@"end of removeAndReleaseAll()");
}


//
// ` Return a random game word chosen from the database
// ``````````````````````````````````````````````````````````````````````````````````````````
- (void) initGameWord_XXX {
	// We'll have to make a connection to the database and select a random word to use in
	// our game. We'll only select ONE word from the list.
//	for(int x=1; x<=TOTAL_6_LETTER_WORDS_IN_DICTIONARY; x++)
	NSLog(@"initGamweWordXXXXXXXXXXXX");
	while(true)
	{
		self.gameWord		= [self getRandomWordFromDb_XXX : 280];
		self.countLetters	= [self.gameWord length];
		if(countLetters <=0 ) break;
	
	// Refresh the list of words founded
	[self.arrayWordFound removeAllObjects];
	
	//NSLog(@"releasing arrayGameLetters");
	//	[self removeAndReleaseAll: self.arrayGameLetters: TYPE_STRING];
	[self.arrayGameLetters removeAllObjects];
	//NSLog(@"releasing arrayTag");
	[self.arrayTaggedLetter removeAllObjects];
	//[self removeAndReleaseAll: self.arrayTaggedLetter: TYPE_STRING];
	
	
	for(int i=0; i< self.countLetters; i++)
	{
		NSString *letter = [self.gameWord substringWithRange:NSMakeRange(i, 1)];  // NSMakeRange (index, len)
		[self.arrayGameLetters addObject: letter]; 
	}
	
		[self test];
	}
	
	
	
	NSLog(@"end of initGameWord");
}


-(void) test {
	NSLog(self.gameWord);
	//	NSMutableString	*sql = [NSMutableString new];
	NSString *subsql;
	NSString *subsql2;
	NSString *subsql3;
	NSString *subsql4;
	NSString *subsql5;
	NSString *subsql6;
	
	subsql = [NSString stringWithFormat:@"(L1='%@' OR L1='%@' OR L1='%@' OR L1='%@' OR L1='%@' OR L1='%@' OR L1 IS NULL)", 
			  [arrayGameLetters objectAtIndex:0],  [arrayGameLetters objectAtIndex:1],[arrayGameLetters objectAtIndex:2],[arrayGameLetters objectAtIndex:3],[arrayGameLetters objectAtIndex:4],[arrayGameLetters objectAtIndex:5]
			  ];
	subsql2 = [NSString stringWithFormat:@"(L2='%@' OR L2='%@' OR L2='%@' OR L2='%@' OR L2='%@' OR L2='%@' OR L2 IS NULL)", 
			   [arrayGameLetters objectAtIndex:0],  [arrayGameLetters objectAtIndex:1],[arrayGameLetters objectAtIndex:2],[arrayGameLetters objectAtIndex:3],[arrayGameLetters objectAtIndex:4],[arrayGameLetters objectAtIndex:5]
			   ];
	subsql3 = [NSString stringWithFormat:@"(L3='%@' OR L3='%@' OR L3='%@' OR L3='%@' OR L3='%@' OR L3='%@' OR L3 IS NULL)", 
			   [arrayGameLetters objectAtIndex:0],  [arrayGameLetters objectAtIndex:1],[arrayGameLetters objectAtIndex:2],[arrayGameLetters objectAtIndex:3],[arrayGameLetters objectAtIndex:4],[arrayGameLetters objectAtIndex:5]
			   ];
	subsql4 = [NSString stringWithFormat:@"(L4='%@' OR L4='%@' OR L4='%@' OR L4='%@' OR L4='%@' OR L4='%@' OR L4 IS NULL)", 
			   [arrayGameLetters objectAtIndex:0],  [arrayGameLetters objectAtIndex:1],[arrayGameLetters objectAtIndex:2],[arrayGameLetters objectAtIndex:3],[arrayGameLetters objectAtIndex:4],[arrayGameLetters objectAtIndex:5]
			   ];
	subsql5 = [NSString stringWithFormat:@"(L5='%@' OR L5='%@' OR L5='%@' OR L5='%@' OR L5='%@' OR L5='%@' OR L5 IS NULL)", 
			   [arrayGameLetters objectAtIndex:0],  [arrayGameLetters objectAtIndex:1],[arrayGameLetters objectAtIndex:2],[arrayGameLetters objectAtIndex:3],[arrayGameLetters objectAtIndex:4],[arrayGameLetters objectAtIndex:5]
			   ];
	subsql6 = [NSString stringWithFormat:@"(L6='%@' OR L6='%@' OR L6='%@' OR L6='%@' OR L6='%@' OR L6='%@' OR L6 IS NULL)", 
			   [arrayGameLetters objectAtIndex:0],  [arrayGameLetters objectAtIndex:1],[arrayGameLetters objectAtIndex:2],[arrayGameLetters objectAtIndex:3],[arrayGameLetters objectAtIndex:4],[arrayGameLetters objectAtIndex:5]
			   ];
	
	NSString *sql = [NSString stringWithFormat: @"SELECT Id,L1,L2,L3,L4,L5,L6 FROM Word2 WHERE %@ AND %@ AND %@ AND %@ AND %@ AND %@", subsql, subsql2, subsql3, subsql4, subsql5, subsql6];
	
//	NSLog(sql);
	
	
	
	NSMutableString *word = [NSMutableString new];
//	NSString *word;
	NSString *letter;
	char* testLetter;
	sqlite3_stmt *statement;
	BOOL charFound;
	BOOL wordIsInvalid;
	BOOL founded;
	int totalValidWords = 0;
	int total3ValidWords = 0;
	int total4ValidWords = 0;
	int total5ValidWords = 0;
	int total6ValidWords = 0;
	

	
	// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library,
	// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
	if(sqlite3_prepare_v2(global_bebaDb, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		// We "step" through the results - once for each row.
		while(sqlite3_step(statement) == SQLITE_ROW){
			
			wordIsInvalid = false;
			charFound = false;
			founded = false;
			
			NSRange range;
			range.location = 0;
			range.length = [word length];
			
			[word deleteCharactersInRange:range];
			
			
			NSMutableArray *copyOfArrayGameLetters = [NSMutableArray arrayWithArray:self.arrayGameLetters];
			
			for(int i=1; i<=6; i++)
			{
				testLetter = (char *) sqlite3_column_text(statement, i);
				
				if(testLetter)
				{
					letter = [NSString stringWithUTF8String: (char *) sqlite3_column_text(statement, i)];
					founded = false;

					
					if(letter)
					{
						for(int x =0; x<[copyOfArrayGameLetters count]; x++)
						{
							charFound = [[copyOfArrayGameLetters objectAtIndex:x] isEqualToString: letter];
							if(charFound){
								founded = true;
								[copyOfArrayGameLetters removeObjectAtIndex: x];
								break;
							}
						}
						
						if(founded==false)
								wordIsInvalid = true;
							
						
						[word appendString:letter];
					}
				}
			}
		
			if(wordIsInvalid)
				NSLog(@"FOUNDED: %@ -- not valid", word);
			else{
				int len = [word length];
				
				switch (len) {
					case 3:
						total3ValidWords++;
						break;
					case 4:
						total4ValidWords++;
						break;
					case 5:
						total5ValidWords++;
						break;
					case 6:
						total6ValidWords++;
						break;
					default:
						break;
				}
//				NSLog(@"FOUNDED: %@ -- good", word);
				totalValidWords++;
			}
																		 
		}
		// "Finalize" the statement - release the resources associated with the statement.
		sqlite3_finalize(statement);
	}
	else
		NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_bebaDb));

	
	totalValidWords = total3ValidWords + total4ValidWords + total5ValidWords + total6ValidWords;
	
	
	NSString *sql2 = [NSString stringWithFormat:@"UPDATE Word SET Words='%d', Words3='%d', Words4='%d', Words5='%d', Words6='%d' WHERE GameWord='%@'", totalValidWords,
					  total3ValidWords, total4ValidWords, total5ValidWords, total6ValidWords,
					  self.gameWord];
	if(sqlite3_prepare_v2(global_bebaDb, [sql2 UTF8String], -1, &statement, NULL)==SQLITE_OK)
	{
		while(sqlite3_step(statement) == SQLITE_ROW){}
		NSLog(@"UPDATE WAS OK");
	}
	else
		NSLog(@"Cannot execute query %s", sqlite3_errmsg(global_bebaDb));
		
		
	sqlite3_finalize(statement);
	
	NSLog(@"TOTAL VALID WORDS: %d", totalValidWords);
}
*/
@end