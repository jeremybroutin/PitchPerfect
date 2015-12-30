//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jeremy Broutin on 3/17/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
  
  var filePathUrl: NSURL!
  var title: NSString!
  
  init(filePathUrl: NSURL, title: NSString){
    
    self.filePathUrl = filePathUrl
    self.title = title
    
  }
}
