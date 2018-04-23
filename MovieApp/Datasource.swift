//
//  Datasource.swift
//  MovieApp
//
//  Created by shimaa on 8/3/1439 AH.
//  Copyright © 1439 AH MovieAppOrganization. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class  Datasource :NSObject, UITableViewDataSource, UITableViewDelegate
{
    var myfilmid : Int = 0
    var myTrailers = [MyTrailer]()
    var mycurrentTable = UITableView()
    var flag : Int = 0
    init(FilmId : Int , mytableref : UITableView) {
        
        myfilmid = FilmId
        mycurrentTable = mytableref
        //super.init()
        print("init")

    }
func getTrailers ()
{
    Alamofire.request("https://api.themoviedb.org/3/movie/\(myfilmid)/videos?api_key=54620bd876fc1e4a556204bb2b52b751&language=en-US", encoding: JSONEncoding.default).responseJSON { response in
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
            if self.flag == 0
            {
                self.mycurrentTable.reloadData()
                //print("reload")
                self.flag=1
            }
            
        }
        
}
    
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        //print("section")
        self.getTrailers()
        // print("get")
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("tttttt\(myTrailers.count)")
        return myTrailers.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trailcell", for: indexPath)
        let mylabel = cell.viewWithTag(2) as! UILabel
        mylabel.text=myTrailers[indexPath.row].name
        let mybutton = cell.viewWithTag(1) as! UIButton
      cell.viewWithTag(1)?.tag = (indexPath.section*100)+indexPath.row
        mybutton.addTarget(self, action: #selector(playmyMovie) , for: UIControlEvents.touchUpInside)
        
        return cell
    }
     
    func playmyMovie (Sender : UIButton!)
    {
        let mysection = Sender.tag / 100
        let myrow = Sender.tag % 100
        let indexPath = NSIndexPath(row: myrow, section: mysection)
       let x = myTrailers[indexPath.row].TotalPathofTrailer
      print("my movie\(x)")
    }
}
