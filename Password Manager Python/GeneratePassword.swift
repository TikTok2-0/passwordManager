//
//  GeneratePassword.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 14.07.21.
//

import SwiftUI

struct GeneratePassword: View {
    @State var generatedPassword: String = "Generated Password"
    @State var passwordLength: Double = 0.0
    @State var useNumbers: Bool = false
    @State var useUppercase: Bool = false
    @State var useSpecial: Bool = false
    
    let paddingFloat: CGFloat = 15
    
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
                                Button(action: {}) {
                                    Image(systemName: "doc.on.doc")
                                }//.padding(.trailing, geometry.size.width*0.05)
                            }
                        )
                }
                
                HStack {
                    Slider(value: $passwordLength, in: 0...32)
                    Text("\(Int(passwordLength))")
                        .frame(width: 25, height: nil, alignment: .center)
                }.frame(width: geometry.size.width/1.5, height: nil, alignment: .center)
                
                HStack {
                    Toggle("Numbers", isOn: $useNumbers)
                        .toggleStyle(.checkbox)
                    Spacer()
                    Button(action: {}) {
                        Label("Save password", systemImage: "key.icloud")
                    }
                }.frame(width: geometry.size.width/1.5, height: nil, alignment: .center)
                
                HStack {
                    Toggle("Special", isOn: $useSpecial)
                        .toggleStyle(.checkbox)
                    Spacer()
                }.frame(width: geometry.size.width/1.5, height: nil, alignment: .center)
                
                HStack {
                    Toggle("Uppercase", isOn: $useUppercase)
                        .toggleStyle(.checkbox)
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
