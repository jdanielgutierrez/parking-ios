//
//  ViewController.swift
//  ParqueoApp
//
//  Created by internet on 5/13/15.
//  Copyright (c) 2015 internet. All rights reserved.
//

import UIKit
import CoreData

func documentsDirectory() -> String {
    let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as? String
    return documentsFolderPath!
}

func fileInDocumentsDirectory(filename: String) -> String {
    return documentsDirectory().stringByAppendingPathComponent(filename)
}

class ItemViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textFieldAddress: FloatLabelTextField!
    @IBOutlet weak var textFieldRate: FloatLabelTextField!
    @IBOutlet weak var textFieldSchedule: FloatLabelTextField!

    @IBOutlet weak var textFieldLongitude: UITextField!
    @IBOutlet weak var textFieldLatitude: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var currentItem: NSManagedObject!
    var id:String!
    
    
    
    override func viewDidLoad() {
        var myImageName: String
        super.viewDidLoad()
        println(currentItem)
        
        self.view.addSubview(photoImageView)
        
        textFieldLatitude.userInteractionEnabled = false
        
        textFieldLongitude.userInteractionEnabled = false
        
        if(currentItem != nil){
            textFieldAddress.text = currentItem.valueForKey("address") as String
            textFieldSchedule.text = currentItem.valueForKey("schedule") as String
            textFieldRate.text = currentItem.valueForKey("rate") as String
            textFieldLongitude.text = currentItem.valueForKey("longitude") as String
            textFieldLatitude.text = currentItem.valueForKey("latitude") as String
            
            println(currentItem)
            
            id = currentItem.valueForKey("id") as String
            
            myImageName = id + ".png"
            
            let imagePath = fileInDocumentsDirectory(myImageName)
            
            let image = loadImageFromPath(imagePath)
            photoImageView.image = image
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pressSave(sender: AnyObject) {
        println("Save")
        var myImageName: String
        var idParking: String
        // Reference to our app delegate
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let contxt:NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("Parking", inManagedObjectContext: contxt)
        if (currentItem != nil)
        {
            currentItem.setValue(textFieldAddress.text, forKey: "address");
            currentItem.setValue(textFieldSchedule.text, forKey: "schedule");
            currentItem.setValue(textFieldRate.text, forKey: "rate");
            currentItem.setValue(textFieldLongitude.text, forKey: "longitude");
            currentItem.setValue(textFieldLatitude.text, forKey: "latitude");
            currentItem.setValue(id, forKey: "id")
            
        }
        else
        {
            println("Nuevo")
            var newItem = Parking(entity:en!, insertIntoManagedObjectContext:contxt)
            newItem.address = textFieldAddress.text
            newItem.schedule = textFieldSchedule.text
            newItem.rate = textFieldRate.text
            newItem.longitude = textFieldLongitude.text
            newItem.latitude = textFieldLatitude.text
            println(newItem)
            
            idParking=generateId()
            
            newItem.id = idParking
            
            myImageName = idParking + ".png"
            
            println(myImageName)
            
            let imagePath = fileInDocumentsDirectory(myImageName)
            
            if (saveImage(photoImageView.image!, path: imagePath))
            {println("image saved")}
            else
            {println("Dont save image")}
            
        }
        
        contxt.save(nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
        // reference Moc
        // Create instance of pur data model and initialize
        // Map our properties
        // save our context
        // navigation back to root
        
    }
    
    
    @IBAction func openPhotoLibrary(sender: AnyObject) {
        var photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .PhotoLibrary
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info:  [NSObject : AnyObject]!) {
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData.writeToFile(path, atomically: true)
        
        return result
        
    }
    
    func loadImageFromPath(path: String) -> UIImage?
    {
    
        println(path)
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            println("missing image at: (path)")
        }
        println("(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
    func generateId()-> String
    {

        var parkings = [Parking]()
        // Retreive the managedObjectContext from AppDelegate
        
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        
        let fetchRequest = NSFetchRequest(entityName: "Parking")
        
        // Create a sort descriptor object that sorts on the "title"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.returnsObjectsAsFaults = false;
        
        var results: NSArray! = context.executeFetchRequest(fetchRequest, error: nil);
        
        if (results != nil)
        {
            println("request")
            
            if (results.count>1)
            {
                println(results.count)
                
                return String((results[0].valueForKey("id") as String).toInt()!+1)
                
            }
            else
            {
                return "1"
                
            }
        }
        else
        {
            println("primero")
            return "1"
        }
        
        
    }
    
    func updateLocation(data: Location) {

        textFieldLongitude.text = data.longitude
        textFieldLatitude.text = data.latitude
        
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        // When preparing for the segue, have viewController1 provide a closure for
        // onDataAvailable
        if let viewController = segue.destinationViewController as? MapViewController {
            viewController.onDataAvailable = {[weak self]
                (data) in
                if let weakSelf = self {
                    weakSelf.updateLocation(data)
                }
            }
        }
        
        if (segue.identifier=="selectMap")
        {
            var svc = segue!.destinationViewController as MapViewController;
            svc.toLatitude = textFieldLatitude.text
            svc.toLongitude = textFieldLongitude.text
            
        }
        println("Entro")
    }
    
    
}

