//
//  DetailOfFilm.swift
//  MovieApp
//
//  Created by shimaa on 8/3/1439 AH.
//  Copyright © 1439 AH MovieAppOrganization. All rights reserved.
//
/*
 https://api.themoviedb.org/3/movie/269149/videos?api_key=54620bd876fc1e4a556204bb2b52b751&language=en-US
  Url of movie trailers
 
 https://api.themoviedb.org/3/movie/269149/reviews?api_key=54620bd876fc1e4a556204bb2b52b751&language=en-US
   Url of reviews
 
 */
import UIKit
import CoreData
import Alamofire
class DetailOfFilm: UITableViewController {
    var mySelectedFilm = FilmData()
    var myTrailers = [MyTrailer]()
    var myreview = [myReview]()

    //var flag = 0
    var moviesres : [NSManagedObject] = [NSManagedObject]()
    @IBOutlet weak var myfavbutton: UIButton!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var mydesc: UITextView!
    @IBOutlet weak var myVoteAverage: UILabel!
    @IBOutlet weak var myReleaseData: UILabel!
    @IBOutlet weak var myTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImage.sd_setImage(with: URL(string:mySelectedFilm.poster_path), placeholderImage: UIImage.init(named:"detail.png"))
        myVoteAverage.text=String(mySelectedFilm.vote_average)
        myReleaseData.text=mySelectedFilm.release_Date
        myTitle.text=mySelectedFilm.original_title
        mydesc.text=mySelectedFilm.overview
        if( UserDefaults.standard.string(forKey: "favoriteimage\(mySelectedFilm.FilmId)") != nil)
        {
            let myfavIconpass : String = UserDefaults.standard.string(forKey: "favoriteimage\(mySelectedFilm.FilmId)")!
            myfavbutton.setImage(UIImage.init(named: myfavIconpass), for: UIControlState.normal)

        }
        
    }
    @IBAction func ClickFavorite(_ sender: UIButton) {
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //2
        let managedContext = appDelegate.persistentContainer.viewContext
        //3
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteFilm", in: managedContext)
        
        
        
        
        if sender.imageView?.image == UIImage.init(named: "HeartE.png")
        {
            sender.setImage(UIImage.init(named: "heartE2.png"), for: UIControlState.normal)
            //flag = 1
            //add this movie to favorite
            
            let movieObject  = NSManagedObject(entity: entity!, insertInto: managedContext)
            //5
            movieObject.setValue(mySelectedFilm.FilmId, forKey: "id")
            
            movieObject.setValue(mySelectedFilm.original_title, forKey: "originalTitle")
            
            movieObject.setValue(mySelectedFilm.poster_path, forKey: "posterImage")
            
            movieObject.setValue(mySelectedFilm.release_Date, forKey: "releaseDate")
            
            movieObject.setValue(mySelectedFilm.vote_average, forKey: "voteAverage")
            
            movieObject.setValue(mySelectedFilm.overview, forKey: "overview")
            
            do{
                try   managedContext.save()
                print("success")
                
            }catch{
                
                print("Error")
            }
            UserDefaults.standard.set("heartE2.png", forKey: "favoriteimage\(mySelectedFilm.FilmId)")
        }
        else{
            sender.setImage(UIImage.init(named: "HeartE.png"), for: UIControlState.normal)
            
            UserDefaults.standard.set("HeartE.png", forKey: "favoriteimage\(mySelectedFilm.FilmId)")
            
            let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteFilm")
            
            do{
                try  moviesres =  managedContext.fetch(request)
                for index in moviesres
                {
                    if  (index.value(forKey:"id") as! Int ) == mySelectedFilm.FilmId
                    {
                        print("enteeeeeeeeeeeer")
                        do{
                            managedContext.delete(index)
                            try  managedContext.save()
                        }
                        catch{
                            
                            print("error in delete")
                        }
                    }
                    
                }
            }
            catch{
                
                print ("error in core Data")
            }
            
        }
    }
    @IBAction func getTrailerTotal(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "totalTrailerID") as! TrailerTotal
        
        vc.FilmId=mySelectedFilm.FilmId
        navigationController?.pushViewController(vc,animated: true)
    }
    
    @IBAction func getReviewsTotal(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "totalReviewID") as! ReviewsTotal
        
        vc.FilmId=mySelectedFilm.FilmId
        navigationController?.pushViewController(vc,animated: true)

    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
        return super.tableView(tableView, numberOfRowsInSection: section)
        
        }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                  return super.tableView(tableView, cellForRowAt: indexPath)
        
    }
    
    
    
   
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

