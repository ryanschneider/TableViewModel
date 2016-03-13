//
//  RemovableSectionHeader.swift
//  TableViewModel
//
//  Created by Tunca Bergmen on 11/03/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class RemovableSectionHeader: UIView {
    var onRemoveTapClosure: (() -> ())?

    func onRemoveTap(closure: ()->()) {
        self.onRemoveTapClosure = closure
    }

    @IBAction func removeAction() {
        onRemoveTapClosure?()
    }
}