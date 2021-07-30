//
//  Cryptography.swift
//  Password Manager Python
//
//  Created by Yannik on 14.07.21.
//

import Foundation
import CryptoSwift
import CoreData

func keyGen() -> (String, String) {
    let rndInt1 = Int64.random(in: 0..<9223372036854775807)
    let rndInt2 = Int64.random(in: 0..<9223372036854775807)
    
    let userName: Array<UInt8> = Array("\(rndInt1)".utf8)
    let MasterPass: Array<UInt8> = Array("\(rndInt2)".utf8)
    var keyBytes: Array<UInt8> = Array("187".utf8)
    
    do {
        keyBytes = try PKCS5.PBKDF2(password: userName, salt: MasterPass, iterations: 4096, keyLength: 32, variant: .sha256).calculate()
    } catch {
        print(error)
    }
    print(keyBytes)
    //let key = String(bytes: keyBytes, encoding: .utf8)
    let stringArray = keyBytes.map { String($0) }
    let key = stringArray.joined()
    print(key)
    let hashedKey = hashKey(key: key)
    return (key, hashedKey)
}

func encryptPass(newPassword: String, keyID: String, usedKey: String) -> (String, [UInt8]) {
    let pass: [UInt8] = Array("\(newPassword)".utf8)
    let key: [UInt8] = Array("\(usedKey)".utf8)
    
    let iv: [UInt8] = AES.randomIV(AES.blockSize)
    var encPass: Array<UInt8> = Array("187".utf8)

    do {
        encPass = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(pass)
    } catch {
        print("ENC ERROR:", error)
    }
    
    let pwdMap = encPass.map { String($0) }
    let pwdString = pwdMap.joined()

    print("\n\n encPass: \(pwdString) \n\n")
    
    return (pwdString, iv)
}

func decryptPass(website: String, keyID: String, usedKey: String, password: String, iv: String) -> String {
    let pass: [UInt8] = Array("\(password)".utf8)
    let key: [UInt8] = Array("\(usedKey)".utf8)

    let iv: [UInt8] = Array("\(iv)".utf8)
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

func hashKey(key: String) -> String {
    let hash = key.sha256()
    return(hash)
}
