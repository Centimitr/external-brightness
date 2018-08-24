//
//  MenuSlider.swift
//  External Brightness
//
//  Created by Xiao Shi on 14/4/18.
//  Copyright © 2018 devbycm. All rights reserved.
//

import Foundation
import AppKit

class CMMenuSlider: NSView {
    
    @IBOutlet weak var content: NSView!
    @IBOutlet weak var slider: NSSlider!
    var onChange: ((_ value: Int) -> Void)?
    
    init(width: Int, min: Int, max: Int, current: Int) {
        super.init(frame: NSMakeRect(0, 0, CGFloat(width), 28))
        loadBundle()
        slider.minValue = Double(min)
        slider.maxValue = Double(max)
        slider.doubleValue = Double(current)
        slider.target = self
        slider.action = #selector(valueChanged(_:))
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        loadBundle()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        loadBundle()
    }
    
    private func loadBundle() {
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "MenuSlider"), owner: self, topLevelObjects: nil)
        content.frame = self.bounds
//        content.autoresizingMask = [.height, .width]
        self.addSubview(content)
    }
    
    @objc private func valueChanged(_ sender: Any?) {
        if let fn = onChange {
            fn(Int(slider.intValue))
        }
    }
    
}
