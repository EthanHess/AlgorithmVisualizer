//
//  LogDebugging.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 2/17/22.
//

import UIKit

//MARK: Open class = accessible and subclassable outside of the defining module, only really necessary when dealing with multiple modules (i.e. unified code structure, part of a bigger one)

open class LogDebugging {
    
    open class func log(_ message: String, filePath: String = #file, function: String = #function,  line: Int32 = #line) {
        
        logToConsole("", message: message, filePath: filePath, function: function, line: line)
    }
    
    fileprivate class func logToConsole(_ prefix: String, message: String, filePath: String, function: String,  line: Int32) {
        
        let mainThread = Thread.current.isMainThread
        let threadName = mainThread ? "[~MAIN THREAD~]" : "[~BACKGROUND THREAD~]"
        let file: String = (filePath as NSString).lastPathComponent
        
        print("\(threadName)\(prefix)\(file) \(function)[\(line)]: \(message)")
    }
}
