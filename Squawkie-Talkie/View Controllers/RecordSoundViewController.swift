//
//  RecordSoundViewController.swift
//  Squawkie-Talkie
//
//  Created by Joe on 1/17/21.
//
import AVFoundation
import CoreData
import UIKit

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var phraseTextField: UITextField!
    
    let dataController = DataController()
    var url: URL?
    var audio = AudioPlayerLayer()
    var audioRecorder = AudioPlayerLayer().recorder
    var audioPlayer = AudioPlayerLayer().player
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        if audioRecorder.isRecording {
            audioRecorder.stop()
            recordButton.setTitle("Record", for: .normal)
            return
        }
            do {
                let fm = audio.newRecordingURL()
                let file = UUID()
                let url = fm.appendingPathComponent("\(file).caf")
                let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!
                audioRecorder = try AVAudioRecorder(url: url, format: format)
                audioRecorder.record()
//                phrase.url = url
                self.url = url
                recordButton.setTitle("Stop", for: UIControl.State.normal)
            } catch {
                NSLog("Unable to start recording: \(error)")
            }
        
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            playButton.setTitle("Play", for: .normal)
            return
        }
        if let sound = url {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: sound)
                audioPlayer.currentTime = 0
                audioPlayer.play()
//                playButton.setTitle("Stop", for: .normal)
            } catch {
                NSLog("Error initializing audio player: \(error)")
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        var phrase = Phrase(context: dataController.moc)
        phrase.active = true
        phrase.url = url
        phrase.text = phraseTextField.text
        do {
            try dataController.moc.save()
        } catch {
            print("There was an error \(error).")
        }
        navigationController?.popViewController(animated: true)
    }
}
