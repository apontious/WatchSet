//
//  main.swift
//  Game Generator
//
//  Created by Andrew Pontious on 11/23/14.
//  Copyright (c) 2014 TeamHand. All rights reserved.
//

import Foundation

let kNumberOfPlayers = 3
let kNumberOfTurns = 20
let kNumberOfShapes = 9
let kNumberOfPatterns = 5

let kGameCriteria = GameCriteria.MatchShapesCriteria

let creator = GameCreator(numberOfPlayers:kNumberOfPlayers,
                          numberOfTurns:kNumberOfTurns,
                          numberOfShapes:kNumberOfShapes,
                          numberOfPatterns:kNumberOfPatterns,
                          criteria:kGameCriteria)

let filePath = "~/Desktop/Game.plist".stringByExpandingTildeInPath

let fileURL = NSURL.fileURLWithPath(filePath)!

if (!creator.writeToFile(fileURL)) {
    println("Failed to write file")
}
