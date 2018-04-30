//
//  SplashScreenViewController.swift
//  MovieApp
//
//  Created by Yomna Gamal Hussein on 4/30/18.
//  Copyright © 2018 MovieAppOrganization. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        UIView.animate(withDuration: 3,delay: 0.0,options: (.curveLinear), animations: ({
            
            self.image.transform = CGAffineTransform(rotationAngle: 360)
            
        }))
        
        perform(#selector(SplashScreenViewController.showViewController as (SplashScreenViewController) -> () -> ()),with: nil,afterDelay:3)
    }
    
    func showViewController(){
        
        performSegue(withIdentifier: "showSplashScreen",sender: self);
        
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
