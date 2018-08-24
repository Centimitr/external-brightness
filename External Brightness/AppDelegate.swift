//
//  AppDelegate.swift
//  External Brightness
//
//  Created by Xiao Shi on 13/4/18.
//  Copyright © 2018 devbycm. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let agent = ddcctl.shared

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            button.action = #selector(AppDelegate.openPreferences(_:))
        }
        refreshMenu(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    

    
    @objc func refreshMenu(_ sender: Any?) {
        let menu: NSMenu = statusItem.menu ?? NSMenu()
        menu.removeAllItems()
        menu.autoenablesItems = false
        
        getDisplayItems().forEach { item in
            menu.addItem(item)
        }
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Open Externals Preferences...", action: #selector(AppDelegate.openPreferences(_:)), keyEquivalent: ""))
        statusItem.menu = menu
    }
    
    func getDisplayItems() -> [NSMenuItem] {
        var items: [NSMenuItem] = []
        let title = NSMenuItem(title: "Externals: \(agent.displays.count) Connected", action: nil, keyEquivalent: "")
        title.isEnabled = false
        items.append(title)
        items.append(NSMenuItem.separator())
        agent.displays.forEach { display in
            let name = NSMenuItem(title: display.name, action: nil, keyEquivalent: "")
            name.isEnabled = false
            let brightness = NSMenuItem()
            let slider = CMMenuSlider(width: 220, min: 0, max: 100, current: display.brightness)
            slider.onChange = { value in display.brightness = value }
            brightness.view = slider
            items.append(name)
            items.append(brightness)
        }
        return items
    }
    
    @objc func openPreferences(_ sender: Any?) {
        print("Open Preferences")
    }
}

