//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeremy Broutin on 3/11/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
  
  @IBOutlet weak var tapToRecord: UILabel!
  @IBOutlet weak var recordingInProgress: UILabel!
  @IBOutlet weak var stopRecording: UIButton!
  @IBOutlet weak var recordButton: UIButton!
  
  var audioRecorder:AVAudioRecorder!
  var recordedAudio:RecordedAudio!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewWillAppear(animated: Bool) {
    stopRecording.hidden = true
    recordButton.enabled = true
    tapToRecord.hidden = false
  }

  @IBAction func recordAudio(sender: UIButton) {
    // Hide "Tap to record" text and show "recording..."
    tapToRecord.hidden = true
    recordingInProgress.hidden = false
    recordButton.enabled = false
    stopRecording.hidden = false

    // Record the user's voice
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    
    let currentDateTime = NSDate()
    let formatter = NSDateFormatter()
    formatter.dateFormat = "ddMMyyyy-HHmmss"
    let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
    let pathArray = [dirPath, recordingName]
    let filePath = NSURL.fileURLWithPathComponents(pathArray)
    print(filePath)
    
    // Setup audio session
    let session = AVAudioSession.sharedInstance()
    do {
      try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
    } catch _ {
    }
    
    // Prepare recorder settings
    let recorderSettings: [String: AnyObject] = [
      AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
      AVEncoderBitRateKey: 16,
      AVNumberOfChannelsKey: 2,
      //AVSampleRateKey: 44100.0
    ]
    
    // Initialize and prepare the recorder
    do {
      try audioRecorder = AVAudioRecorder(URL: filePath!, settings: recorderSettings)
    } catch _ {
    }
    audioRecorder.delegate = self
    audioRecorder.meteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()

  }
  
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
    
    if(flag){
      // STEP 1 - Save the recorded audio
      recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
    
      // STEP 2 - Move to the next scene aka perform segue
      self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    }else{
      print("Oups, it appears that the recording failed. Please try again!")
      recordButton.enabled = true
      stopRecording.hidden = true
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "stopRecording"){
      let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
      let data = sender as! RecordedAudio
      playSoundsVC.receivedAudio = data
      tapToRecord.text = "Tap again for a new recording!"
    }
  }
  
  @IBAction func stopRecordAudio(sender: UIButton) {
    recordingInProgress.hidden = true
    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setActive(false)
    } catch _ {
    }
  }
}

