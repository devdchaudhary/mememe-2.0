//
//  MemeViewer.swift
//  MemeMe
//
//  Created by Devanshu on 14/04/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import Foundation
import UIKit

// This Controller opens up whenever the user taps on their saved meme

class MemeViewer: UIViewController {
    
    @IBOutlet weak var DetailImage: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        DetailImage.image = meme.memedImage
        
    }
    

}
