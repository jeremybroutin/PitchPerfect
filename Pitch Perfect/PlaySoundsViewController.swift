//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeremy Broutin on 3/16/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
  
  var audioPlayer:AVAudioPlayer!
  var audioPlayerNode:AVAudioPlayerNode!
  
  //delegate message to know when the player has finished playing the audio file
  func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
    print("The playback is finished")
    stopButton.hidden = true
  }
  
  //TODO hide stopButton when audioPlayerNode finished playing (couldn't find how)
  
  var receivedAudio:RecordedAudio!
  var audioEngine:AVAudioEngine!
  var audioFile:AVAudioFile!
  
  @IBOutlet weak var stopButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
    // Initialize the audioPlayer with the audio file from user's recording
    audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
    // Enable the .rate method for slow and fast audio play
    audioPlayer.enableRate = true
      
    // Initialize AVAudioEngine
    audioEngine = AVAudioEngine()
    // Convert audio file from NSURL to AVAudioFile
    audioFile = try? AVAudioFile(forReading: receivedAudio.filePathUrl)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func playAudioWithVariableRate(rate: Float){
    //stop any audioPlayer currently running
    audioPlayer.stop()
    //reset the audioPlayer to 0
    audioPlayer.currentTime = 0.0
    //stop and reset any audioEngine currently running
    audioEngine.stop()
    audioEngine.reset()
    //set the audio rate
    audioPlayer.rate = rate
    //play the audio
    audioPlayer.delegate = self
    audioPlayer.play()
    //show stop button
    stopButton.hidden = false
  }
  
  func playAudioWithVariablePitch(pitch: Float){
    audioPlayer.stop()
    audioEngine.stop()
    audioEngine.reset()
    
    // Initialize the AVAudioPlayerNode
    self.audioPlayerNode = AVAudioPlayerNode()
    // Attach it to the audioEngine
    audioEngine.attachNode(self.audioPlayerNode)
    
    // Initialize the AVAudioPitchTimeUniut
    let changePitchEffect = AVAudioUnitTimePitch()
    // Set the pitch level
    changePitchEffect.pitch = pitch
    // Attach it to the audioEngine
    audioEngine.attachNode(changePitchEffect)
    
    // Connect the AVAUdioPlayerNode to the AVAudioPitchTimeUnit
    audioEngine.connect(self.audioPlayerNode, to: changePitchEffect, format: nil)
    // Connect the AvAudioPitchTimeUnit to the  output (phone speaker)
    audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
    
    // Schedule the file to be played
    self.audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    do {
      // Start the audioEngine
      try audioEngine.start()
    } catch _ {
    }
    
    // Finally play the audioPlayerNode (which contains the modified audioPlayer file)
    self.audioPlayerNode.play()
    stopButton.hidden = false
  }

  
  @IBAction func playSlowAudio(sender: UIButton) {
    playAudioWithVariableRate(0.5)
  }

  @IBAction func playFastAudio(sender: UIButton) {
    playAudioWithVariableRate(1.5)
  }
  
  @IBAction func playChipmunkAudio(sender: UIButton) {
    playAudioWithVariablePitch(1000)
  }
  
  @IBAction func playDarthvaderAudio(sender: UIButton) {
    playAudioWithVariablePitch(-1000)
  }
  
  @IBAction func stopAudio(sender: UIButton) {
    //stop audioPlayer for slow and fast
    audioPlayer.stop()
    //stop audioPlayerNode for chipmunk and darthvader
    audioPlayerNode.stop()
    
    stopButton.hidden = true
  }
  

}