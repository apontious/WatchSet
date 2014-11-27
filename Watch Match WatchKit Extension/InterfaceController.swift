//
//  InterfaceController.swift
//  Watch Match WatchKit Extension
//
//  Created by Andrew Pontious on 11/26/14.
//  Copyright (c) 2014 TeamHand. All rights reserved.
//

import WatchKit
import Foundation

import WatchFramework

class InterfaceController: WKInterfaceController {
    
    // Currently hard-coded, must be edited for every player in demo. Eventually: determined by initiating GameKit player.
    let kPlayerIndex = 0;

    let kTurnSeconds: NSTimeInterval = 3.5
    
    @IBOutlet weak var gameStartsAtLabel: WKInterfaceLabel!
    @IBOutlet weak var startTimeLabel: WKInterfaceLabel!
    @IBOutlet weak var button: WKInterfaceButton!
    @IBOutlet weak var gameOverLabel: WKInterfaceLabel!
    
    var timer: NSTimer?
    
    var gameLogic: GameLogic
    
    var turnIndex: Int
    
    var isPlaying: Bool
    
    var tapTimes: [NSDate]
    
    var didTapForTurns: [Bool]
    
    var hits: Int
    var misses: Int

    override init(context: AnyObject?) {
        self.gameLogic = GameLogic()
        self.turnIndex = 0
        self.isPlaying = false
        self.tapTimes = [NSDate]()
        self.didTapForTurns = [Bool]()
        self.hits = 0
        self.misses = 0
        
        super.init(context: context)
    }

    override func willActivate() {
        super.willActivate()
        
        self.startTimeLabel.setText(NSDateFormatter.localizedStringFromDate(self.gameLogic.startTime, dateStyle:NSDateFormatterStyle.NoStyle, timeStyle:NSDateFormatterStyle.ShortStyle));

        self.timer = NSTimer(fireDate:self.gameLogic.startTime,
                             interval:0,
                             target:self,
                             selector:Selector("startGameTimerDidFire:"),
                             userInfo:nil,
                             repeats:false)
        
        self.setTitle("Hits:")
        
        for i in 0..<self.gameLogic.turns.count {
            self.didTapForTurns.append(false)
        }
        
        NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode:NSDefaultRunLoopMode)
    }

    @IBAction func tapButton() {
        if (self.isPlaying) {
            let turn = self.gameLogic.turns[self.turnIndex]
            if (turn.isMatch) {
                if (self.didTapForTurns[self.turnIndex] == false) {
                    self.tapTimes.append(NSDate())
                    
                    self.didTapForTurns[self.turnIndex] = true
                    self.hits++;
                    
                    self.setTitle("Hits: \(self.hits)")
                }
            } else {
                self.tapTimes.append(NSDate())
            }
        }
    }

    func showGame() {
        self.gameStartsAtLabel.setHidden(true)
        self.startTimeLabel.setHidden(true)
        self.button.setColor(UIColor.greenColor())
        self.isPlaying = true
    }

    func startGameTimerDidFire(timer: NSTimer) {
        self.showGame()
    
        self.playTurn()
    
        self.timer = NSTimer.scheduledTimerWithTimeInterval(kTurnSeconds, target:self, selector:Selector("playGameTimerDidFire:"), userInfo:nil, repeats:true)
    }

    func playGameTimerDidFire(timer: NSTimer) {
        self.turnIndex++;
        
        if (self.turnIndex == self.gameLogic.turns.count) {
            timer.invalidate()
            self.timer = nil;
            self.endGame()
        } else {
            self.playTurn()
        }
    }

    func playTurn() {
        let turn = self.gameLogic.turns[self.turnIndex]
        
        let shape = turn.shapeForPlayer(kPlayerIndex);
        let pattern = turn.patternForPlayer(kPlayerIndex)
        
        self.button.setBackgroundImageNamed("shape\(shape)pattern\(pattern)")
    }

    func endGame() {
        self.button.setHidden(true)
        self.gameOverLabel.setAlpha(1.0)
        
        let libraryURL = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.ApplicationDirectory, inDomain:NSSearchPathDomainMask.UserDomainMask, appropriateForURL:nil, create:true, error:nil)!
        let fileURL = libraryURL.URLByAppendingPathComponent("Taps.plist")
        
        var error: NSError?
        
        let data = NSPropertyListSerialization.dataWithPropertyList(self.tapTimes, format:NSPropertyListFormat.XMLFormat_v1_0, options:Int(0), error:&error)!
        
        let result = data.writeToURL(fileURL, options:NSDataWritingOptions(0), error:&error)
        if (!result) {
            println("(\result)")
        }
    }
}
