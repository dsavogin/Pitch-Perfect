//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Daniele on 25/03/15.
//  Copyright (c) 2015 Daniele Savogin. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    override init()
    {
        title = ""
        filePathUrl = NSURL()
    }
    
}