//
//  Favorite.swift
//  MovieApp
//
//  Created by shimaa on 7/30/1439 AH.
//  Copyright © 1439 AH MovieAppOrganization. All rights reserved.
//

import UIKit
import CoreData
import  SDWebImage

private let reuseIdentifier = "cell2"

class Favorite: UICollectionViewController {
    var myfavorite = [FilmData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var moviesres : [NSManagedObject] = [NSManagedObject]()
        
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //2
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //3
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteFilm")
        
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
                myfavorite.append(myMovieO)
                self.collectionView?.reloadData()
                
            }
        }catch{
            
            print ("error in core Data")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("Display")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        print("sec")
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print(myfavorite.count)
        return myfavorite.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
       let myimage2 = cell.viewWithTag(2) as! UIImageView
        // Configure the cell
        myimage2.sd_setImage(with: URL(string: myfavorite[indexPath.row].poster_path), placeholderImage:UIImage(named: "placeholder\(indexPath.row).png"))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detail") as! DetailOfFilm
        
        vc.mySelectedFilm=myfavorite[indexPath.row]
        navigationController?.pushViewController(vc,animated: true)
    }

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
