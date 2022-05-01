//
//  LiarGameViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/26.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import ReactorKit
import PinLayout
import FlexLayout

final class LiarGameViewController: UIViewController, View{
  
  init(reactor: LiarGameReactor, subject: LiarGameSubject, mode: LiarGameMode, memberCount: Int){
    self.selectSubject = subject
    self.memberCount = memberCount
    self.mode = mode
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLayoutSubviews() {
    
  }
  override func viewDidLoad() {
    self.view.backgroundColor = .white
    self.setupView()
    
  }
  private var selectSubject: LiarGameSubject // 주제
  private var mode: LiarGameMode // 게임 모드
  private var memberCount: Int
  private var turn: Int = 0
  
  var disposeBag: DisposeBag = DisposeBag()
  private let flexContainer: UIView = UIView()
  
  
  // 가림막 만들기 가림막은 클릭 시 확인창이 뜸
  private let curtainView: UIView = UIView()
  private let curtainLabel: UILabel = UILabel()
  private let curtainButton: UIButton = UIButton()
  
  // 단어 나타나기 화면 만들기
  private let liarView: UIView = UIView()
  private let liarLabel: UILabel = UILabel()
  private let liarButton: UIButton = UIButton()
  
  // 게임 시작!!!
  private let endView: UIView = UIView()
  private let endLabel: UILabel = UILabel()
  private let endButton: UIButton = UIButton()

  
  
}
// MARK: - Setup
extension LiarGameViewController{
  
  private func setupView(){
    self.view.addSubview(self.liarView)
    self.liarView.addSubview(self.liarLabel)
    self.liarView.addSubview(self.liarButton)
    
    self.liarView.pin.width(300).height(300).center()
    self.liarLabel.pin.width(200).height(40).center()
    self.liarButton.pin.all()
    
    liarLabel.do{
      $0.backgroundColor = .red
      $0.text = "라이어 게임 테스트"
      $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    liarButton.do{
      $0.backgroundColor = .green
    }
    liarView.bringSubviewToFront(liarLabel)
    
    self.view.addSubview(self.curtainView)
    self.curtainView.addSubview(self.curtainLabel)
    self.curtainView.addSubview(self.curtainButton)
    
    self.curtainView.pin.width(300).height(300).center()
    self.curtainLabel.pin.width(200).height(40).center()
    self.curtainButton.pin.all()
    
    curtainLabel.do{
      $0.backgroundColor = .blue
      $0.text = "터치해서 가림막을 제거해주세요"
      $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    curtainButton.do{
      $0.backgroundColor = .red
    }
    curtainView.bringSubviewToFront(curtainLabel)
    
    self.view.addSubview(self.endView)
    self.endView.addSubview(self.endLabel)
    self.endView.addSubview(self.endButton)
    
    self.endView.pin.width(300).height(300).center()
    self.endLabel.pin.width(200).height(40).center()
    self.endButton.pin.all()
    
    endView.do{
      $0.isHidden = true
    }
    endLabel.do{
      $0.backgroundColor = .blue
      $0.text = "게임을 다시 시작하려면 아래 버튼을 눌러주세요."
      $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    endButton.do{
      $0.backgroundColor = .red
    }
    endView.bringSubviewToFront(endLabel)
  
    
  }
  
  private func changeView(currentView:UIView, newView:UIView) {
    
    if (currentView == newView) {
      return
    }
    
    let oldView:UIView = currentView
    oldView.alpha = 0.0
    oldView.isHidden = true
    
    newView.isHidden = false
    newView.alpha = 1.0
    
    
    UIView.animate(withDuration: Double(0.5),
                   animations: {newView.alpha=1.0; oldView.alpha=0.0 })
  }
  
}
// MARK: - Bind
extension LiarGameViewController{
  func bind(reactor: LiarGameReactor){
    reactor.action.onNext(.initWord(self.memberCount, self.selectSubject, self.mode))
    
    reactor.state.map { $0.liarSetText }
    .observe(on: MainScheduler.instance)
    .distinctUntilChanged()
    .bind(to: self.liarLabel.rx.text)
    .disposed(by: disposeBag)
    
    // 가림막
    curtainButton.rx.tap
      .observe(on: MainScheduler.instance)
      .subscribe(onNext:{ [weak self] _ in
        guard let self = self else { return }
        
        let alert = UIAlertController(title: "보기", message: "본인의 차례가 맞다면 보기를 눌러주세요", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "보기", style: .default) { (action) in
          reactor.action.onNext(.tappedCurtain)
          self.changeView(currentView: self.curtainView, newView: self.liarView)
          
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel){_ in
          
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: false, completion: nil)
        
        
        
        
      }).disposed(by: disposeBag)
    
    // 라이어
    liarButton.rx.tap
      .observe(on: MainScheduler.instance)
      .subscribe(onNext:{[weak self] _ in
        guard let self = self else { return }
        
        if self.turn == self.memberCount - 1{
          print("게임이 종료되었습니다.")
          self.endView.isHidden = false
          self.curtainView.isHidden = true
          self.liarView.isHidden = true
          return
        }else{
          self.turn += 1
        }
        
        let alert = UIAlertController(title: "확인하셨나요?", message: "확인버튼을 누르고 다음 차례로 넘겨주세요!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
          
          
          
          self.changeView(currentView: self.liarView, newView: self.curtainView)
          
          reactor.action.onNext(.tappedLiar)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel){_ in
          
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: false, completion: nil)
        
        
      }).disposed(by: disposeBag)
    
    
  }
  
}
