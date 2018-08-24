//
//  ddcctl.swift
//  External Brightness
//
//  Created by Xiao Shi on 14/4/18.
//  Copyright © 2018 devbycm. All rights reserved.
//

import Foundation
import AppKit


func extract(_ src: String, _ tag: String) -> String? {
    if !src.contains(tag) {
        return nil
    }
    //        var s = String(src.filter { !" \n\t\r".contains($0) })
    var s = src.components(separatedBy: "<\(tag)>").last!
    s = s.components(separatedBy: "</\(tag)>").first!
    return s
}

class Display {
    var no: Int
    var serial: String
    var name: String
    private var agent = ddcctl.shared
    
    init(no: Int, serial: String, name: String) {
        self.no = no
        self.serial = serial
        self.name = name
    }
    
    var brightness: Int {
        get {
            let value = agent.runByDisplay(no, option: "b", value: "-1", tag: "Value")
            return Int(value)!
        }
        set {
            _ = agent.runByDisplay(no, option: "b", value: String(newValue))
        }
    }
}

class ddcctl {
    static let shared = ddcctl()
    
    let url = Bundle.main.url(forResource: "ddcctl", withExtension: "")

    func run(_ params: [String]) -> String {
        do {
            let task = Process()
            task.executableURL = url
            task.arguments = params
            let pipe = Pipe()
            task.standardOutput = pipe
            try task.run()
            task.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            return output! as String
        } catch let error as NSError {
            print("ERROR!", error)
        }
        return ""
    }
    
    func runByDisplay(_ displayNo: Int, option: String, value: String) -> String {
        return run(["-d", String(displayNo), "-" + option, value])
    }
    
    func runByDisplay(_ displayNo: Int, option: String, value: String, tag: String) -> String {
        let res = runByDisplay(displayNo, option: option, value: value)
        let value = extract(res, tag)
        return value!
    }
   
    private func getDisplays() -> [Display] {
        var displays: [Display] = []
        var num = 0
        while true {
            let no = num + 1
            let res = run(["-d", String(no)])
            num += 1
            if let found = extract(res, "Found") {
                displays.append(Display(no: Int(extract(found, "DisplayNo")!)!, serial: extract(found, "EDIDSerial")!, name: extract(found, "EDIDName")!))
            } else {
                break
            }
        }

        return displays
    }
    
    var _displays: [Display] = []
    var displays: [Display] {
        get {
            if _displays.count == 0 {
                _displays = getDisplays()
            }
            return _displays
        }
    }
    
}
