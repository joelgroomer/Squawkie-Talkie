//
//  SoundHelper.swift
//  Squawkie-Talkie
//
//  Created by Joe on 1/16/21.
//

import AVFoundation
import Foundation

class AudioPlayerLayer {
    let player = AVAudioPlayer()
    let session = AVAudioSession.sharedInstance()
    let recorder = AVAudioRecorder()
    
    var isRecording: Bool {
        return recorder.isRecording
    }
    
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir
    }
    
}
<<<<<<< HEAD
=======

>>>>>>> ce2edc54933b2c87142babaa9d7b989aa4b1a143
