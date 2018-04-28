//
//  mySortView.swift
//  MovieApp
//
//  Created by shimaa on 8/6/1439 AH.
//  Copyright © 1439 AH MovieAppOrganization. All rights reserved.
//

import UIKit
import SystemConfiguration
import Foundation
import Alamofire
import CoreData
class mySortView: UIViewController {
    
    var myprotocol : MySortProtocol?
    
    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius=10
        popupView.layer.masksToBounds=true
       
    }

    @IBAction func MostPopularClick(_ sender: UIButton) {
        
     getMovieDependOnSort(FilmsPathString: "https://api.themoviedb.org/3/movie/popular?api_key=54620bd876fc1e4a556204bb2b52b751&language=en-US&page=1")
        dismiss(animated: true, completion: nil)
      
        
    }
    @IBAction func TopRatedClick(_ sender: UIButton) {
          getMovieDependOnSort(FilmsPathString: "https://api.themoviedb.org/3/movie/top_rated?api_key=54620bd876fc1e4a556204bb2b52b751&language=en-US&page=1")
        
        dismiss(animated: true, completion: nil)
    }
    
    func getMovieDependOnSort(FilmsPathString : String )
    {
        var  MyFilms = [FilmData]()
       if isConnectedToNetwork()
       {
        
            Alamofire.request(FilmsPathString, encoding: JSONEncoding.default).responseJSON { response in
                if let json = response.result.value {
                   
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
                        MyFilms.append(comeFilm)
                        
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
                
                
                
                
                for value in MyFilms{
                    
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
                        self.myprotocol?.updateMovies(FilmList: MyFilms)
                        
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
                    MyFilms.append(myMovieO)
                    //self.collectionView?.reloadData()
                   self.myprotocol?.updateMovies(FilmList: MyFilms)
                    
                }
            }catch{
                
                print ("error in core Data")
            }
            
            
        }
       
}
   /***********************check Network Connection******************/
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
    /******************************************************************/

}
