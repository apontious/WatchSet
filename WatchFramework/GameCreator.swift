//
//  GameCreator.swift
//  Watch Match
//
//  Created by Andrew Pontious on 11/26/14.
//  Copyright (c) 2014 TeamHand. All rights reserved.
//

import Foundation

public class GameCreator {
    let turns: [GameTurn]
    let startTime: NSDate
    
    let kMatchPercent = 0.70
    
    public init(numberOfPlayers: Int,
                numberOfTurns: Int,
                numberOfShapes: Int,
                numberOfPatterns: Int,
                criteria: GameCriteria) {
        
            var turns = [GameTurn]()
            
            for i in 0..<numberOfTurns {
                let randomNumber = Int(arc4random_uniform(100));
                
                var patterns = [Int]()
                var shapes = [Int]()
                
                if (randomNumber < Int(kMatchPercent * 100)) {
                    let matchedShape = Int(arc4random_uniform(UInt32(numberOfShapes)))
                    let matchedPattern = Int(arc4random_uniform(UInt32(numberOfPatterns)))
                    
                    switch (criteria) {
                        case GameCriteria.MatchShapesCriteria:
                            shapes = arrayOfSameNumbers(numberOfPlayers, matchedShape);
                            patterns = arrayOfRandomNumbers(numberOfPlayers, numberOfPatterns);
                            break;
                        case GameCriteria.MatchPatternsCriteria:
                            shapes = arrayOfRandomNumbers(numberOfPlayers, numberOfShapes);
                            patterns = arrayOfSameNumbers(numberOfPlayers, matchedPattern);
                            break;
                        case GameCriteria.MatchShapesAndColorsCriteria:
                            shapes = arrayOfSameNumbers(numberOfPlayers, matchedShape);
                            patterns = arrayOfSameNumbers(numberOfPlayers, matchedPattern);
                            break;
                    }
                } else {
                    shapes = arrayOfRandomNumbers(numberOfPlayers, numberOfShapes);
                    patterns = arrayOfRandomNumbers(numberOfPlayers, numberOfPatterns);
                }
                
                let turn = GameTurn(patterns:patterns, shapes:shapes, criteria:criteria)
                
                turns.append(turn)
            }
            
            self.turns = turns;
            
            self.startTime = NSDate(timeInterval:5 * 60, sinceDate:NSDate())
    }
    
    public func writeToFile(fileURL: NSURL) -> Bool {
        var turnDictionaries = NSMutableArray()
            
        for turn in self.turns {
            turnDictionaries.addObject(turn.serializableDictionary())
        }
        
        var dictionary = ["turns" : turnDictionaries,
                "time" : self.startTime];
            
        var error: NSError?
        
        let data = NSPropertyListSerialization.dataWithPropertyList(dictionary, format:NSPropertyListFormat.XMLFormat_v1_0, options:Int(0), error:&error)!
        
        let result = data.writeToURL(fileURL, options:NSDataWritingOptions(0), error:&error)
        if (!result) {
            println("(\result)")
        }
        
        return result;
    }
}

func arrayOfSameNumbers(count: Int, number: Int) -> [Int] {
    var result = [Int]()
    for i in 0..<count {
        result.append(number)
    }
    return result;
}

func arrayOfRandomNumbers(count: Int, numberUpperBound: Int) -> [Int] {
    var result = [Int]()
    
    var isRandom = false
    
    while (!isRandom) {
        result.removeAll()
        
        for i in 0..<count {
            result.append(Int(arc4random_uniform(UInt32(numberUpperBound))))
            if (i > 0) {
                if (result[0] != result.last) {
                    isRandom = true
                }
            }
        }
    }
    
    return result;
}
