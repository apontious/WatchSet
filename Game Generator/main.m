//
//  main.m
//  Game Generator
//
//  Created by Watch Set Team on 11/23/14.
//  Copyright (c) 2014 Watch Set Team. All rights reserved.
//

@import Foundation;

#import "GameCreator.h"

static const NSUInteger kNumberOfPlayers = 3;
static const NSUInteger kNumberOfTurns = 20;
static const NSUInteger kNumberOfShapes = 9;
static const NSUInteger kNumberOfPatterns = 5;

static const GameCriteria kGameCriteria = MatchShapesCriteria;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        GameCreator *creator = [[GameCreator alloc] initWithNumberOfPlayers:kNumberOfPlayers
                                                              numberOfTurns:kNumberOfTurns
                                                             numberOfShapes:kNumberOfShapes
                                                           numberOfPatterns:kNumberOfPatterns
                                                                   criteria:kGameCriteria];
        
        NSString *filePath = @"~/Desktop/Game.plist";
        filePath = [filePath stringByExpandingTildeInPath];
        
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        if (![creator writeToFile:fileURL]) {
            NSLog(@"Failed to write file");
        }
    }
    return 0;
}
