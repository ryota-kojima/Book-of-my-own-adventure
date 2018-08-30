//
//  bubbletransition.swift
//  Book of my own adventure
//
//  Created by 小嶋暸太 on 2018/08/29.
//  Copyright © 2018年 小嶋暸太. All rights reserved.
//

import Foundation
import BubbleTransition

extension ViewController : UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = levelButton.center    //outletしたボタンの名前を使用
        //transition.bubbleColor = levelButton.backgroundColor!   //円マークの色
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = levelButton.center //outletしたボタンの名前を使用
        //transition.bubbleColor = levelButton.backgroundColor!     //円マークの色
        return transition
    }
}

extension SeondViewController : UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = levelButton.center    //outletしたボタンの名前を使用
        //transition.bubbleColor = levelButton.backgroundColor!   //円マークの色
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = levelButton.center //outletしたボタンの名前を使用
        //transition.bubbleColor = levelButton.backgroundColor!     //円マークの色
        return transition
    }
}
