//
//  InterfaceController.m
//  Watch Match WatchKit Extension
//
//  Created by Watch Set Team on 11/23/14.
//  Copyright (c) 2014 Watch Set Team. All rights reserved.
//

#import "InterfaceController.h"

#import "GameLogic.h"
#import "GameTurn.h"
#import "PlayerIndex.h"

static const NSTimeInterval kTurnSeconds = 3.5;

@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *gameStartsAtLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceDate *startTimeDate;
@property (weak, nonatomic) IBOutlet WKInterfaceTimer *startTimeTimer;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *button;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *image;

@property (nonatomic) NSTimer *timer;

@property (nonatomic) GameLogic *gameLogic;

@property (nonatomic) NSUInteger turnIndex;

@property (nonatomic) BOOL isPlaying;

@property (nonatomic) NSMutableArray *tapTimes;

@property (nonatomic) NSMutableArray *didTapForTurns;

@property (nonatomic) NSUInteger hits;
@property (nonatomic) NSUInteger misses;

@end


@implementation InterfaceController

- (instancetype)initWithContext:(id)context {
    self = [super initWithContext:context];

    return self;
}

- (void)willActivate {
    self.gameLogic = [[GameLogic alloc] init];
    
    self.startTimeLabel.text =
    [NSDateFormatter localizedStringFromDate:self.gameLogic.startTime dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
    self.timer = [[NSTimer alloc] initWithFireDate:self.gameLogic.startTime interval:0 target:self selector:@selector(startGameTimerDidFire:) userInfo:nil repeats:NO];
    
    self.title = @"Hits:";
    
    self.tapTimes = [[NSMutableArray alloc] init];
    
    self.didTapForTurns = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < self.gameLogic.turns.count; i++) {
        [self.didTapForTurns addObject:@(0)];
    }
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (IBAction)tapButton:(id)sender {
    if (self.isPlaying) {
        GameTurn *turn = self.gameLogic.turns[self.turnIndex];
        if (turn.isMatch) {
            if ([self.didTapForTurns[self.turnIndex] boolValue] == NO) {
                [self.tapTimes addObject:[NSDate date]];
                
                self.didTapForTurns[self.turnIndex] = @(YES);
                self.hits++;
                
                [self setTitle:[NSString stringWithFormat:@"Hits: %lu", (unsigned long)self.hits]];
            }
        } else {
            [self.tapTimes addObject:[NSDate date]];
        }
    }
}

- (void)showGame {
    self.gameStartsAtLabel.hidden = YES;
    self.startTimeLabel.hidden = YES;
    self.startTimeDate.hidden = YES;
    self.startTimeTimer.hidden = YES;
    self.button.color = [UIColor greenColor];
    self.isPlaying = YES;
}

- (void)startGameTimerDidFire:(NSTimer *)timer {
    [self showGame];
    
    [self playTurn];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTurnSeconds target:self selector:@selector(playGameTimerDidFire:) userInfo:nil repeats:YES];
}

- (void)playGameTimerDidFire:(NSTimer *)timer {
    self.turnIndex++;
    
    if (self.turnIndex == self.gameLogic.turns.count) {
        [timer invalidate];
        self.timer = nil;
        [self endGame];
    } else {
        [self playTurn];
    }
}

- (void)playTurn {
    GameTurn *turn = self.gameLogic.turns[self.turnIndex];
    
    const NSUInteger shape = [turn shapeForPlayer:kPlayerIndex];
    const NSUInteger pattern = [turn patternForPlayer:kPlayerIndex];
    
    NSString *imageFileName = [NSString stringWithFormat:@"shape%lupattern%lu", (unsigned long)shape, (unsigned long)pattern];
    
    [self.image setImageNamed:imageFileName];
    [self.button setBackgroundImageNamed:imageFileName];
}

- (void)endGame {
    NSURL *libraryURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *fileURL = [libraryURL URLByAppendingPathComponent:@"Taps.plist"];
    
    
    NSError *error;
    
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:self.tapTimes format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    
    BOOL result = [data writeToURL:fileURL options:0 error:&error];
    if (!result) {
        NSLog(@"%@", error);
    }
}

@end



