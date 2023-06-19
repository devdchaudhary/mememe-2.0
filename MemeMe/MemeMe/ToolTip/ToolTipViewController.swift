//
//  ToolTipViewController.swift
//  MemeMe
//
//  Created by devdchaudhary on 19/06/23.
//  Copyright © 2023 Devanshu. All rights reserved.
//

import UIKit

class ToolTipViewController: UIViewController {
    
    @IBOutlet weak var iamgeOrientation: UILabel? = nil
    
    @IBOutlet weak var imageWidth: UILabel? = nil
    @IBOutlet weak var imaegHeight: UILabel? = nil
    
    var imageData: ImageDataModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
     
        if let imageData {
            
            iamgeOrientation?.text = imageData.orientation
            imageWidth?.text = imageData.width.description
            imaegHeight?.text = imageData.height.description
            
        }
            
    }
    
}
