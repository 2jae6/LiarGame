//
//  ViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/17.
//

import FlexLayout
import Lottie
import PinLayout
import Pure
import Then
import UIKit

final class SplashViewController: UIViewController, FactoryModule {
  struct Dependency {
    let homeViewControllerFactory: HomeViewController.Factory
  }

  // MARK: Properties

  private let dependency: Dependency
  private let flexContainer = UIView()
  private let animationView = AnimationView(name: "launch")
  private let titleImageView = UIImageView()

  // MARK: Initialize

  init(dependency: Dependency, payload _: Void) {
    self.dependency = dependency

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

  // MARK: Life Cycle

  override func viewDidLayoutSubviews() {
    flexContainer.pin.all()
    flexContainer.flex.layout()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .background
    view.addSubview(flexContainer)

  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    titleImageView.image = UIImage(named: "launch_title")
    animationView.play { [weak self] _ in
      guard let self = self else { return }
      let factory = self.dependency.homeViewControllerFactory
      let reactor = factory.dependency.reactorFactory.create()

      let homeVC = UINavigationController(rootViewController: factory.create(payload: .init(reactor: reactor)))
      homeVC.modalPresentationStyle = .fullScreen
      self.present(homeVC, animated: false, completion: nil)
    }
    animationView.loopMode = .playOnce
  }

}
