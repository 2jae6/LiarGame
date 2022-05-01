//
//  ViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/17.
//

import FlexLayout
import PinLayout
import Then
import UIKit
import Lottie

final class SplashViewController: UIViewController {
  init(){
    super.init(nibName: nil, bundle: nil)
    self.flexContainer.flex.direction(.column).justifyContent(.center).define{ flex in
      flex.addItem(titleImageView).width(100%).height(300)
      flex.addItem(animationView).width(100%).height(300)
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLayoutSubviews() {
      self.flexContainer.pin.all()
      self.flexContainer.flex.layout()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(hexString: "EDE6DB")
    self.view.addSubview(flexContainer)
    
   
    
    

  }
  
  

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.titleImageView.image = UIImage(named: "launch_title")
    animationView.play(){ _ in
      let homeVC = UINavigationController(rootViewController: HomeViewController(reactor: HomeReactor()))
      homeVC.modalPresentationStyle = .fullScreen
      self.present(homeVC, animated: false, completion: nil)
    }
    animationView.loopMode = .playOnce
  }
  
  
  let flexContainer = UIView()
  let animationView = AnimationView(name: "launch")
  let titleImageView = UIImageView()

}
