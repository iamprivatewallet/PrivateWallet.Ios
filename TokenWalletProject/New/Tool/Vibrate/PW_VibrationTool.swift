//
//  PW_VibrationTool.swift
//  TokenWalletProject
//
//  Created by mnz on 2022/8/12.
//  Copyright © 2022 . All rights reserved.
//

import UIKit
import AudioToolbox

public class PW_VibrationTool: NSObject {
    @objc public class func error() {
        Vibration.error.vibrate()
    }
    @objc public class func success() {
        Vibration.success.vibrate()
    }
    @objc public class func warning() {
        Vibration.warning.vibrate()
    }
    @objc public class func light() {
        Vibration.light.vibrate()
    }
    @objc public class func medium() {
        Vibration.medium.vibrate()
    }
    @objc public class func heavy() {
        Vibration.heavy.vibrate()
    }
    @objc public class func rigid() {
        if #available(iOS 13.0, *) {
            Vibration.rigid.vibrate()
        } else {
            // Fallback on earlier versions
        }
    }
    @objc public class func soft() {
        if #available(iOS 13.0, *) {
            Vibration.soft.vibrate()
        } else {
            // Fallback on earlier versions
        }
    }
    @objc public class func selection() {
        Vibration.selection.vibrate()
    }
    @objc public class func oldSchool() {
        Vibration.oldSchool.vibrate()
    }
    @objc public class func v1519() {
        Vibration.v1519.vibrate()
    }
    @objc public class func v1520() {
        Vibration.v1520.vibrate()
    }
    @objc public class func v1521() {
        Vibration.v1521.vibrate()
    }
}

enum Vibration: Int, CaseIterable {
    static var allCases: [Vibration] {
        if #available(iOS 13.0, *) {
            return [.error, .success, .warning, .light, .medium, .heavy, .soft, .rigid, .selection, .oldSchool, .v1519, .v1520, .v1521]
        } else {
            return [.error, .success, .warning, .light, .medium, .heavy, .selection, .oldSchool, .v1519, .v1520, .v1521]
        }
    }

    case error = 0
    case success
    case warning
    case light
    case medium
    case heavy
    @available(iOS 13.0, *)
    case soft
    @available(iOS 13.0, *)
    case rigid
    case selection
    case oldSchool
    case v1519 // weak
    case v1520 // strong
    case v1521 // 3 weak
    public func vibrate() {
        switch self {
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .soft:
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
        case .rigid:
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .oldSchool:
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        case .v1519:
            AudioServicesPlaySystemSound(1519)
        case .v1520:
            AudioServicesPlaySystemSound(1520)
        case .v1521:
            AudioServicesPlaySystemSound(1521)
        }
    }
}
