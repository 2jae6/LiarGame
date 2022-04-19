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
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(self.flexLayoutContainer)
        self.flexLayoutContainer.flex.define{ flex in
            flex.backgroundColor(.systemPink)
            flex.addItem(self.liarGameStartButton)
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
        self.view.backgroundColor = .green
    }
    
    let flexLayoutContainer: UIView = UIView()
    
    
    let liarGameStartButton = UIButton()
}
extension HomeViewController{
    
    private func setupView(){
        liarGameStartButton.do{
            self.view.addSubview($0)
        }
        
        
        self.setupLayout()
    }
    
    private func setupLayout(){
        
        
    }
    
    
}
