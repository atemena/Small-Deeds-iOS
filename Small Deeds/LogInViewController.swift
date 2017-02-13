//
//  LogInViewController.swift
//  Small Deeds
//
//  Created by Andrew Temena on 11/2/16.
//  Copyright © 2016 SmallDeeds. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Action
    
    @IBAction func login(_ sender: AnyObject) {
        //check for token
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        let keychain = KeychainWrapper()
        let client = ClientAPI()
        client.getToken(params: ["username": usernameField.text!.trimmingCharacters(in: .whitespaces) as AnyObject, "password":passwordField.text! as AnyObject], completion:{(_ success: Bool, _ json: JSON?) -> () in
            keychain.mySetObject("SmallDeeds", forKey:kSecAttrService)
            keychain.mySetObject(self.usernameField.text!, forKey:kSecAttrAccount)
            keychain.mySetObject(json?["token"].stringValue, forKey:kSecValueData)
            keychain.writeToKeychain()
            //save token to keychain
            self.performSegue(withIdentifier: "dismissLogin", sender: self)
            return ()
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
