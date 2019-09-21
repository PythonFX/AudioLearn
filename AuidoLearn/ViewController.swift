//
//  ViewController.swift
//  AuidoLearn
//
//  Created by VincentMing on 2019/9/21.
//  Copyright © 2019 zhm. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?

    override func viewDidLoad() {
        super.viewDidLoad()

        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord)
        try? session.overrideOutputAudioPort(.speaker)
        try? session.setActive(true)

        if let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let paths = [basePath, "record.m4a"]
            if let recordURL = NSURL.fileURL(withPathComponents: paths) {
                var settings: [String: Any] = [:]
                settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
                settings[AVSampleRateKey] = 44_100.0
                settings[AVNumberOfChannelsKey] = 2
                audioRecorder = try? AVAudioRecorder(url: recordURL, settings: settings)
                audioRecorder?.prepareToRecord()
            }
        }
    }

    func playSetup(audioURL: URL?) {
        if let url = audioURL {
            setAudioPlayer(url: url)
        } else if let path = Bundle.main.path(forResource: "wispering", ofType: "mp3") {
            setAudioPlayer(url: URL(fileURLWithPath: path))
        }
    }

    func setAudioPlayer(url: URL) {
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.prepareToPlay()
    }

    @IBAction func playBtnPressed(_ sender: Any) {
        audioPlayer?.play()
    }

    @IBAction func pauseBtnPressed(_ sender: Any) {
        audioPlayer?.pause()
    }

    @IBAction func stopBtnPressed(_ sender: Any) {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }

    @IBAction func recordBtnPressed(_ sender: Any) {
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                recorder.record()
            }
        }
    }

    @IBAction func endRecordPressed(_ sender: Any) {
        if let recorder = audioRecorder {
            recorder.stop()
            playSetup(audioURL: recorder.url)
        }
    }


}

