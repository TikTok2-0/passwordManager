//
//  Cryptography.swift
//  Password Manager Python
//
//  Created by Yannik on 14.07.21.
//

import Foundation
import CryptoSwift

func keyGen(user: String, pass: String) -> [UInt8] {
    let userName: [UInt8] = Array("\(user)".utf8)
    let MasterPass:[UInt8] = Array("\(pass)".utf8)
    
    let keyBytes = try PKCS5.PBKDF2(password: userName, salt: MasterPass, iterations: 4096, keyLength: 32, variant: .sha256).calculate()
    
    return keyBytes
}

func encryptPass(newPassword: String, key: [UInt8]) -> [UInt8] {
    let pass: [UInt8] = Array("\(newPassword)".utf8)
    
    let ivInt = Int64.random(in: 0...18446744073709551615)
    let iv: [UInt8] = Array("\(ivInt)".utf8)
    
    let encPass: [UInt8] = try Blowfish(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(pass)
    
    return (encPass)
}

func hashKey(keyBytes: [UInt8]) -> String {
    
    let key = String(bytes: keyBytes, encoding: .utf8)
    
    let hash = key!.sha256()
    let jsonString = "{'key1':'\(hash)'}"

    if let jsonData = jsonString.data(using: .utf8),
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let pathWithFilename = documentDirectory.appendingPathComponent("memory.json")
        
        do {
            try jsonData.write(to: pathWithFilename)
        } catch {
            return ("Not a valid JSON Output")
        }
    }
    
    let filePath = #filePath
    return(filePath)
}
