//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Daniele on 05/03/15.
//  Copyright (c) 2015 Daniele Savogin. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    //# MARK: - Record Objects
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    //# MARK: - Buttons
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    //# MARK: - Labels
    @IBOutlet weak var recordInPeogres: UILabel!
    
    //# MARK: - Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        recordInPeogres.text = "Tap to Record"
        recordInPeogres.hidden = false
    }

    
    //# MARK: - FinishRecording
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag{
            recordedAudio = RecordedAudio(url: recorder.url, name: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Record was not succesful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
        
    }
    
    //# MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as PlaySoundViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    //# MARK: - Buttons Actions
    @IBAction func stopRecording(sender: UIButton) {
        recordInPeogres.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
        
        stopButton.hidden = false
        recordInPeogres.text = "recording in progress..."
        recordInPeogres.hidden = false
        recordButton.enabled = false
    }
}

