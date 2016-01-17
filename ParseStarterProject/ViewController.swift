//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var riderLbl: UILabel!
    
    @IBOutlet weak var driverLbl: UILabel!
    
    @IBOutlet weak var `switch`: UISwitch!
    
    @IBOutlet weak var signUpLbl: UIButton!
    
    @IBOutlet weak var logInLbl: UIButton!
    
    
    var signUpState = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      self.username.delegate = self
        self.password.delegate = self
            
            
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        
        
        if username.text == "" || password.text == "" {
        
         alert("Missing Fields", message: "Username and password are required")
       
        
        } else {
        
        if signUpState == true {
                            
        var user = PFUser()
        user.username = username.text
        user.password = password.text
                            

            
            user["isDriver"] = `switch`.on
            
            
            user.signUpInBackgroundWithBlock {
                (succeeded, error) -> Void in
                if let error = error {
                    if  let errorString = error.userInfo["error"] as? NSString {
                    
                    self.alert("Sign Up Failed", message: String(errorString) + " please try something else.")
                    }
                    
                } else {
                    
                  self.performSegueWithIdentifier("loginRider", sender: self)
                    
                }
            }
        
        } else {
            
            PFUser.logInWithUsernameInBackground(username.text!, password:password.text!) {
                (user, error) -> Void in
                if user != nil {
                    
                    self.performSegueWithIdentifier("loginRider", sender: self)
                    
                    
                } else {
                    
                    
                    if  let errorString = error!.userInfo["error"] as? NSString {
                        
                        self.alert("Log In Failed", message: String(errorString) + " please try again")
                    }
                    
                    
                }
            }
            

            
            
            }
        
        
     }
        
        
    }
    
    
    
    
    @IBAction func loginButton(sender: AnyObject) {
        
        if signUpState == true {
        
        signUpLbl.setTitle("Log In", forState: UIControlState.Normal)
            logInLbl.setTitle("Not yet member? Sign Up", forState: UIControlState.Normal)
            signUpState = false
            
            riderLbl.hidden = true
            driverLbl.hidden = true
            
            `switch`.hidden = true
        
        
        } else {
        
            
            signUpLbl.setTitle("Sign Up", forState: UIControlState.Normal)
            logInLbl.setTitle("Already Signed Up? Log In", forState: UIControlState.Normal)
            signUpState = true
            
            riderLbl.hidden = false
            driverLbl.hidden = false
            
            `switch`.hidden = false
        
        
        
        }
        
        
        
    }
    
    
    
    
    
    
    
    func alert (title :String! , message :String!) {
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
   
    
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return false
        
        
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser()?.username != nil {
        
              self.performSegueWithIdentifier("loginRider", sender: self)
        }
        
    }

}
