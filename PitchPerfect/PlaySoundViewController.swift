//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Daniele on 24/03/15.
//  Copyright (c) 2015 Daniele Savogin. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioEnginePaused: Bool!

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioEnginePaused = false
    }
    
    override  func viewDidAppear(animated: Bool) {
        stopButton.enabled = false
        playButton.enabled = false
        pauseButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudio(rate: Float)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
        
        stopButton.enabled = true
        playButton.enabled = false
        pauseButton.enabled = true
        
    }

    @IBAction func playSlow(sender: UIButton) {
        playAudio(0.5)
    }
    @IBAction func playFast(sender: UIButton) {
        playAudio(1.5)
    }
    
    @IBAction func stopPlay(sender: UIButton) {
        audioEngine.stop()
        audioPlayer.stop()
        stopButton.enabled = false
        playButton.enabled = false
        pauseButton.enabled = false
    }
    
    
    
    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    @IBAction func playDarthvader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func surpriseEffect(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var inputNode = AVAudioPlayerNode()
        audioEngine.attachNode(inputNode)

        var unitReverb = AVAudioUnitReverb()
        unitReverb.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        unitReverb.wetDryMix = 50
        
        let format = unitReverb.inputFormatForBus(0)
        audioEngine.connect(inputNode, to: unitReverb, format: format)
        audioEngine.connect(unitReverb, to: audioEngine.outputNode, format: format)       
        
        inputNode.scheduleFile( audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        inputNode.play()
        
        stopButton.enabled = true
        playButton.enabled = false
        pauseButton.enabled = true
    }
    
    @IBAction func playResume(sender: UIButton) {
        if(audioEnginePaused.boolValue){
            audioEngine.startAndReturnError(nil)
        }else{
            audioPlayer.play()
        }
        playButton.enabled = false
        pauseButton.enabled = true
        stopButton.enabled = true
    }
    
    @IBAction func pause(sender: UIButton) {
        if audioEngine.running{
            audioEnginePaused = true
        }
        audioEngine.pause()
        audioPlayer.pause()
        playButton.enabled = true
        pauseButton.enabled = false
        stopButton.enabled = true
    }
    
    func  playAudioWithVariablePitch(pitch: Float)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format:nil)
        audioEngine.connect(changePitchEffect, to:audioEngine.outputNode, format:nil)
        
        audioPlayerNode.scheduleFile( audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
        stopButton.enabled = true
        playButton.enabled = false
        pauseButton.enabled = true
    }
    
    
}
