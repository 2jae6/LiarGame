//
//  HomeViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/19.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift
import RxCocoa


final class HomeViewController: UIViewController{
    
    init(reactor: HomeReactor){
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(self.flexLayoutContainer)
        self.flexLayoutContainer.flex.direction(.column).alignItems(.center).justifyContent(.center).padding(10).define{ flex in
            flex.backgroundColor(.systemPink)
            flex.addItem(self.liarGameStartButton).width(200).height(50).backgroundColor(.yellow)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.flexLayoutContainer.pin.all()
        self.flexLayoutContainer.flex.layout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupView()
        
        self.bindView(reactor: self.reactor)
    }
    let reactor: HomeReactor
    
    let flexLayoutContainer: UIView = UIView()
    
    let disposeBag = DisposeBag()
    
    let liarGameStartButton = UIButton()
    
}

// MARK: - Setup View
extension HomeViewController{
    private func setupView(){
        liarGameStartButton.do{
            $0.setTitle("라이어 게임", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            self.view.addSubview($0)
        }
    }
}

// MARK: - Binding
extension HomeViewController{
    private func bindView(reactor: HomeReactor){
        self.liarGameStartButton.rx.tap.asDriver()
            .drive(onNext: {
                reactor.action.onNext(.updateMode("LIAR"))
            }).disposed(by: disposeBag)
        
        
        reactor.state.map { $0.mode }
        .subscribe(onNext: {
            print($0)
            if $0 == "LIAR"{
                let liarVC = LiarGameModeViewController()
                liarVC.modalPresentationStyle = .fullScreen
                self.present(liarVC, animated: true, completion: nil)
            }
        })
        .disposed(by: disposeBag)
    }
}
