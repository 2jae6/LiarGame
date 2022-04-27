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

final class SplashViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .brown
  }

  override func viewDidAppear(_: Bool) {
    let homeVC = HomeViewController(reactor: HomeReactor())
    homeVC.modalPresentationStyle = .fullScreen
    present(homeVC, animated: true, completion: nil)
  }
}
