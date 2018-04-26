//
//  ReviewSource.swift
//  MovieApp
//
//  Created by shimaa on 8/5/1439 AH.
//  Copyright © 1439 AH MovieAppOrganization. All rights reserved.
//  reviewcell

import Foundation
import UIKit
import Alamofire

class  ReviewSource :NSObject, UITableViewDataSource, UITableViewDelegate
{
    var myfilmid : Int = 0
    var myreview = [myReview]()
    var mycurrentTable = UITableView()
    var flag : Int = 0
    init(FilmId : Int , mytableref : UITableView) {
        
        myfilmid = FilmId
        mycurrentTable = mytableref
        //super.init()
        print("init22")
        
    }
    func getReview ()
    {
       
        Alamofire.request("https://api.themoviedb.org/3/movie/\(myfilmid)/reviews?api_key=54620bd876fc1e4a556204bb2b52b751&language=en-US", encoding: JSONEncoding.default).responseJSON { response in
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
                if self.flag == 0
                {
                    self.mycurrentTable.reloadData()
                    print("reload")
                    self.flag=1
                }
                
            }
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("section222")
        self.getReview()
        print("get")
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tttttt222\(myreview.count)")
        return myreview.count;
        // return 2;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewcell", for: indexPath)
       let myauthor = cell.viewWithTag(3) as! UILabel
        myauthor.text=myreview[indexPath.row].author
        let mycontent = cell.viewWithTag(4) as! UILabel
        mycontent.text=myreview[indexPath.row].Content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("select")
    }
    
}
