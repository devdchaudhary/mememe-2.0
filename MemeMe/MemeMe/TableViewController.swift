//
//  TableViewController.swift
//  MemeMe
//
//  Created by Devanshu on 16/04/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import Foundation
import UIKit

class TableController : UITableViewController {
    
    // This is the shared model of the memes array showing the saved memes
    
    var memes: [Meme]! {
        
        return (UIApplication.shared.delegate as! AppDelegate).memes
        
    }
    
    // This function specifies to reload the tableview everytime the user relaunches the app

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableView.reloadData()

    }
    
     // This function is used to specify that the number of items in the view is as much as the number of memes in the shared model

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
        
    }
    
    // This function is used to specify what each tableview cell displays
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        
        let meme = memes[indexPath.row]

        cell.memeImage.image = meme.memedImage
        
        cell.memeText.text = memes[indexPath.row].topText + "..." + memes[indexPath.row].botText
                
        return cell
    }
    
    // This function is used to specify that the cell display the entire meme when tapped.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memeView = self.storyboard?.instantiateViewController(withIdentifier: "MemeViewer") as! MemeViewer
        
        memeView.meme = self.memes[indexPath.row]
        
        self.navigationController?.pushViewController(memeView, animated: true)
    }
    
}
