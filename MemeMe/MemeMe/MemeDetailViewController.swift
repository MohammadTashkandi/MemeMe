//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Mohammad Tashkandi on 24/08/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme?
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memeImage.image = meme?.memedImage
    }
    
}
