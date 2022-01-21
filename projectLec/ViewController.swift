//
//  ViewController.swift
//  projectLec
//
//  Created by Hanna Nadia Savira on 18/01/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
    
    var context:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        let name = txtName.text!
        let email = txtEmail.text!
        let pass = txtPassword.text!
        let confirm = txtConfirmPassword.text!
        
        if(name == ""){
            alert(msg: "Plese enter your name", handler: nil)
        }
        else if(email == ""){
            alert(msg: "Please enter your email", handler:nil)
        }
        else if(pass == ""){
            alert(msg: "Plese enter your password", handler:nil)
        }
        else if(confirm == ""){
            alert(msg: "Please confirm your password", handler:nil)
        }
        else if (pass != confirm){
            alert(msg: "Password mismatch", handler: nil)
        }
        else {
            
            
            let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            
            newUser.setValue(name, forKey: "username")
            newUser.setValue(email, forKey: "email")
            newUser.setValue(pass, forKey: "password")
            
            do {
                try context.save()
            } catch  {
                
            }
            
            performSegue(withIdentifier: "regisToHome", sender: self)
        }
    }
    
    @IBAction func toLoginAction(_ sender: Any) {
        performSegue(withIdentifier: "regisToLogin", sender: self)
    }
    
    
    func alert(msg:String, handler:((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: "Check Input Field", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }

}
