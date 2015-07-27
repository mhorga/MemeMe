//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Marius Horga on 7/26/15.
//  Copyright © 2015 Marius Horga. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var meme: Meme?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme?.memedImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
}
