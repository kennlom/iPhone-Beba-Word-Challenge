//
//  SavedGameController.h
//  WordChallenge
//
//  Created by Nguyen on 9/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PLAYER_SCORE		@"0"
#define	WORDS_FOUND			@"1"
#define	WORDS_MISSED		@"2"
#define	WORDS_COMPLETED		@"3"
#define WORDS_SKIPPED		@"4"
#define	GAME_MODE			@"5"
#define	GAME_LEVEL			@"6"
#define BONUS_WORDS			@"7"
#define GAME_VERSION		@"8"
#define GAME_ID				@"9"
#define LAST_PLAYED_DATE	@"a"

@interface SavedGameController : UIViewController {

	int	selectedGameId;
	int selectedGameIndex;
	int selectedRow;
	
	UITableView		*tableGameList;
	UIView			*viewLoadGame;
	NSMutableArray	*arraySavedGames;
	UILabel			*labelNoSavedGameFound;
	IBOutlet UIImageView	*imageArrow;
	IBOutlet UILabel	*labelWordsFound;
	IBOutlet UILabel	*labelWordsSkipped;
	IBOutlet UILabel	*labelWordsMissed;
	IBOutlet UILabel	*labelWordsCompleted;
	IBOutlet UILabel	*labelBonusWords;
	IBOutlet UILabel	*labelPlayerScore;
	IBOutlet UILabel	*labelGameLevel;
	IBOutlet UILabel	*labelGameMode;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageArrow;
@property (nonatomic, retain) IBOutlet UILabel *labelNoSavedGameFound;
@property (nonatomic, retain) IBOutlet UIView *viewLoadGame;
@property (nonatomic, retain) IBOutlet UITableView *tableGameList;
@property (nonatomic, retain) NSMutableArray *arraySavedGames;
@property (nonatomic, retain) IBOutlet UILabel	*labelWordsFound;
@property (nonatomic, retain) IBOutlet UILabel	*labelWordsSkipped;
@property (nonatomic, retain) IBOutlet UILabel	*labelWordsMissed;
@property (nonatomic, retain) IBOutlet UILabel	*labelWordsCompleted;
@property (nonatomic, retain) IBOutlet UILabel	*labelBonusWords;
@property (nonatomic, retain) IBOutlet UILabel	*labelPlayerScore;
@property (nonatomic, retain) IBOutlet UILabel	*labelGameLevel;
@property (nonatomic, retain) IBOutlet UILabel	*labelGameMode;


@property int selectedGameId;
@property int selectedGameIndex;

- (IBAction) continueSavedGame;
- (IBAction) goBackToStartScreen;
- (IBAction) hideLoadScreen;
- (IBAction) discardGame;
- (void) discardGameFromDb: (int) gameId;
- (void) initSavedGames;
- (void) loadSavedGames;
- (void) saveGameLastAccessed: (int) gameId;



@end