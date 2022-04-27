//
//  LiarGameSubjectViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/20.
//

import UIKit
import PinLayout
import FlexLayout
import Then
import ReactorKit

final class LiarGameSubjectViewController: UIViewController, View{
  init(reactor: LiarGameSubjectReactor, mode: LiarGameMode, memberCount: Int){
    self.mode = mode
    self.memberCount = memberCount
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
    self.view.addSubview(flexLayoutContainer)
    
    self.flexLayoutContainer.flex.direction(.row).justifyContent(.center).alignItems(.stretch).wrap(.wrap).define{ flex in
      flex.addItem(self.animalButton).width(100).height(25).marginTop(100).margin(10)
      flex.addItem(self.exerciseButton).width(100).height(25).marginTop(100).margin(10)
      flex.addItem(self.foodButton).width(100).height(25).marginTop(100).margin(10)
      flex.addItem(self.electronicEquipmentButton).width(100).height(25).marginTop(10).margin(10)
      flex.addItem(self.jobButton).width(100).height(25).marginTop(10).margin(10)
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError() }
  
  override func viewDidLayoutSubviews() {
    self.flexLayoutContainer.pin.all()
    self.flexLayoutContainer.flex.layout()
  }
  
  override func viewDidLoad() {
    self.view.backgroundColor = .green
    self.setupView()
  }
  var mode: LiarGameMode
  var memberCount: Int = 3
  private let flexLayoutContainer: UIView = UIView()
  
  
  var disposeBag: DisposeBag = DisposeBag()
  
  private let animalButton: UIButton = UIButton()
  private let exerciseButton: UIButton = UIButton()
  private let foodButton: UIButton = UIButton()
  private let electronicEquipmentButton: UIButton = UIButton()
  private let jobButton: UIButton = UIButton()
  
  
}
extension LiarGameSubjectViewController{
  
  func setupView(){
    animalButton.do{
      $0.backgroundColor = .yellow
      $0.setTitle("동물", for: .normal)
      $0.setTitleColor(.black, for: .normal)
    }
    exerciseButton.do{
      $0.backgroundColor = .yellow
      $0.setTitle("운동", for: .normal)
      $0.setTitleColor(.black, for: .normal)
    }
    foodButton.do{
      $0.backgroundColor = .yellow
      $0.setTitle("음식", for: .normal)
      $0.setTitleColor(.black, for: .normal)
    }
    electronicEquipmentButton.do{
      $0.backgroundColor = .yellow
      $0.setTitle("전자기기", for: .normal)
      $0.setTitleColor(.black, for: .normal)
    }
    jobButton.do{
      $0.backgroundColor = .yellow
      $0.setTitle("직업", for: .normal)
      $0.setTitleColor(.black, for: .normal)
    }
    
  }
  
  
}
extension LiarGameSubjectViewController{
  
  
  func bind(reactor: LiarGameSubjectReactor) {
    animalButton.rx.tap
      .subscribe(onNext:{
        reactor.action.onNext(.selectSubject(.animal))
      }).disposed(by: disposeBag)
    
    exerciseButton.rx.tap
      .subscribe(onNext:{
        reactor.action.onNext(.selectSubject(.exercise))
      }).disposed(by: disposeBag)
    
    
    foodButton.rx.tap
      .subscribe(onNext:{
        reactor.action.onNext(.selectSubject(.food))
      }).disposed(by: disposeBag)
    
    electronicEquipmentButton.rx.tap
      .subscribe(onNext:{
        reactor.action.onNext(.selectSubject(.electronicEquipment))
      }).disposed(by: disposeBag)
    
    jobButton.rx.tap.asDriver()
      .drive(onNext:{
        reactor.action.onNext(.selectSubject(.job))
      }).disposed(by: disposeBag)
    
    reactor.state.map{ $0.selectedSubject }
    .compactMap{ $0 }
    .distinctUntilChanged()
    .withUnretained(self)
    .subscribe(onNext:{ `self`, subject in
      let liarGameVC = LiarGameViewController(reactor: LiarGameReactor(), subject: subject, mode: self.mode, memberCount: self.memberCount)
      liarGameVC.modalPresentationStyle = .fullScreen
      self.present(liarGameVC, animated: true, completion: nil)
      
    }).disposed(by: disposeBag)
    
  }
  
  
}
