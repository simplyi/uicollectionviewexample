//
//  ViewController.swift
//  MyCollectionViewExample
//
//  Created by Sergey Kargopolov on 2015-07-31.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
 
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var images = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        loadImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
      return images.count
    }
    
 
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
       
        
        let myCell:MyCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("myCell", forIndexPath: indexPath) as! MyCollectionViewCell
        
        myCell.myImageView.image = nil
        
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        
            let imageHolder = self.images[indexPath.row] as! [String:AnyObject]
            let imageThumbString = imageHolder["thumb"] as! String
            let imageUrl = NSURL(string: imageThumbString)
            let imageData = NSData(contentsOfURL: imageUrl!)
           
          dispatch_async(dispatch_get_main_queue(),{
             if(imageData != nil)
             {
                myCell.myImageView.image = UIImage(data: imageData!)
             }
           });
            
        });
        
        return myCell
        
    }
    
    
      func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
      {
        println("User tapped on image # \(indexPath.row)")
        
        
        let myImageViewPage:MyImageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyImageViewController") as! MyImageViewController
        
        
        let imageHolder = self.images[indexPath.row] as! [String:AnyObject]
        let imagePreviewString = imageHolder["preview"] as! String
        
        myImageViewPage.selectedImage = imagePreviewString
        
        self.navigationController?.pushViewController(myImageViewPage, animated: true)
       
      }
    
    func loadImages()
    {
        
        myActivityIndicator.hidden = false
        myActivityIndicator.startAnimating()
        
        let startTime = NSDate.timeIntervalSinceReferenceDate()
        
        var pageUrl = "http://swiftdeveloperblog.com/list-of-images/?uudi=" + NSUUID().UUIDString
        let myUrl = NSURL(string: pageUrl);
        let request = NSMutableURLRequest(URL:myUrl!);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
   
            dispatch_async(dispatch_get_main_queue(),{
              self.myActivityIndicator.hidden = true
              self.myActivityIndicator.stopAnimating()
            });
            
            // If error display alert message
            if error != nil {
                var myAlert = UIAlertController(title:"Alert", message:error.localizedDescription, preferredStyle:UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction)
                
                self.presentViewController(myAlert, animated: true, completion: nil)
                
                return
            }
            
            var err: NSError?
            var jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSArray
            
             if let parseJSONArray = jsonArray {
                
                self.images = parseJSONArray
                
                dispatch_async(dispatch_get_main_queue(),{
                    self.myCollectionView.reloadData()
                });
                
            }
        }
        
        task.resume()
        
    }
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        loadImages()
    }
 
}

