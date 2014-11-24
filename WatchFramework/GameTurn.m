//
//  GameTurn.m
//  Watch Match
//
//  Created by Watch Set Team on 11/23/14.
//  Copyright (c) 2014 Watch Set Team. All rights reserved.
//

#import "GameTurn.h"

@interface GameTurn ()

@property (nonatomic) BOOL isMatch;

@property (nonatomic) NSArray *patterns;
@property (nonatomic) NSArray *shapes;

@end

@implementation GameTurn

- (NSUInteger)patternForPlayer:(const NSUInteger)playerIndex {
    NSAssert(playerIndex < self.patterns.count, @"playerIndex > patterns.count", __PRETTY_FUNCTION__);
    
    return [self.patterns[playerIndex] unsignedIntegerValue];
}
- (NSUInteger)shapeForPlayer:(const NSUInteger)playerIndex {
    NSAssert(playerIndex < self.shapes.count, @"playerIndex > shapes.counts", __PRETTY_FUNCTION__);
    
    return [self.shapes[playerIndex] unsignedIntegerValue];
}

- (instancetype)initWithPatterns:(NSArray *)patterns shapes:(NSArray *)shapes criteria:(const GameCriteria)criteria {
    self = [super init];
    if (self != nil) {
        NSAssert(patterns.count > 0 && patterns.count == shapes.count, @"%s called with zero patterns or patterns not same # of shapes", __PRETTY_FUNCTION__);
        
        _patterns = patterns;
        _shapes = shapes;
        
        BOOL isPatternMatch = YES;
        {{
            NSNumber *currentPattern;
            
            for (NSNumber *pattern in _patterns) {
                if (currentPattern == nil) {
                    currentPattern = pattern;
                }
                
                if (![pattern isEqualToNumber:currentPattern]) {
                    isPatternMatch = NO;
                    break;
                }
            }
        }}
        BOOL isShapeMatch = YES;
        {{
            NSNumber *currentShape;
            
            for (NSNumber *shape in _shapes) {
                if (currentShape == nil) {
                    currentShape = shape;
                }
                
                if (![shape isEqualToNumber:currentShape]) {
                    isShapeMatch = NO;
                    break;
                }
            }
        }}
        
        switch (criteria) {
            case MatchShapesCriteria:
                _isMatch = isShapeMatch;
                break;
            case MatchPatternsCriteria:
                _isMatch = isPatternMatch;
                break;
            case MatchShapesAndColorsCriteria:
                _isMatch = (isShapeMatch && isPatternMatch);
                break;
        }
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self != nil) {
        _patterns = dictionary[@"patterns"];
        _shapes = dictionary[@"shapes"];
        _isMatch = [dictionary[@"match"] boolValue];
    }
    return self;
}

- (NSDictionary *)serializableDictionary {
    return @{@"patterns" : self.patterns,
             @"shapes" : self.shapes,
             @"match" : @(self.isMatch)};
}

@end
