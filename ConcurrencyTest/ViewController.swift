//
//  ViewController.swift
//  ConcurrencyTest
//
//  Created by Alaattin Bedir on 4.12.2017.
//  Copyright © 2017 magiclampgames. All rights reserved.
//

import UIKit

let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg"]

var queue = OperationQueue()

class Downloader {
    
    class func downloadImageWithURL(url:String) -> UIImage! {
        let url = URL(string: url)
        let data = try? Data(contentsOf: url!)
        return UIImage(data: data!)
    }
}


extension UIImageView{
    
    func setImageFromURl(stringImageUrl url: String){
        let queue = DispatchQueue.global()
        queue.async() { () -> Void in
            if let url = NSURL(string: url) {
                if let data = NSData(contentsOf: url as URL) {
                    DispatchQueue.main.sync {
                        self.image = UIImage(data: data as Data)
                    };
                }
            }
        }
    }
    
    func setImageFromURL(stringImageUrl url: String){
        queue = OperationQueue()
        queue.addOperation { () -> Void in
            if let url = NSURL(string: url) {
                if let data = NSData(contentsOf: url as URL) {
                    OperationQueue.main.addOperation({
                        self.image = UIImage(data: data as Data)
                    })
                }
            }
        }
    }
    
    func setImageFromURLs(stringImageUrl url: String){
        queue = OperationQueue()
        
        let operation = BlockOperation {
            if let url = NSURL(string: url) {
                if let data = NSData(contentsOf: url as URL) {
                    OperationQueue.main.addOperation({
                        self.image = UIImage(data: data as Data)
                    })
                }
            }
        }
        
        operation.completionBlock = {
            print("Operation 1 completed")
        }
        
        queue.addOperation(operation)
        
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var imageView3: UIImageView!
    
    @IBOutlet weak var imageView4: UIImageView!
    
    @IBOutlet weak var sliderValueLabel: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didClickOnStart(_ sender: Any) {

        self.imageView1.setImageFromURLs(stringImageUrl: imageURLs[0])
        
        self.imageView2.setImageFromURL(stringImageUrl: imageURLs[1])
        
        self.imageView3.setImageFromURl(stringImageUrl: imageURLs[2])
        
        self.imageView4.setImageFromURl(stringImageUrl: imageURLs[3])
        
//        let img4 = Downloader.downloadImageWithURL(url: imageURLs[3])
//        self.imageView4.image = img4
        
    }
    
    @IBAction func didClickOnCancel(_ sender: Any) {
        
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        
    }
    
    
}

