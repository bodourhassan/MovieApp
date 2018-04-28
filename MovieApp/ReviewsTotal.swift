//
//  ReviewsTotal.swift
//  MovieApp
//
//  Created by shimaa on 8/12/1439 AH.
//  Copyright © 1439 AH MovieAppOrganization. All rights reserved.
//

import UIKit
import Alamofire
class ReviewsTotal: UITableViewController {
     var FilmId :Int = 0
    var myreview = [myReview]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        getReview()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return myreview.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewcelltotal", for: indexPath)
        let myauthor = cell.viewWithTag(3) as! UILabel
        myauthor.text=myreview[indexPath.row].author
        let mycontent = cell.viewWithTag(4) as! UITextView
        mycontent.text=myreview[indexPath.row].Content
        return cell
    }
    
    /**********************Reviews************************/
    func getReview ()
    {
        
        Alamofire.request("https://api.themoviedb.org/3/movie/\(FilmId)/reviews?api_key=54620bd876fc1e4a556204bb2b52b751&language=en-US", encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value {
                print("JSON: \(json)")
                
                let myjson = json as! NSDictionary
                
                let myFilmsjson = myjson["results"] as! NSArray
                
                for Trailer in myFilmsjson
                {
                    let echFilmjson = Trailer as! NSDictionary
                    let comeTrailer = myReview()
                    comeTrailer.author = echFilmjson["author"] as! String
                    comeTrailer.Content=echFilmjson["content"] as! String
                    self.myreview.append(comeTrailer)
                    
                }
                if self.myreview.count > 0
                {
                    self.tableView.reloadData()
                }
                else
                {
                    let alert = UIAlertController(title: "Reviews Avaliablity", message: "No Reviews Founds For This Film", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true)
                }
                
            }
            
        }
        
    }



}
