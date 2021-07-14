//
//  GenerateKey.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 14.07.21.
//

import SwiftUI

struct GenerateKey: View {
    @State var key: UUID = UUID()
    
    var body: some View {
        VStack {
            Button(action: { key = UUID() }) {
                Label("Generate Key", systemImage: "dice")
            }
            
            Text("Generated Key:")
            Text("\(key)")
        }
    }
}

struct GenerateKey_Previews: PreviewProvider {
    static var previews: some View {
        GenerateKey()
    }
}
