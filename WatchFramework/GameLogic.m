//
//  GameLogic.m
//  Watch Match
//
//  Created by Watch Set Team on 11/23/14.
//  Copyright (c) 2014 Watch Set Team. All rights reserved.
//

#import "GameLogic.h"

#import "GameTurn.h"

@implementation GameLogic

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSURL *URL = [mainBundle URLForResource:@"Game" withExtension:@"plist"];
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:URL];
        
        _startTime = dictionary[@"time"];
        
        NSArray *turnDictionariesArray = dictionary[@"turns"];
        
        NSMutableArray *turns = [[NSMutableArray alloc] init];
        for (NSDictionary *turnDictionary in turnDictionariesArray) {
            GameTurn *turn = [[GameTurn alloc] initWithDictionary:turnDictionary];
            
            [turns addObject:turn];
        }
        
        _turns = turns;
    }
    return self;
}

@end
