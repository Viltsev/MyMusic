//
//  Colors.swift
//  MyMusic
//
//  Created by Данила on 27.08.2023.
//

import Foundation
import UIKit
import SwiftUI

extension Color {
    enum Name: String {
        case greenLight
        case purpleDark
        case purpleMid
        case purpleLight
    }
}

extension Color.Name {
    var path: String { "\(rawValue)" }
}

extension Color {
    init(_ name: Color.Name) {
        self.init(name.path)
    }

    static let greenLight = Color(.greenLight)
    static let purpleDark = Color(.purpleDark)
    static let purpleMid = Color(.purpleMid)
    static let purpleLight = Color(.purpleLight)
}

extension UIColor {
    convenience init(named name: Color.Name) {
        self.init(named: name.path)!
    }
}
