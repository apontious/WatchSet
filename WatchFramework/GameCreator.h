//
//  GameCreator.h
//  Watch Match
//
//  Created by Watch Set Team on 11/23/14.
//  Copyright (c) 2014 Watch Set Team. All rights reserved.
//

@import Foundation;

#import "GameConstants.h"

@interface GameCreator : NSObject

@property (nonatomic, readonly) NSArray *turns;
@property (nonatomic, readonly) NSDate *startTime;

- (id)initWithNumberOfPlayers:(const NSUInteger)numberOfPlayers
                numberOfTurns:(const NSUInteger)numberOfTurns
               numberOfShapes:(const NSUInteger)numberOfShapes
             numberOfPatterns:(const NSUInteger)numberOfPatterns
                     criteria:(const GameCriteria)criteria;

- (BOOL)writeToFile:(NSURL *)fileURL;

@end
