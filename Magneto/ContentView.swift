//
//  ContentView.swift
//  Magneto
//
//  Created by Louis-Jean Teitelbaum on 21/04/2020.
//  Copyright © 2020 Meidosem. All rights reserved.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject var link: MagnetLink
    
    func openLink() {
        ShortcutOpener.launch(url: link.url!)
    }
    
    var button: some View {
        if link.isValid {
            return AnyView(
                Button(action: openLink) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .frame(height: 44)
                            .padding(.vertical)
                        Text("Open link")
                            .foregroundColor(Color.white)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
                .disabled(!link.isValid)
            )
        }
        return AnyView(Text("Tap on a magnet: link in Safari"))
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: button) {
                    Text(link.urlString)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                }
                
                ForEach(0..<link.urlComponents.count, id: \.self) { comp in
                    Section(header: Text(self.link.urlComponents[comp].0)) {
                        ForEach(0..<self.link.urlComponents[comp].1.count, id: \.self) { idx in
                            Text(self.link.urlComponents[comp].1[idx])
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Magnet Link")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var testURL = "magnet:?xt=urn:btih:azertyuiop&dn=filename.ext&tr=http%3A%2F%2Ftracker.com%3A80%2Fannounce&tr=udp%3A%2F%2F9.tracker.me%3A2730&tr=udp%3A%2F%2F9.tracker.to%3A2740"
    
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(MagnetLink(
                    url: URL(string: testURL)!
                )
            )
            ContentView()
                .environmentObject(MagnetLink()
            )
        }
    }
}
