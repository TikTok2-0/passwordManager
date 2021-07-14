//
//  PythonCompiler.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 13.07.21.
//

import Foundation
import PythonKit

func testPy() -> PythonObject {
    let sys = Python.import("sys")
    sys.path.append("/Users/henrykrieger/Library/Mobile Documents/com~apple~CloudDocs/Documents/Warrior/Programmieren/Xcode/Password Manager Python/Password Manager Python/")
    let example = Python.import("example")
    let response = example.swiftOutput()
    print(response)
    return response
}
