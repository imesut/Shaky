//
//  MusicUtils.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 9.11.2023.
//

import Foundation
import AVKit

class Music : Observable {
    static let shared = Music()
    
    // Assets
    let mainMusic = AVAsset(url: URL(fileURLWithPath:Bundle.main.path(
        forResource: ["mainMusic", "mainMusic2"].randomElement(),
        ofType: "mp3")!))
    private let levelSuccessMusic = URL(fileURLWithPath:Bundle.main.path(forResource: "levelSuccess", ofType: "mp3")!)
    private let levelNeutralMusic = URL(fileURLWithPath:Bundle.main.path(forResource: "levelNeutral", ofType: "mp3")!)
    
    // Important to have a sound, class should have an initial Player.
    // https://www.globalnerdy.com/2015/07/06/how-to-fix-the-common-no-sound-from-avplayer-avaudioplayer-problem-in-ios-swift-programming/
    var player = AVAudioPlayer()
    let mainMusicQueue = AVQueuePlayer()

    // Functions
    func playMainMusic(action : musicAction){
        switch action {
        case .play:
            let mainMusic = AVPlayerItem(asset: mainMusic)
            _ = AVPlayerLooper(player: mainMusicQueue, templateItem: mainMusic)
            mainMusicQueue.volume = 0.25
            mainMusicQueue.play()
        case .pause:
            mainMusicQueue.pause()
        case .resume:
            mainMusicQueue.play()
        }
    }
    
    func playLevelTransitSound(completionType : LevelPassView.completionType){
        let sound = completionType == .success ? levelSuccessMusic : levelNeutralMusic
        do {
            player = try AVAudioPlayer(contentsOf: sound)
            player.volume = 1.00
            player.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}


extension Music{
    enum musicAction {
        case play
        case pause
        case resume
    }
}
