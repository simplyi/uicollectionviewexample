//
//  MyImageViewController.swift
//  MyCollectionViewExample
//
//  Created by Sergey Kargopolov on 2015-07-31.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit

class MyImageViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    var selectedImage:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
        
        let imageUrl = NSURL(string: self.selectedImage)
        let imageData = NSData(contentsOfURL: imageUrl!)
        
          dispatch_async(dispatch_get_main_queue(),{
              if(imageData != nil)
              {
               self.myImageView.image = UIImage(data: imageData!)
               }
          });
            
        });
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
