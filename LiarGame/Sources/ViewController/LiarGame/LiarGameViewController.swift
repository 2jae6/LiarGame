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
        
        
        self.view.addSubview(self.liarView)
        self.liarView.addSubview(self.liarLabel)
        self.liarView.addSubview(self.liarButton)
        
        self.liarView.pin.width(300).height(300).center()
        self.liarLabel.pin.width(200).height(40).center()
        self.liarButton.pin.all()
        
        liarLabel.do{
            $0.backgroundColor = .red
            $0.text = "임시 텍스트"
            $0.font = .systemFont(ofSize: 14, weight: .semibold)
        }
        
        liarButton.do{
            $0.backgroundColor = .green
        }
        
    }
    
    func changeView(currentView:UIView, newView:UIView) {
        
        if (currentView == newView) {
            return
        }
        
        let oldView:UIView = currentView
        oldView.alpha = 0.0
        oldView.isHidden = true
        
        newView.isHidden = false
        newView.alpha = 1.0
//        self.view.addSubview(newView)
        
//        self.view.sendSubviewToBack(newView)
        
        
        UIView.animate(withDuration: Double(0.5),
                       animations: {newView.alpha=1.0; oldView.alpha=0.0 },
                       completion: { finished in
            if(finished) {
//                oldView.isHidden = true
            }
        }
        )
    }
    
}
// MARK: - Bind
extension LiarGameViewController{
    func bind(reactor: LiarGameReactor){
        curtainButton.rx.tap
            .subscribe(onNext:{ [weak self] _ in
              guard let self = self else { return }
              self.changeView(currentView: self.curtainView, newView: self.liarView)
            }).disposed(by: disposeBag)
        
        liarButton.rx.tap
            .subscribe(onNext:{[weak self] _ in
              guard let self = self else { return }
              self.changeView(currentView: self.liarView, newView: self.curtainView)
            }).disposed(by: disposeBag)
        
 
    }

}
