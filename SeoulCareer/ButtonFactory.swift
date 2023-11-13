//
//  ButtonFactory.swift
//  SeoulCareer
//
//  Created by 김건호 on 11/14/23.
//

import UIKit

class ButtonFactory {
    static func createButton(title: String, target: Any?, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}
