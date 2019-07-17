//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Mohammad Tashkandi on 24/08/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
    // MARK: Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: Table delegate functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath) as! MemeTableViewCell
        
        let currentMeme = self.memes[indexPath.row]
        cell.memeImage.image = currentMeme.origialImage
        cell.topLabel.text = currentMeme.topCaption
        cell.bottomLabel.text = currentMeme.bottomCaption
        
        print(currentMeme.topCaption)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        controller.meme = self.memes[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: Actions
    
    @IBAction func goToCreateMemePage(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        
        present(controller, animated: true)
    }
}
