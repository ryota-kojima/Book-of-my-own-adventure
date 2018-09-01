//
//  OriginalTextView.swift
//  Book of my own adventure
//
//  Created by 小嶋暸太 on 2018/08/31.
//  Copyright © 2018年 小嶋暸太. All rights reserved.
//

import Foundation
import UIKit

class ToucheEventTextView: UITextView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let next = next {
            next.touchesBegan(touches , with: event)
        } else {
            super.touchesBegan(touches , with: event)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let next = next {
            next.touchesEnded(touches , with: event)
        } else {
            super.touchesEnded(touches , with: event)
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let next = next {
            next.touchesCancelled(touches, with: event)
        } else {
            super.touchesCancelled(touches, with: event)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let next = next {
            next.touchesMoved(touches, with: event)
        } else {
            super.touchesMoved(touches, with: event)
        }
    }
}
