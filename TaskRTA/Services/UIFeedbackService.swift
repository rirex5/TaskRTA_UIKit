//
//  UIFeedbackService.swift
//  TaskRTA
//
//  Created by Atsushi Otsubo on 2020/01/03.
//  Copyright © 2020 Rirex. All rights reserved.
//

import UIKit

class UIFeedbackService: NSObject {
    
    static let shared = UIFeedbackService()
    private override init() {}
    
    func notice(type: UINotificationFeedbackGenerator.FeedbackType) {
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    func selection() {
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
}
