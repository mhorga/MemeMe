//
//  SentMemesCollectionVC.swift
//  MemeMe
//
//  Created by Marius Horga on 7/26/15.
//  Copyright © 2015 Marius Horga. All rights reserved.
//

import UIKit

class SentMemesCollectionVC: UICollectionViewController {
    
    var memes: [Meme]!
    let identifier = "collectionCell"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! MemesCollectionViewCell
        let meme = memes[indexPath.item]
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        cell.imageView.image = meme.originalImage
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let object = storyboard!.instantiateViewControllerWithIdentifier("detailView")
        let detailVC = object as! DetailViewController
        detailVC.meme = memes[indexPath.item]
        navigationController!.pushViewController(detailVC, animated: true)
    }
}
