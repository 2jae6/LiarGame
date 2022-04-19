//
//  ViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/17.
//

import UIKit
import PinLayout
import FlexLayout
import Then

final class SplashViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brown
    }
 
    override func viewDidAppear(_ animated: Bool) {
        let homeVC = HomeViewController()
        self.present(homeVC, animated: true, completion: nil)
    }
    
}

