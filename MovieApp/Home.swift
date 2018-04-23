//
//  Home.swift
//  MovieApp
//
//  Created by shimaa on 7/30/1439 AH.
//  Copyright © 1439 AH MovieAppOrganization. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import CoreData
import Foundation
import SystemConfiguration
private let reuseIdentifier = "cell"

class Home: UICollectionViewController ,MySortProtocol{
    var  MyFilms = [FilmData]()
    var myDetail = DetailOfFilm()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
   if isConnectedToNetwork()
   {
        Alamofire.request("https://api.themoviedb.org/3/movie/popular?api_key=54620bd876fc1e4a556204bb2b52b751&language=en-US&page=1", encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value {
                //print("JSON: \(json)")
                
                let myjson = json as! NSDictionary
                
                   let myFilmsjson = myjson["results"] as! NSArray
                
                   for film in myFilmsjson
                   {
                          let echFilmjson = film as! NSDictionary
                    let comeFilm = FilmData()
                     comeFilm.FilmId = echFilmjson["id"] as! Int
                      comeFilm.original_title = echFilmjson["original_title"] as! String
                    comeFilm.release_Date = echFilmjson["release_date"] as! String
                    comeFilm.vote_average = echFilmjson["vote_average"] as! Float
                    comeFilm.overview = echFilmjson["overview"] as! String
                    let posterimage = echFilmjson["poster_path"] as! String
                    let totalPathOfImage = "http://image.tmdb.org/t/p/w185"+posterimage
                    comeFilm.poster_path=totalPathOfImage
                    self.MyFilms.append(comeFilm)
                  
                   }
            }
            //1
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //2
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: "Movie")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest1 as! NSFetchRequest<NSFetchRequestResult> )
            
            do {
                try  managedContext.execute(deleteRequest)
            } catch let error as NSError {
                print(error)
            }
            //3
            let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)
            
            
            
            
            for value in self.MyFilms{
                
                let movieObject  = NSManagedObject(entity: entity!, insertInto: managedContext)
                //5
                movieObject.setValue(value.FilmId, forKey: "id")
                
                movieObject.setValue(value.original_title, forKey: "originalTitle")
            
                movieObject.setValue(value.poster_path, forKey: "posterImage")
            
                movieObject.setValue(value.release_Date, forKey: "releaseDate")
                
                movieObject.setValue(value.vote_average, forKey: "voteAverage")

                movieObject.setValue(value.overview, forKey: "overview")

                do{
                    try   managedContext.save()
                   // print("success")
                    self.collectionView?.reloadData()
                    
                }catch{
                    
                    print("Error")
                }
            }
            
           }
    
    
        }
        
        else
          {
            print("Not connecting to internet")
            var moviesres : [NSManagedObject] = [NSManagedObject]()
            
            //1
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            //2
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //3
            let request = NSFetchRequest<NSManagedObject>(entityName: "Movie")
            
            do{
                try  moviesres =  managedContext.fetch(request)
                for index in moviesres
                {
                    let myMovieO = FilmData()
                    
                    myMovieO.FilmId=index.value(forKey:"id") as! Int
                    myMovieO.original_title=index.value(forKey: "originalTitle") as! String
                    myMovieO.poster_path=index.value(forKey: "posterImage") as! String
                    myMovieO.release_Date=index.value(forKey: "releaseDate") as!  String
                    myMovieO.vote_average=index.value(forKey: "voteAverage") as! Float
                    myMovieO.overview=index.value(forKey: "overview") as! String
                    self.MyFilms.append(myMovieO)
                     self.collectionView?.reloadData()
                    
                }
            }catch{
                
                print ("error in core Data")
            }
            
        
          }
        
    }
   func updateMovies ( FilmList : Array<FilmData>)
    {
       self.MyFilms = FilmList
        print(FilmList)
        self.collectionView?.reloadData()
        print("Updated")
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mydes = segue.destination as! mySortView
        mydes.myprotocol = self
        print("go success")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //print("numberOfSections")
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
       // print(MyFilms.count)
        return self.MyFilms.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detail") as! DetailOfFilm
        
        vc.mySelectedFilm=self.MyFilms[indexPath.row]
        navigationController?.pushViewController(vc,animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
       let myimage = cell.viewWithTag(1) as! UIImageView
       myimage.sd_setImage(with: URL(string: self.MyFilms[indexPath.row].poster_path), placeholderImage:UIImage(named: "placeholder\(indexPath.row).png"))
        return cell
    }

    /************************check network*********************/
    
    public func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    /***********************************************************/
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
