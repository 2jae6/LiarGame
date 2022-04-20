//
//  LiarGameModeViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/19.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift
import RxCocoa
import ReactorKit

final class LiarGameModeViewController: UIViewController, View{
    
    init(reactor: LiarGameModeReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        self.view.addSubview(flexLayoutContainer)
        self.flexLayoutContainer.flex.direction(.column).justifyContent(.center).alignItems(.center).padding(10).define{ flex in
            flex.backgroundColor(.brown)
            flex.addItem(defaultLiarGame).width(200).height(50).backgroundColor(.yellow)
            flex.addItem(stupidLiarGame).width(200).height(50).backgroundColor(.yellow).marginTop(10)
            flex.addItem(memberCountLabel).width(200).height(50).backgroundColor(.white).marginTop(30)
            flex.addItem(memberCountStepper).backgroundColor(.red).marginTop(10)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLayoutSubviews() {
        self.flexLayoutContainer.pin.all()
        self.flexLayoutContainer.flex.layout()
    }
    override func viewDidLoad() {
        self.view.backgroundColor = .green
        self.setupView()
        self.bindingStepper()
    }
    
    
    let flexLayoutContainer: UIView = UIView()
    var disposeBag: DisposeBag = DisposeBag()
    
    let defaultLiarGame: UIButton = UIButton()
    let stupidLiarGame: UIButton = UIButton()
    let memberCountLabel: UILabel = UILabel()
    let memberCountStepper: UIStepper = UIStepper().then{
        $0.wraps = false
        $0.autorepeat = true
        $0.minimumValue = 3
        $0.maximumValue = 20
    }
    
    

}

// MARK: - Setup View
extension LiarGameModeViewController{
    private func setupView(){
        defaultLiarGame.do{
            $0.setTitle("일반 모드", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            self.view.addSubview($0)
        }
        stupidLiarGame.do{
            $0.setTitle("바보 모드", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            self.view.addSubview($0)
        }
        memberCountLabel.do{
            $0.textAlignment = .center
            self.view.addSubview($0)
        }
        memberCountStepper.do{
            self.view.addSubview($0)
        }
    }
}


// MARK: - Bind
extension LiarGameModeViewController{
    func bind(reactor: LiarGameModeReactor) {
        
        defaultLiarGame.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map{ Reactor.Action.selectMode("DEFAULT")}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        stupidLiarGame.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map{ Reactor.Action.selectMode("STUPID")}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.mode }
        .withUnretained(self)
        .subscribe(onNext: { _ in
            let liarGameSubjectVC = LiarGameSubjectViewController()
            liarGameSubjectVC.modalPresentationStyle = .fullScreen
            self.present(liarGameSubjectVC, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        
    }
    

    func bindingStepper(){
        memberCountStepper.rx.value
            .map { String(Int($0)) }
            .bind(to: memberCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
