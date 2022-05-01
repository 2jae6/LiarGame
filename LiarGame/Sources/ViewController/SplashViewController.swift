//
//  ViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/17.
//

import FlexLayout
import Lottie
import PinLayout
import Then
import UIKit

final class SplashViewController: UIViewController {
  init() {
    super.init(nibName: nil, bundle: nil)
    flexContainer.flex.direction(.column).justifyContent(.center).define { flex in
      flex.addItem(titleImageView).width(100%).height(300)
      flex.addItem(animationView).width(100%).height(300)
    }
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLayoutSubviews() {
    flexContainer.pin.all()
    flexContainer.flex.layout()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(hexString: "EDE6DB")
    view.addSubview(flexContainer)

  }

  override func viewDidAppear(_: Bool) {

    titleImageView.image = UIImage(named: "launch_title")
    animationView.play { _ in
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
