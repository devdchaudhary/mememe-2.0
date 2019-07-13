//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Devanshu on 01/05/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import Foundation
import UIKit

// Collection View class

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
    
{
    
    // This is the shared model of the memes array showing the saved memes
    
    var memes: [Meme]! {
        
        return (UIApplication.shared.delegate as! AppDelegate).memes

    }
    
    // FlowLayout variable decides the flow of the scren
    
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    // This function specifies to reload the collecionview everytime the user relaunches the app
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        collectionView?.reloadData()
        
    }
    
    // This function is used to decide the size of the collection view aswell as the collection cell
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let space:CGFloat = 3
        let dimension = (view.frame.size.width - (2 * space)) / 3
        
        collectionFlowLayout?.minimumInteritemSpacing = space
        collectionFlowLayout?.minimumLineSpacing = 0.0
        collectionFlowLayout?.itemSize = CGSize(width: dimension, height: dimension)

    }
    
    // This function is used to specify that the number of items in the view is as much as the number of memes in the shared model
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    // This function is used to specify what each collection cell displays
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        let meme = memes[indexPath.item]
        
        cell.memeImage.image = meme.memedImage
        
        return cell
    }
    
    // This function is used to specify that the cell display the entire meme when tapped.
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "Memeviewer") as! MemeViewer
        
        controller.meme = self.memes[indexPath.item]
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
}
