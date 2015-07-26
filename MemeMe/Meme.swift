//
//  Meme.swift
//  MemeMe
//
//  Created by Marius Horga on 7/26/15.
//  Copyright © 2015 Marius Horga. All rights reserved.
//

import UIKit

class Meme: NSObject {
    var topText: String?
    var bottomText: String?
    var originalImage: UIImage?
    var memedImage: UIImage?
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
