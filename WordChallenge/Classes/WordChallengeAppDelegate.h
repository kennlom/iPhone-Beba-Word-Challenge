//
//  WordChallengeAppDelegate.h
//  WordChallenge
//
//  Created by Nguyen on 9/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonDigest.h>	// md5 library
#import <sqlite3.h>
#import "IntroScreenController.h"
#import "StartScreenController.h"
#import "GameScreenController.h"
#import "EndGameController.h"
#import	"NextLevelController.h"
#import	"GameModeController.h"
#import "SavedGameController.h"
#import "HelpController.h"
#import "TopScoreController.h"
#import "PostScoreController.h"
#import	"PausedController.h"
#import "WinnerController.h"

// Version: 1.0
// SKU: 1001000000

#define RELEASE_VERSION						20090929
#define INTRO_SCREEN						1
#define START_SCREEN						2
#define GAME_SCREEN							3
#define END_GAME_SCREEN						4
#define NEXT_LEVEL_SCREEN					5
#define GAME_MODE_SCREEN					6
#define SAVED_GAME_SCREEN					7
#define HELP_SCREEN							8
#define TOP_SCORE_SCREEN					9
#define POST_SCORE_SCREEN					10
#define	PAUSED_SCREEN						11
#define	WINNER_SCREEN						12
#define VIEW_ANIMATION_DURATION				0.30
#define SCREEN_WIDTH						480
#define BUTTON_LETTER_WIDTH					55
#define BUTTON_LETTER_HEIGHT				54
#define BUTTON_LETTER_SPACING				12
#define BUTTON_LETTER_POSITIONY				240
#define DICTIONARY_LETTERS					6
#define TOTAL_6_LETTER_WORDS_IN_DICTIONARY	15230
#define LOSER_MESSAGE_RANGE_START			1
#define LOSER_MESSAGE_TOTAL					105
#define DB_BEBA								0
#define DB_SAVED_GAME						1
#define APP_USER_AGENT						@"Beba.iPhone.WordChallenge20091012"
#define CHECKSUM_ENCRYPTION_KEY				@"com.beba.application"
#define API_SERVER_1						@"api.bebagames.com"
#define API_SERVER_2						@"api2.bebagames.com"
#define API_SERVER_3						@"api3.bebagames.com"
#define API_SERVER_4						@"api4.bebagames.com"
#define API_SERVER_5						@"api5.bebagames.com"
#define API_SERVER_6						@"api6.bebagames.com"
#define API_SERVER_7						@"api7.bebagames.com"
#define API_SERVER_8						@"api8.bebagames.com"
#define API_SERVER_9						@"api9.bebagames.com"
#define TOP_SCORE_XML_FILEURL				@"/scores/word_challenge/top_20_players.xml"
#define POST_SCORE_URL						@"/scores/post.php"
#define POST_SCORE_SUCCESS					@"1001"
#define BEBA_GAME_ID 1 // Beba Word Challenge

#define GAME_DATA_PLAYER_SCORE		@"a"
#define GAME_DATA_GAME_LEVEL		@"b"
#define GAME_DATA_WORDS_FOUND		@"c"
#define GAME_DATA_BONUS_WORDS		@"d"
#define GAME_DATA_WORDS_SKIPPED		@"e"
#define	GAME_DATA_GAME_MODE			@"f"
#define GAME_DATA_WORDS_MISSED		@"g"
#define GAME_DATA_WORDS_COMPLETED	@"h"

#define UIAppDelegate \
WordChallengeAppDelegate *app = (WordChallengeAppDelegate *)[[UIApplication sharedApplication] delegate];

#define NSLog // NSLog



/*`
 ` Convert an integer to an NSNumber object
 ``````````````````````````````````````````````````````````````````````````````````````````*/
static NSNumber* NumberFromInt(int integer) {
	return [NSNumber numberWithInt:integer];
}

/*`
 ` Get the game mode description based on the id
 ``````````````````````````````````````````````````````````````````````````````````````````*/
static NSString* GameModeFromId(int gameModeId) {
	switch(gameModeId){
		case EASY:				return @"Easy"; break;
		case NORMAL:			return @"Normal"; break;
		case HARD:				return @"Hard"; break;
		case TIME_CHALLENGE:	return @"Time Challenge"; break;
	}
	return @"";
}

/*`
 ` Convert a string into an array of splitted strings
 ``````````````````````````````````````````````````````````````````````````````````````````*/
static NSArray* arrayFromSplittedString(NSString* string, NSString* split) {
	return [string componentsSeparatedByString: split];
}

/*`
 ` Convert an NSDate into a db formatted string
 ``````````````````````````````````````````````````````````````````````````````````````````*/
static NSString* GetDBDateFormatForDate(NSDate* date) {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	NSString *formattedDate;
	
	// Output '2010-01-01 00:00:00'
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	formattedDate = [dateFormat stringFromDate:date];
	[dateFormat release];
	
	return formattedDate;
}

/*`
 ` Convert an integer into a formatted string
 ``````````````````````````````````````````````````````````````````````````````````````````*/
static NSString* StringFromInt(int number) {
	return [NSString stringWithFormat:@"%d", number];
}

/*`
 ` Display a quick popup alert message
 ``````````````````````````````````````````````````````````````````````````````````````````*/
static void displayAlert (NSString *alertTitle, NSString *alertMessage) {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil/*self*/ cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	[alert show];
	[alert release];
}


/*`
 ` Common library: Get the md5 value of a string
 ``````````````````````````````````````````````````````````````````````````````````````````*/
static NSString* md5(NSString *string) {
	const char *cStr = [string UTF8String];
	unsigned char r[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, strlen(cStr), r);
	return [[NSString  stringWithFormat:
			 @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			 r[0],r[1],r[2],r[3],r[4],r[5],r[6],r[7],r[8],r[9],r[10],r[11],r[12],r[13],r[14],r[15]] lowercaseString];
}

/*`
 ` Accelerometer functions
 ``````````````````````````````````````````````````````````````````````````````````````````*/
static BOOL L0AccelerationIsShaking(UIAcceleration* last, UIAcceleration* current, double threshold) {
	double
	deltaX = fabs(last.x - current.x),
	deltaY = fabs(last.y - current.y),
	deltaZ = fabs(last.z - current.z);
	
	return
	(deltaX > threshold && deltaY > threshold) ||
	(deltaX > threshold && deltaZ > threshold) ||
	(deltaY > threshold && deltaZ > threshold);
}

/*`
 ` Date difference
 ``````````````````````````````````````````````````````````````````````````````````````````*/
static NSString* dateDiff(NSString* origDate) {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *convertedDate = [dateFormat dateFromString:origDate];
    [dateFormat release];
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"recently";
    } else if (ti < 60) {
        return @"less than a minute ago";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
        return @"never";
    }  
}






/*`
 ` Define global variables
 ``````````````````````````````````````````````````````````````````````````````````````````*/
sqlite3	*global_bebaDb;
sqlite3 *global_savedGameDb;
NSMutableDictionary *global_lastGameData;


@interface WordChallengeAppDelegate : NSObject <UIApplicationDelegate> { //<UIAccelerometerDelegate>
    UIWindow *window;
	
	SystemSoundID soundEffectTouch;
	SystemSoundID soundEffectSpin;
	SystemSoundID soundEffectScore;
	SystemSoundID soundEffectBonus;
	SystemSoundID soundEffectTime;
	SystemSoundID soundEffectLost;
	SystemSoundID soundEffectAmbiental;
	
//	UIAcceleration* lastAcceleration;
	BOOL histeresisExcited;

	IntroScreenController	*viewIntroScreen;
	StartScreenController	*viewStartScreen;
	GameScreenController	*viewGameScreen;
	EndGameController		*viewEndScreen;
	NextLevelController		*viewNextLevelScreen;
	GameModeController		*viewGameModeScreen;
	SavedGameController		*viewSavedGameScreen;
	HelpController			*viewHelpScreen;
	TopScoreController		*viewTopScoreScreen;
	PostScoreController		*viewPostScoreScreen;
	PausedController		*viewPausedScreen;
	WinnerController		*viewWinnerScreen;
}

//@property(retain) UIAcceleration* lastAcceleration;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet IntroScreenController	*viewIntroScreen;
@property (nonatomic, retain) IBOutlet StartScreenController	*viewStartScreen;
@property (nonatomic, retain) IBOutlet GameScreenController		*viewGameScreen;
@property (nonatomic, retain) IBOutlet EndGameController		*viewEndScreen;
@property (nonatomic, retain) IBOutlet NextLevelController		*viewNextLevelScreen;
@property (nonatomic, retain) IBOutlet GameModeController		*viewGameModeScreen;
@property (nonatomic, retain) IBOutlet SavedGameController		*viewSavedGameScreen;
@property (nonatomic, retain) IBOutlet HelpController			*viewHelpScreen;
@property (nonatomic, retain) IBOutlet TopScoreController		*viewTopScoreScreen;
@property (nonatomic, retain) IBOutlet PostScoreController		*viewPostScoreScreen;
@property (nonatomic, retain) IBOutlet PausedController			*viewPausedScreen;
@property (nonatomic, retain) IBOutlet WinnerController			*viewWinnerScreen;
@property (readonly) SystemSoundID soundEffectTouch;
@property (readonly) SystemSoundID soundEffectSpin;
@property (readonly) SystemSoundID soundEffectScore;
@property (readonly) SystemSoundID soundEffectBonus;
@property (readonly) SystemSoundID soundEffectTime;
@property (readonly) SystemSoundID soundEffectLost;
@property (readonly) SystemSoundID soundEffectAmbiental;


- (void) initXibScreen: (int) nibId;
- (void) viewTransition:(id *) viewFadeIn: (id *) viewFadeOut: (BOOL) removeFromMemory;
- (void) viewTransitionFadeOut: (NSString*)animationID finished:(BOOL)finished context:(NSDictionary *) context;
- (void) playSoundEffect: (int) soundEffectId;

// Database functions
- (BOOL) initDatabase: (int) databaseId;
- (BOOL) copyDbToDocumentDirectoryIfNeeded: (NSString *) fullWritableDbPath: (NSString *) dbFilename;
- (NSString *) getRandomLoserMessage;
- (NSString *) getRandomWinnerMessage;
- (int) getFirstRankPlayerScore;

// References
- (id *) addressOf_viewIntroScreen;
- (id *) addressOf_viewStartScreen;
- (id *) addressOf_viewGameScreen;
- (id *) addressOf_viewEndScreen;
- (id *) addressOf_viewNextLevelScreen;
- (id *) addressOf_viewGameModeScreen;
- (id *) addressOf_viewHelpScreen;
- (id *) addressOf_viewTopScoreScreen;
- (id *) addressOf_viewPostScoreScreen;
- (id *) addressOf_viewSavedGameScreen;
- (id *) addressOf_viewPausedScreen;
- (id *) addressOf_viewWinnerScreen;

// UI functions
//- (void) displayAlert: (NSString *) alertTitle: (NSString *) alertMessage;

// Other
//- (NSString *) md5: (NSString *) string;



@end