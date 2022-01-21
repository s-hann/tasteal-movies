//
//  TicketViewController.swift
//  projectLec
//
//  Created by Nabilla Driesandia Azarine on 19/01/22.
//

import UIKit
import CoreData

class TicketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var ticketTableView: UITableView!
    
    var ticketList = [Ticket]()
    var context:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ticketTableView.dataSource = self
        ticketTableView.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        loadData()
    }
    
    func loadData() {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "BookedTicketEntity")
        
        ticketList.removeAll()
        
        do {
            let result = try context.fetch(req) as! [NSManagedObject]
            
            for data in result {
                let movieName = data.value(forKey: "movieName") as! String
                let bookedSeat = data.value(forKey: "bookedSeat") as! String
                
                ticketList.append(Ticket(movieName: movieName, bookedSeat: bookedSeat))
            }
            
            ticketTableView.reloadData()
        } catch  {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ticketList.count
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            deleteData(indexPath: indexPath)
        }
    }
    
    func deleteData(indexPath: IndexPath){
        
        let ticketToDelete = ticketList[indexPath.row].movieName
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "BookedTicketEntity")
        let predicate = NSPredicate(format: "movieName == %@", ticketToDelete)
        req.predicate = predicate
        
        do {
            let result = try context.fetch(req) as! [NSManagedObject]
            
            for data in result {
                context.delete(data)
            }
            
            try context.save()
            loadData()
        } catch  {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ticketCell = tableView.dequeueReusableCell(withIdentifier: "ticketCell", for: indexPath) as! UITableViewCell
        let bookedSeat = ticketList[indexPath.row].bookedSeat as! String
        let characters = Array(bookedSeat)
        var seatCount = 1
        
        for c in characters {
            if(c == ",") {
                seatCount += 1
            }
        }
        
        ticketCell.textLabel?.text = ticketList[indexPath.row].movieName
        ticketCell.detailTextLabel?.text = bookedSeat + " (" + String(seatCount) + " ticket(s))"
        
        return ticketCell
    }

}
