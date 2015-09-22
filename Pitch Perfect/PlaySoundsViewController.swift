//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mohammad Awwad on 8/12/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation
class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, fileTypeHint: nil)
        } catch {}
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        do {
        audioFile = try AVAudioFile(forReading: receivedAudio.filePathUrl!)
        } catch {}
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {

        playAudioWithVariableRate(0.5)
    }
    @IBAction func playFastAudio(sender: UIButton) {

        playAudioWithVariableRate(2)
    }
    @IBAction func playChip(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
    }
    @IBAction func playDarth(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
        
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAllAudio()
    }

    func playAudioWithVariablePitch(pitch: Float)
    {
        
        stopAllAudio()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        //audioEngine.startAndReturnError(nil)
        do {
            try audioEngine.start()
        } catch {}
        audioPlayerNode.play()
    }
    
    func playAudioWithVariableRate(rate: Float)
    {
        stopAllAudio()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()

    }
    func stopAllAudio()
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithReverb()
    {
        stopAllAudio()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        let audioUnitReverb = AVAudioUnitReverb()
        audioUnitReverb.loadFactoryPreset(AVAudioUnitReverbPreset(rawValue: 0)!)
        audioUnitReverb.wetDryMix = 50.0
        audioEngine.attachNode(audioUnitReverb)
        audioEngine.connect(audioPlayerNode, to: audioUnitReverb, format: nil)
        audioEngine.connect(audioUnitReverb, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        //audioEngine.startAndReturnError(nil)
        do {
            try audioEngine.start()
        } catch {}
        audioPlayerNode.play()
        
    }

}
