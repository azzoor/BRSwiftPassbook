//
//  ViewController.swift
//  BRSwiftPassbook
//
//  Created by Aaron Stephenson on 12/09/2014.
//  Copyright (c) 2014 Bronron Apps. All rights reserved.
//

import UIKit
import PassKit

class ViewController: UIViewController
{
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func passbookAvailable()->Bool
    {
        //Checks if Passbook is available on the device, if not it displays a warning message.
        if (PKPassLibrary.isPassLibraryAvailable())
        {
            return true
        }
        else
        {
            var alert = UIAlertController(title: "Passbook", message: "Passbook is not available on this device.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:  nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return false
        }
    }

    @IBAction func showPassbookPass(AnyObject)
    {
        //Checks if Passbook is available on the device.
        if (passbookAvailable())
        {
            let path = NSBundle.mainBundle().pathForResource("pass900452108", ofType: "pkpass")
            let data = NSData(contentsOfFile: path!)
            var pass = PKPass(data: data, error:nil)
            
            //Checks if the pass has already been added to the users Passbook. If it is not then it adds it.
            if (!PKPassLibrary().containsPass(pass))
            {
                var viewTmp = PKAddPassesViewController(pass: pass)
                self.presentViewController(viewTmp, animated: true, completion: nil)
            }
                //If the pass is already in the users passbook it asks the user if they wish to remove the pass.
            else
            {
                var alert = UIAlertController(title: "Passbook", message: "This pass already in your Passbook.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:  nil))
                alert.addAction(UIAlertAction(title: "Remove Pass", style: UIAlertActionStyle.Default, handler:  { action in
                    PKPassLibrary().removePass(pass)
                    
                    var alert = UIAlertController(title: "Passbook", message: "Pass has been removed.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:  nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func isPassAlreadyInPassbook()
    {
        //Checks if Passbook is available on the device.
        if (passbookAvailable())
        {
            //Loads a demo pass saved in the applications bundle.
            var alertString = "Pass not found in your Passbook."
            let path = NSBundle.mainBundle().pathForResource("pass900452108", ofType: "pkpass")
            let data = NSData(contentsOfFile: path!)
            var pass = PKPass(data: data, error:nil)
            
            //Checks if the pass has already been added to the users Passbook. If it has it changes the message to appear.
            if (PKPassLibrary().containsPass(pass))
            {
                alertString = "You have already added this pass."
            }
            var alert = UIAlertController(title: "Passbook", message: alertString, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler:  { action in
                self.alertString(action)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func alertString(action: UIAlertAction)
    {
        switch action.style{
        case .Default:
            println("default")
            
        case .Cancel:
            println("cancel")
            
        case .Destructive:
            println("destructive")
        }
    }
}

