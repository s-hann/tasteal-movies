//
//  MovieViewController.swift
//  projectLec
//
//  Created by Nabilla Driesandia Azarine on 19/01/22.
//

import UIKit
import CoreData

class MovieViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblGenre: UILabel!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var seatTableView: UITableView!
    @IBOutlet var totalTicket: UILabel!
    
    var context:NSManagedObjectContext!
    
    var titleSelected:String?
    var genreSelected:String?
    var detailSelected:String?
    var imageSelected:String?
    
    var pickerData = [String]()
    var pickedSeat = [String]()
    var seat:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        seatTableView.delegate = self
        seatTableView.dataSource = self

        lblTitle.text = "\(titleSelected!)"
        lblGenre.text = "\(genreSelected!)"
        lblDetail.text = "\(detailSelected!)"
        totalTicket.text = "Number of Ticket(s): " + String(pickedSeat.count)
        
        let imageUrl = URL(string: imageSelected!)
        DispatchQueue.global().async {
            let imageData = try? Data(contentsOf: imageUrl!)
            DispatchQueue.main.async {
                self.image.image = UIImage(data: imageData!)
            }
        }
        
        pickerData = ["A1", "A2", "A3", "A4", "B1", "B2"]
        seatTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickedSeat.count
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            pickedSeat.remove(at: indexPath.row)
            totalTicket.text = "Number of Ticket(s): " + String(pickedSeat.count)
            seatTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let seatCell = tableView.dequeueReusableCell(withIdentifier: "seatCell", for: indexPath) as! UITableViewCell
        
        seatCell.textLabel?.text = pickedSeat[indexPath.row]

        return seatCell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerData.count
        }
        
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          
              return pickerData[row]
          
        }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        seat = "A1"
        seat = pickerData[row]
        print(seat)
    }
    
    @IBAction func bookBtn(_ sender: Any) {
        
        if(pickedSeat.count == 0) {
            alert(title: "Choose seat", msg: "you must choose minimum 1 seat number", handler: nil)
        }
        else {
            let newMovieName = lblTitle.text!
            var newSeatNumber:String = pickedSeat[0]
            var counter = 0
            
            
            
            for seat in pickedSeat {
                if(counter == 0) {
                    counter += 1
                }
                else{
                    newSeatNumber = newSeatNumber + ", " + seat
                }
                
            }
            
            let entity = NSEntityDescription.entity(forEntityName: "BookedTicketEntity", in: context)
            let newTicket = NSManagedObject(entity: entity!, insertInto: context)
            
            newTicket.setValue(newMovieName, forKey: "movieName")
            newTicket.setValue(newSeatNumber, forKey: "bookedSeat")
            
            
            do {
                try context.save()
            } catch  {
                
            }
            alert(title: "Success", msg: "Booking Ticket Success", handler: nil)
            
        }
    }
    
    @IBAction func backToHome(_ sender: Any) {
        performSegue(withIdentifier: "movieToHome", sender: self)
    }
    
    @IBAction func addbtn(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Seat", message: "\n\n\n\n\n\n", preferredStyle: .alert)
            
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 30, width: 250, height: 140))
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: {
            (UIAlertAction) in
            if(self.seat == nil) {
                self.pickedSeat.append("A1")
            }
            else{
                self.pickedSeat.append(self.seat!)
//                self.pickerData.remove(at: self.indexSelected)
//                self.pickerData[self.indexSelected] = ""
                self.seat = "A1"
            }
            self.totalTicket.text = "Number of Ticket(s): " + String(self.pickedSeat.count)
            self.seatTableView.reloadData()
        })
    
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil )
    }
    
    func alert(title:String, msg:String, handler:((UIAlertAction)->Void)?) {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }
    
}
