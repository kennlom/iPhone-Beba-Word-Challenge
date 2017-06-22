//
//  GameScreenController.h
//  WordChallenge
//
//  Created by Nguyen on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <sqlite3.h>
//#import <AudioToolbox/AudioToolbox.h>
//#import "WordChallengeAppDelegate.h"


#define EASY			0
#define NORMAL			1
#define HARD			2
#define TIME_CHALLENGE	3
#define TYPE_BUTTON		0
#define TYPE_IMAGE		1
#define	TYPE_STRING		2
#define TYPE_LABEL		3
#define SOUND_FX_TOUCH		0
#define SOUND_FX_SPIN		1
#define SOUND_FX_SCORE		2
#define SOUND_FX_BONUS		3
#define SOUND_FX_TIME		4
#define SOUND_FX_LOST		5
#define SOUND_FX_AMBIENTAL	6


@interface GameScreenController : UIViewController {

	NSTimer *timerCountdown;
	NSTimer *timerStartGame;
	UILabel *labelPlaceScore;
	UILabel *labelPointDeduct;
	UILabel *labelGameMode;
	UILabel *labelNextLevelMinScore;
	UILabel *labelLevel;
	UILabel *labelCountdown;
	UILabel *labelPlayerScore;
	UILabel *labelScore;
	UILabel *labelCountOfMaxWordsFound;
	UILabel *labelCountdownStartGame;
	UILabel *labelStartGameIn;
	UIImageView *imageLoading;
	UIImage *imageLetterBackground;
	UIImage *imageLetterSlotBackground;
	UIImageView *imageBackground;
	UIButton *buttonSpin;
	UIButton *buttonCheckWord;
	UIButton *buttonSkipWord;
	NSMutableArray	*arrayWordFound;			// Array of words found for current game
	NSMutableArray	*arrayTaggedLetter;			// Array of tagged letters	
	NSMutableArray	*arrayWordLetterButtons;	// Array of pointers to the letter images, so we can make updates
	NSMutableArray	*arrayGameLetters;			// Array of current game word letters
	NSMutableArray	*arrayWordLetterSlots;		// Array of slots of hold the picked letters
	NSString *gameWord;							// Current game word

	int secondsUntilGameStart;
	int currentGameId;							// 0 = new game, otherwise game was continued from previously saved
	int timeUntilLevelEnds;
	int gameMaximumTime;
	int countLetters;							// Number of letters on the playboard
	int playerScore;
	int gameLevel;
	int gameMode;
	int totalWordsFound;
	int totalWordsMissed;
	int totalWordsCompleted;
	int totalWordsSkipped;
	int totalBonusWords;
	int childWords;
	int childWords3;
	int childWords4;
	int childWords5;
	int childWords6;
	int maxLevel;
	BOOL shouldLetterRandomRotated;				// Should be letter be rotated when spinning? So hard level players
	BOOL gamePaused;
}


@property (nonatomic, retain) IBOutlet UILabel *labelPlaceScore;
@property (nonatomic, retain) IBOutlet UILabel *labelCountdownStartGame;
@property (nonatomic, retain) IBOutlet UILabel *labelStartGameIn;
@property (nonatomic, retain) IBOutlet UILabel *labelCountOfMaxWordsFound;
@property (nonatomic, retain) IBOutlet UILabel *labelPointDeduct;
@property (nonatomic, retain) IBOutlet UILabel *labelGameMode;
@property (nonatomic, retain) IBOutlet UILabel *labelLevel;
@property (nonatomic, retain) IBOutlet UILabel *labelNextLevelMinScore;
@property (nonatomic, retain) IBOutlet UILabel *labelCountdown;
@property (nonatomic, retain) IBOutlet UILabel *labelScore;
@property (nonatomic, retain) IBOutlet UILabel *labelPlayerScore;
@property (nonatomic, retain) IBOutlet UIImageView *imageLoading;
@property (nonatomic, retain) UIImage *imageLetterBackground;
@property (nonatomic, retain) UIImage *imageLetterSlotBackground;
@property (nonatomic, retain) IBOutlet UIImageView *imageBackground;
@property (nonatomic, retain) IBOutlet UIButton *buttonSpin;
@property (nonatomic, retain) IBOutlet UIButton *buttonCheckWord;
@property (nonatomic, retain) IBOutlet UIButton *buttonSkipWord;
@property (nonatomic, retain) NSMutableArray	*arrayWordLetterButtons;
@property (nonatomic, retain) NSMutableArray	*arrayTaggedLetter;
@property (nonatomic, retain) NSMutableArray	*arrayGameLetters;
@property (nonatomic, retain) NSMutableArray	*arrayWordLetterSlots;
@property (nonatomic, retain) NSMutableArray	*arrayWordFound;
@property (nonatomic) int countLetters;
@property (nonatomic) int playerScore;
@property int currentGameId;
@property (nonatomic) int gameMaximumTime;
@property (nonatomic) int gameMode;
@property (nonatomic) int gameLevel;
@property (nonatomic) int childWords;
@property (nonatomic) int childWords3;
@property (nonatomic) int childWords4;
@property (nonatomic) int childWords5;
@property (nonatomic) int childWords6;
@property (nonatomic) int totalWordsFound;
@property (nonatomic) int totalWordsMissed;
@property (nonatomic) int totalBonusWords;
@property (nonatomic) int totalWordsCompleted;
@property (nonatomic) int totalWordsSkipped;
@property (nonatomic) BOOL shouldLetterRandomRotated;
@property (nonatomic, retain) NSString *gameWord;
@property (nonatomic, retain) NSTimer *timerCountdown;
@property (nonatomic) int timeUntilLevelEnds;


- (void) initGame: (int) gameMode;
- (int) getLevelMinimumScore;

- (void) closePauseScreenIfRequired;

- (void) initQuestionMarkPlaceholder;
- (void) initWordLetterPlaceholder;
- (BOOL) initDatabase;
- (void) spinLetters;
- (void) resetLetters; 
- (BOOL) checkWordDictionary: (NSString *) word;
- (IBAction) checkWordAccuracy;
- (IBAction) spin;
- (NSString *) getCurrentGuessedWord;
- (NSDictionary *) getRandomWordFromDb;
- (int) getWordScore: (NSString *) word;
- (void) updatePlayerScore: (int) score;
- (void) flashWordScore: (NSString *) word: (int) score;
- (void) initGameMode: (int) mode;
- (void) initGameLevel: (int) level;
- (IBAction) continueToNextLevel;
- (void) endGame;
- (void) startCountdownTimer;
- (IBAction) generateNewGameWord;
- (IBAction) skipWord;
- (void) adjustPlayerScore: (int) newScore;
- (BOOL) isWordAlreadyFound: (NSString *) word;
- (void) initGameWord;

- (void) resetGame;
- (void) updateCountdown: (int) time;
- (IBAction) pauseGame;
- (IBAction) resumeGame;
- (void) quitGame;


//- (void) removeAndReleaseAll: (NSMutableArray *) arrayItems: (int) itemType;
//- (void) test;
//- (NSString *) getRandomWordFromDb_XXX: (int) x;
//-(void) initGameWord_XXX;



@end