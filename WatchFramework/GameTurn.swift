//
//  GameTurn.swift
//  Watch Match
//
//  Created by Andrew Pontious on 11/26/14.
//  Copyright (c) 2014 TeamHand. All rights reserved.
//

import Foundation

public enum GameCriteria {
    case MatchShapesCriteria
    case MatchPatternsCriteria
    case MatchShapesAndColorsCriteria
}

public struct GameTurn {
    
    public let isMatch: Bool

    public let patterns: [Int]
    public let shapes: [Int]
    
    public func patternForPlayer(playerIndex: Int) -> Int {
        return self.patterns[playerIndex]
    }
    
    public func shapeForPlayer(playerIndex: Int) -> Int {
        return self.shapes[playerIndex]
    }
    
    public init(turn: GameTurn) {
        self.isMatch = turn.isMatch;
        self.patterns = turn.patterns;
        self.shapes = turn.shapes;
    }
    
    public init(patterns: [Int], shapes: [Int], criteria: GameCriteria) {
        self.patterns = patterns;
        self.shapes = shapes;
        
        var isPatternMatch = true;
        var currentPattern: Int?
            
        for (index, pattern) in enumerate(self.patterns) {
            if (currentPattern == nil) {
                currentPattern = pattern;
            }
            
            if (pattern != currentPattern) {
                isPatternMatch = false;
                break;
            }
        }
        
        var isShapeMatch = true;
        var currentShape: Int?

        for (index, shape) in enumerate(self.shapes) {
            if (currentShape == nil) {
                currentShape = shape;
            }
            
            if (shape != currentShape) {
                isShapeMatch = false;
                break;
            }
        }
        
        switch (criteria) {
            case GameCriteria.MatchShapesCriteria:
                self.isMatch = isShapeMatch;
                break;
            case GameCriteria.MatchPatternsCriteria:
                self.isMatch = isPatternMatch;
                break;
            case GameCriteria.MatchShapesAndColorsCriteria:
                self.isMatch = (isShapeMatch && isPatternMatch);
                break;
        }
    }

    public init(dictionary: NSDictionary) {
        self.patterns = dictionary["patterns"] as [Int]
        self.shapes = dictionary["shapes"] as [Int]
        self.isMatch = dictionary["match"] as Bool
        
    }
    
    func serializableDictionary() -> NSDictionary {

        return ["patterns" : self.patterns,
                "shapes" : self.shapes,
                "match" : NSNumber(bool:self.isMatch)];
    
    }
}