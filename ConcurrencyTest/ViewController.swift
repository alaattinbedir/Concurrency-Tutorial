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
let dispatchGroup = DispatchGroup()

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
    
    func setImageFromURls(stringImageUrl url: String){
//        let queue = DispatchQueue(label: "com.concurrency.imageQueue")
        
        let queue = DispatchQueue(label: "com.concurrency,imageQueue",
                                  qos: DispatchQoS.userInitiated,
                                  attributes: DispatchQueue.Attributes.concurrent,
                                  autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem,
                                  target:DispatchQueue.global())
        
        queue.async() { () -> Void in
            if let url = NSURL(string: url) {
                if let data = NSData(contentsOf: url as URL) {
                    DispatchQueue.main.sync {
                        self.image = UIImage(data: data as Data)
                        dispatchGroup.leave()
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
            print("Operation 1 completed, cancelled:\(operation.isCancelled) ")
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
    
    var queue = OperationQueue()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didClickOnStart(_ sender: Any) {

        dispatchGroup.enter()
        self.imageView1.setImageFromURls(stringImageUrl: imageURLs[0])
        
        dispatchGroup.enter()
        self.imageView2.setImageFromURls(stringImageUrl: imageURLs[1])
        
        dispatchGroup.enter()
        self.imageView3.setImageFromURls(stringImageUrl: imageURLs[2])
        
        dispatchGroup.enter()
        self.imageView4.setImageFromURls(stringImageUrl: imageURLs[3])
        
        dispatchGroup.notify(queue: .main) {
            self.view.backgroundColor = UIColor.lightGray
            print("All functions complete 👍")
        }
        
//        let img4 = Downloader.downloadImageWithURL(url: imageURLs[3])
//        self.imageView4.image = img4
        
    }
    
    @IBAction func didClickOnCancel(_ sender: Any) {
        self.queue.cancelAllOperations()
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        
    }
    
    
}

