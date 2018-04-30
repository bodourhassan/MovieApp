//
//  TrailerTotal.swift
//  MovieApp
//
//  Created by shimaa on 8/12/1439 AH.
//  Copyright © 1439 AH MovieAppOrganization. All rights reserved.
//  

import UIKit
import Alamofire
class TrailerTotal: UITableViewController {
    
    var FilmId :Int = 0
    var myTrailers = [MyTrailer]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
         getTrailers()
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
       return myTrailers.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trailcelltotal", for: indexPath)
        let mylabel = cell.viewWithTag(2) as! UILabel
        mylabel.text=myTrailers[indexPath.row].name
       if let mybutton = cell.viewWithTag(1) as! UIButton?
       {
        cell.viewWithTag(1)?.tag = (indexPath.section*100)+indexPath.row
        mybutton.addTarget(self, action: #selector(playmyMovie) , for: UIControlEvents.touchUpInside)
       }
        
        return cell
    }
    /*********************PlayMovies***********************/
    func playmyMovie (Sender : UIButton!)
    {
        let mysection = Sender.tag / 100
        let myrow = Sender.tag % 100
        let indexPath = NSIndexPath(row: myrow, section: mysection)
        let x = myTrailers[indexPath.row].TotalPathofTrailer
        print("my movie\(x)")
        UIApplication.shared.open( URL(string: x)! as URL, options: [:], completionHandler: nil)
    }
    
    /************************Tailers**********************/
    
    func getTrailers ()
    {
        Alamofire.request("https://api.themoviedb.org/3/movie/\(FilmId)/videos?api_key=54620bd876fc1e4a556204bb2b52b751&language=en-US", encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value {
                // print("JSON: \(json)")
                
                let myjson = json as! NSDictionary
                
                let myFilmsjson = myjson["results"] as! NSArray
            
                for Trailer in myFilmsjson
                {
                    let echFilmjson = Trailer as! NSDictionary
                    let comeTrailer = MyTrailer()
                    comeTrailer.name = echFilmjson["name"] as! String
                    let videoKey = echFilmjson["key"] as! String
                    let totalPathOfVideo = "https://www.youtube.com/watch?v="+videoKey
                    comeTrailer.TotalPathofTrailer=totalPathOfVideo
                    self.myTrailers.append(comeTrailer)
                    
                }
                
                if self.myTrailers.count > 0
                {
                self.tableView.reloadData()
                }
                else
                {
                    let alert = UIAlertController(title: "Trailer Avaliablity", message: "No Trailer Founds For This Film", preferredStyle: .alert)
                    
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
