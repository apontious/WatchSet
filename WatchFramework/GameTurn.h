//
//  GameTurn.h
//  Watch Match
//
//  Created by Watch Set Team on 11/23/14.
//  Copyright (c) 2014 Watch Set Team. All rights reserved.
//

@import Foundation;

#import "GameConstants.h"

@interface GameTurn : NSObject

@property (nonatomic, readonly) BOOL isMatch;

- (NSUInteger)patternForPlayer:(const NSUInteger)playerIndex;
- (NSUInteger)shapeForPlayer:(const NSUInteger)playerIndex;

- (instancetype)initWithPatterns:(NSArray *)patterns shapes:(NSArray *)shapes criteria:(const GameCriteria)criteria;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)serializableDictionary;

@end
