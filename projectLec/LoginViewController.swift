//
//  LoginViewController.swift
//  projectLec
//
//  Created by Nabilla Driesandia Azarine on 19/01/22.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    var context:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func loadCheckData(email:String, password:String) -> Bool {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        
        do {
            let result = try context.fetch(req) as! [NSManagedObject]
            
            for data in result {
                let emailCek = data.value(forKey: "email") as! String
                let pass = data.value(forKey: "password") as! String
                
                if(emailCek == email && pass == password ) {
                    return true
                }
            }
            return false
            
        } catch  {
            
        }
        return false
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        if(email == "") {
            alert(msg: "Please insert username", handler: nil)
        }
        else if(password == "") {
            alert(msg: "Please insert password", handler: nil)
        }
        else if(email == "admin" && password == "admin") {
            performSegue(withIdentifier: "loginToHome", sender: self)
        }
        else if(loadCheckData(email: email, password: password)) {
            performSegue(withIdentifier: "loginToHome", sender: self)
        }
        else {
            alert(msg: "Wrong username/password", handler: nil)
        }
    }
    
    func alert(msg:String, handler:((UIAlertAction)->Void)?) {
            let alert = UIAlertController(title: "Check Input Field", message: msg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }

}
