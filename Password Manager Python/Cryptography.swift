//
//  Cryptography.swift
//  Password Manager Python
//
//  Created by Yannik on 14.07.21.
//

import Foundation
import CryptoSwift

func keyGen() -> (String, String) {
    let rndInt1 = Int64.random(in: 0..<9223372036854775807)
    let rndInt2 = Int64.random(in: 0..<9223372036854775807)
    
    let userName: Array<UInt8> = Array("\(rndInt1)".utf8)
    let MasterPass: Array<UInt8> = Array("\(rndInt2)".utf8)
    var keyBytes: Array<UInt8> = Array("187".utf8)
    
    do {
        keyBytes = try PKCS5.PBKDF2(password: userName, salt: MasterPass, iterations: 2048, keyLength: 24, variant: .sha256).calculate()
    } catch {
        print(error)
    }
    print(keyBytes)
    //let key = String(bytes: keyBytes, encoding: .utf8)
    let stringArray = keyBytes.map { String($0) }
    let key = stringArray.joined(separator: "-")
    print(key)
    let hashedKey = hashKey(keyBytes: keyBytes)
    return (key, hashedKey)
}

func encryptPass(website: String, user: String, newPassword: String, keyID: String, usedKey: String) -> (String, String) {
    let pass: [UInt8] = Array("\(newPassword)".utf8)
    let key: [UInt8] = Array("\(usedKey)".utf8)
    
    let iv: [UInt8] = Array("42069".utf8)
    var encPass: Array<UInt8> = Array("187".utf8)
    
    //INSERT JSON READER HERE
    
    if 1==1 { //CONDITION -> DERIVATIVE OF READER
        do {
            encPass = try Blowfish(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(pass)
        } catch {
            print(error)
        }
        
        let jsonString = "{'website':'\(website)', 'username':'\(user)', 'keyID':'\(keyID)', 'password':'\(encPass)'}"
        
        if let jsonData = jsonString.data(using: .utf8),
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let memoryPath = documentDirectory.appendingPathComponent("keyHash.json")
                
                do {
                    try jsonData.write(to: memoryPath)
                } catch {
                    print ("Not a valid JSON Output")
                }
        }
    }
    let ivMap = iv.map { String($0) }
    let ivString = ivMap.joined()

    return ("Success!", ivString)
}

func decryptPass(website: String, keyID: String, usedKey: String, password: String, iv: String) -> String {
    let pass: [UInt8] = Array("(password)".utf8)
    let key: [UInt8] = Array("(usedKey)".utf8)

    let iv: [UInt8] = Array("(iv)".utf8)
    var decPass: Array<UInt8> = Array("187".utf8)

    do {
        decPass = try Blowfish(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(pass)
    } catch {
        print(error)
    }

    let stringArray = decPass.map { String($0) }
    let decString = stringArray.joined()

    return decString
}

func hashKey(keyBytes: [UInt8]) -> String {
    
    
    let stringArray = keyBytes.map { String($0) }
    let key = stringArray.joined()
    
    let hash = key.sha256()
    
    
    /*let jsonString = "{'key1':'\(hash)'}"

    if let jsonData = jsonString.data(using: .utf8),
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let memoryPath = documentDirectory.appendingPathComponent("keyHash.json")
            
            do {
                try jsonData.write(to: memoryPath)
            } catch {
                return ("Not a valid JSON Output")
            }
    }*/
    return(hash)
}
