//
//  GeneratePassword.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 14.07.21.
//

import SwiftUI

struct GeneratePassword: View {
    @State var generatedPassword: String = "Generated Password"
    @State var passwordLength: Double = 12
    @ObservedObject var userData = UserData()
    
    let paddingFloat: CGFloat = 15
    
    func generatePassword() {
        let len = Int(passwordLength)
        let chars = "abcdefghijklmnopqrstuvwxyz"
        let charsANDspecial = "abcdefghijklmnopqrstuvwxyz&/()=?!§,.;:_-#+*<>{}[]|$"
        let charsANDupper = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let charsANDfigures = "abcdefghijklmnopqrstuvwxyz0123456789"
        let charsANDspecialANDupper = "abcdefghijklmnopqrstuvwxyz&/()=?!§,.;:_-#+*<>{}[]|$ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let charsANDupperANDfigures = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charsANDfiguresANDspecial = "abcdefghijklmnopqrstuvwxyz0123456789&/()=?!§,.;:_-#+*<>{}[]|$"
        let charsANDall = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ&/()=?!§,.;:_-#+*<>{}[]|$0123456789"
        
        if userData.specialChars == false && userData.upperChars == false && userData.figureChars == false {
            //NUR CHARS
            let rndPswd = String((0..<len).compactMap{ _ in chars.randomElement() })
            generatedPassword = rndPswd
        } else if userData.specialChars == true && userData.upperChars == false && userData.figureChars == false {
            //NUR SPECIAL
            let rndPswd = String((0..<len).compactMap{ _ in charsANDspecial.randomElement() })
            generatedPassword = rndPswd
        } else if userData.specialChars == false && userData.upperChars == true && userData.figureChars == false {
            //NUR UPPER
            let rndPswd = String((0..<len).compactMap{ _ in charsANDupper.randomElement() })
            generatedPassword = rndPswd
        } else if userData.specialChars == false && userData.upperChars == false && userData.figureChars == true {
            //NUR FIGURES
            let rndPswd = String((0..<len).compactMap{ _ in charsANDfigures.randomElement() })
            generatedPassword = rndPswd
        } else if userData.specialChars == true && userData.upperChars == true && userData.figureChars == false {
            //SPECIAL UND UPPER
            let rndPswd = String((0..<len).compactMap{ _ in charsANDspecialANDupper.randomElement() })
            generatedPassword = rndPswd
        } else if userData.specialChars == false && userData.upperChars == true && userData.figureChars == true {
            //UPPER UND FIGURES
            let rndPswd = String((0..<len).compactMap{ _ in charsANDupperANDfigures.randomElement() })
            generatedPassword = rndPswd
        } else if userData.specialChars == true && userData.upperChars == false && userData.figureChars == true {
            //FIGURES UND SPECIAL
            let rndPswd = String((0..<len).compactMap{ _ in charsANDfiguresANDspecial.randomElement() })
            generatedPassword = rndPswd
        } else if userData.specialChars == true && userData.upperChars == true && userData.figureChars == true {
            //CHARS MIT ALLEM
            let rndPswd = String((0..<len).compactMap{ _ in charsANDall.randomElement() })
            generatedPassword = rndPswd
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text(generatedPassword)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: geometry.size.width-(paddingFloat*2), height: nil, alignment: .center)
                        .multilineTextAlignment(.center)
                        .overlay(
                            HStack {
                                Spacer()
                                Button(action: {
                                    let pasteboard = NSPasteboard.general
                                    pasteboard.clearContents()
                                    pasteboard.setString(generatedPassword, forType: .string)
                                }) {
                                    Image(systemName: "doc.on.doc")
                                }//.padding(.trailing, geometry.size.width*0.05)
                            }
                        )
                }
                
                HStack {
                    Slider(value: $passwordLength, in: 1...32)
                    Text("\(Int(passwordLength))")
                        .frame(width: 25, height: nil, alignment: .center)
                }.frame(width: geometry.size.width/1.5, height: nil, alignment: .center)
                
                HStack {
                    Toggle(isOn: $userData.figureChars) {
                        HStack {
                            Text("Numbers")
                            Text("0-9")
                                .foregroundColor(.green)
                        }
                    }
                    Spacer()
                    Button(action: { generatePassword() }) {
                        Label("Generate password", systemImage: "dice")
                    }
                }.frame(width: geometry.size.width/1.5, height: nil, alignment: .center)
                
                HStack {
                    Toggle(isOn: $userData.specialChars) {
                        HStack {
                            Text("Special")
                            Text("&-$")
                                .foregroundColor(.red)
                        }
                    }
                    Spacer()
                    Button(action: {}) {
                        Label("Save password", systemImage: "key.icloud")
                    }
                }.frame(width: geometry.size.width/1.5, height: nil, alignment: .center)
                
                HStack {
                    Toggle(isOn: $userData.upperChars) {
                        HStack {
                            Text("Uppercase")
                            Text("A-Z")
                                .foregroundColor(.yellow)
                        }
                    }
                    Spacer()
                }.frame(width: geometry.size.width/1.5, height: nil, alignment: .center)
                
            }.padding(paddingFloat)
        }
    }
}

struct GeneratePassword_Previews: PreviewProvider {
    static var previews: some View {
        GeneratePassword()
    }
}
