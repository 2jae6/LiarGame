//
//  RandomMusicQuizViewController.swift
//  LiarGame
//
//  Created by JK on 2022/04/21.
//

import UIKit
import ReactorKit
import RxSwift
import Then

/*
 TODO:
 
 랜덤 음악 퀴즈 게임
 
 - 3초 재생버튼, 5초 재생버튼, 10초 재생버튼을 추가.
 - 정답을 보여줄 버튼 추가
 -
 
 */
final class RandomMusicQuizViewController: UIViewController, View {
  
  private let content = RandomQuizView()
  
  init(reactor: RandomMusicQuizReactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
    setupViews()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError() }
  
  override func loadView() {
    super.loadView()
    self.view = content
  }
  
  var disposeBag = DisposeBag()
  func bind(reactor: RandomMusicQuizReactor) {
      
  }
  
  func setupViews() {
      
  }
}

