//
//  GameCreator.m
//  Watch Match
//
//  Created by Watch Set Team on 11/23/14.
//  Copyright (c) 2014 Watch Set Team. All rights reserved.
//

#import "GameCreator.h"

#import "GameTurn.h"

static const float kMatchPercent = .70;

@interface GameCreator ()

@end

@implementation GameCreator

static NSMutableArray *arrayOfSameNumbers(const NSUInteger count, const NSUInteger number) {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < count; i++) {
        [result addObject:@(number)];
    }
    return result;
}
    
static NSMutableArray *arrayOfRandomNumbers(const NSUInteger count, const NSUInteger numberUpperBound) {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    BOOL isRandom = NO;
    
    while (!isRandom) {
        [result removeAllObjects];
        
        for (NSUInteger i = 0; i < count; i++) {
            [result addObject:@(arc4random_uniform((u_int32_t)numberUpperBound))];
            if (i > 0) {
                if (![result[0] isEqualToNumber:result.lastObject]) {
                    isRandom = YES;
                }
            }
        }
    }
    
    return result;
}

- (id)initWithNumberOfPlayers:(const NSUInteger)numberOfPlayers
                numberOfTurns:(const NSUInteger)numberOfTurns
               numberOfShapes:(const NSUInteger)numberOfShapes
             numberOfPatterns:(const NSUInteger)numberOfPatterns
                     criteria:(const GameCriteria)criteria {
    self = [super init];
    if (self != nil) {
        NSMutableArray *turns = [[NSMutableArray alloc] init];
        
        for (NSUInteger i = 0; i < numberOfTurns; i++) {
            const NSUInteger randomNumber = arc4random_uniform(100);
            
            NSMutableArray *patterns = [[NSMutableArray alloc] init];
            NSMutableArray *shapes = [[NSMutableArray alloc] init];
            
            if (randomNumber < kMatchPercent * 100) {
                const u_int32_t matchedShape = arc4random_uniform((u_int32_t)numberOfShapes);
                const u_int32_t matchedPattern = arc4random_uniform((u_int32_t)numberOfPatterns);
                
                switch (criteria) {
                    case MatchShapesCriteria: {
                        shapes = arrayOfSameNumbers(numberOfPlayers, matchedShape);
                        patterns = arrayOfRandomNumbers(numberOfPlayers, numberOfPatterns);
                    }
                        break;
                    case MatchPatternsCriteria: {
                        shapes = arrayOfRandomNumbers(numberOfPlayers, numberOfShapes);
                        patterns = arrayOfSameNumbers(numberOfPlayers, matchedPattern);
                    }
                        break;
                    case MatchShapesAndColorsCriteria: {
                        shapes = arrayOfSameNumbers(numberOfPlayers, matchedShape);
                        patterns = arrayOfSameNumbers(numberOfPlayers, matchedPattern);
                    }
                        break;
                }
            } else {
                shapes = arrayOfRandomNumbers(numberOfPlayers, numberOfShapes);
                patterns = arrayOfRandomNumbers(numberOfPlayers, numberOfPatterns);
            }
            
            GameTurn *turn = [[GameTurn alloc] initWithPatterns:patterns shapes:shapes criteria:criteria];
            
            [turns addObject:turn];
        }
        
        _turns = turns;
        
        _startTime = [NSDate dateWithTimeInterval:5 *60 sinceDate:[NSDate date]];
    }
    return self;
}

- (BOOL)writeToFile:(NSURL *)fileURL {
    NSMutableArray *turnDictionaries = [[NSMutableArray alloc] init];
    
    for (GameTurn *turn in self.turns) {
        [turnDictionaries addObject:turn.serializableDictionary];
    }
    
    NSDictionary *dictionary = @{@"turns" : turnDictionaries,
                                 @"time" : self.startTime};
    
    NSError *error;
    
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:dictionary format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    
    BOOL result = [data writeToURL:fileURL options:0 error:&error];
    if (!result) {
        NSLog(@"%@", error);
    }
    
    return result;
}

@end
