//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Deborah on 10/30/16.
//  Copyright © 2016 Deborah. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

    func configureUI(recording: Bool){
        // Set label
        recordingLabel.text =
            recording ? "Recording in progress" : "Tap to Record"
        
        // Set buttons
        recordButton.isEnabled = !recording
        stopRecordingButton.isEnabled = recording
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
      
    }

    @IBAction func stopRecording(_ sender: Any) {
        print("Stop Recording Button Pressed")
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text = "Tap To Record"
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called")
        
    }
  
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving recording")
        if (flag) {
        self.performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            
        } else {
            print("Saving Of Recording Failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "stopRecording" {
                let playSoundsVC = segue.destination as! PlaySoundsViewController
                let recordedAudioURL = sender as! NSURL
                playSoundsVC.recordedAudioURL = recordedAudioURL
            }
        }
    }
 
        
