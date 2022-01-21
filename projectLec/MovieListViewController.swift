//
//  MovieListViewController.swift
//  projectLec
//
//  Created by Nabilla Driesandia Azarine on 19/01/22.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var movieTableView: UITableView!
    
    var index:Int = 0
    var movieList = [[String:Any]]()
    var baseUrl = "https://imdb-api.com/en/API/InTheaters/k_40nox5dw"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        self.movieTableView.allowsSelection = true
        loadData()
    }
     
    
    func loadData() {
        let apiurl = URL(string: baseUrl)!
        
        var req = URLRequest(url: apiurl)
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req) {
            (data, URLResponse, Error) in
            let jsonString = try! JSONSerialization.jsonObject(with: data!) as! [String:Any]
            let json = jsonString["items"] as! [[String:Any]]
            self.movieList = json
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
            
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "homeToChoose") {
            let dest = segue.destination as! MovieViewController
            dest.titleSelected = movieList[index]["title"] as! String
            dest.genreSelected = movieList[index]["genres"] as! String
            dest.detailSelected = movieList[index]["plot"] as! String
            dest.imageSelected = movieList[index]["image"] as! String
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "homeToChoose", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieTableViewCell
        
        let movieTitle = movieList[indexPath.row]["title"] as! String
        let movieGenre = movieList[indexPath.row]["genres"] as! String
        let movieImage = movieList[indexPath.row]["image"] as! String
        
        movieCell.lblTitle.text = movieTitle
        movieCell.lblGenre.text = movieGenre
        
        let imageUrl = URL(string: movieImage)
        
        var req = URLRequest(url: imageUrl!)
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req) {
            (data, URLResponse, Error) in
            let image = UIImage(data: data!)
            
            DispatchQueue.main.async {
                movieCell.imageView?.image = image
                self.movieTableView.reloadData()
            }
//            DispatchQueue.main.async {
//                movieCell.imageView?.image = image
//                self.movieTableView.reloadData()
//            }
            
        }.resume()
        
        
        
        return movieCell
    }

}


