//
//  RandomMusicQuizViewController.swift
//  LiarGame
//
//  Created by JK on 2022/04/21.
//

import UIKit
import ReactorKit

final class RandomMusicQuizViewController: UIViewController, View {
  init(reactor: RandomMusicQuizReactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
    setupViews()
  }
  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError() }
  
  var disposeBag = DisposeBag()
  func bind(reactor: RandomMusicQuizReactor) {
    
  }
  
  func setupViews() { }
}
