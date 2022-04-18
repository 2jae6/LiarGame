//
//  ViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/17.
//

import UIKit
import PinLayout
import FlexLayout
import Then

class ViewController: UIViewController {

    let rootFlexContainer: UIView = UIView()
    
    let fView = UIView().then{
        $0.backgroundColor = .red
    }
    let sView = UIView().then{
        $0.backgroundColor = .green
    }
    let tView = UIView().then{
        $0.backgroundColor = .blue
    }
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(self.rootFlexContainer)
        self.rootFlexContainer.flex.paddingTop(12).define { (flex) in
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.ㄴ
        self.view.backgroundColor = .brown
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.all() // 1)
        self.rootFlexContainer.flex.layout() // 2)
        
    }

    

}

