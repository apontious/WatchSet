//
//  GameLogic.swift
//  Watch Match
//
//  Created by Andrew Pontious on 11/26/14.
//  Copyright (c) 2014 TeamHand. All rights reserved.
//

import Foundation

public class GameLogic {
    
    public let turns: [GameTurn]
    public let startTime: NSDate

    public init() {
        // Assumes Game.plist file is valid
        
        let mainBundle = NSBundle.mainBundle()
        let URL = mainBundle.URLForResource("Game", withExtension:"plist")!
        
        let dictionary = NSDictionary(contentsOfURL:URL) as NSDictionary!
        
        var turns = [GameTurn]()
        
        self.startTime = dictionary["time"] as NSDate
        
        let turnDictionaries = dictionary["turns"] as [NSDictionary]
        
        for (index, turnDictionary) in enumerate(turnDictionaries) {
            let turn = GameTurn(dictionary: turnDictionary);
            
            turns.append(turn)
        }
        
        self.turns = turns
    }
}