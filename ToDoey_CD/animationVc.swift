//
//  animationVc.swift
//  ToDoey_CD
//
//  Created by Harshvirsinh Parmar on 06/01/22.
//

import UIKit
import Lottie
class animationVc: UIViewController {

    @IBOutlet var animationView: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.hidesBarsOnTap = true
//        navigationItem.hidesBackButton = true
        animationView!.contentMode = .scaleAspectFit
        
        // 4. Set animation loop mode
        
      animationView!.loopMode = .playOnce
        
        // 5. Adjust animation speed
        
        animationView!.animationSpeed = 0.5
        
      //  view.addSubview(animationView!)
        
        // 6. Play animation
        self.animationView!.play()
        // Do any additional setup after loading the view.
    }
    
}
