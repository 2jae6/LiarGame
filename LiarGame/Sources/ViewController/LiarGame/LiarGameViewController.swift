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

final class LiarGameViewController: UIViewController{
    
    init(subject: LiarGameSubject){
        self.selectSubject = subject
        super.init(nibName: nil, bundle: nil)
        flexContainer.flex.define{ flex in
            flex.addItem(self.curtainView)
            
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        self.flexContainer.pin.all()
        self.flexContainer.flex.layout()
    }
    override func viewDidLoad() {
        self.view.backgroundColor = .yellow
        self.setupView()
    }
    
    private let flexContainer: UIView = UIView()

    private var selectSubject: LiarGameSubject
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
extension LiarGameViewController{
    
    private func setupView(){
//        self.view.addSubview(flexContainer)
        
        curtainView.do{
            self.view.addSubview($0)
            $0.backgroundColor = .yellow
        }
        
        curtainLabel.do{
            self.curtainView.addSubview($0)
            $0.backgroundColor = .green
            $0.text = "터치해서 가림막을 제거해주세요"
        }
        curtainButton.do{
            self.curtainView.addSubview($0)
        }
    }
}
