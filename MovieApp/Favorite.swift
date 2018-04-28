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
    }
    override func viewWillAppear(_ animated: Bool) {
        var moviesres : [NSManagedObject] = [NSManagedObject]()
        
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //2
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //3
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteFilm")
        myfavorite.removeAll()
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

    }

   
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        print("sec")
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
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

    }
