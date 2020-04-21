//
//  ShortcutOpener.swift
//  Magneto
//
//  Created by Louis-Jean Teitelbaum on 21/04/2020.
//  Copyright © 2020 Meidosem. All rights reserved.
//

import UIKit

struct ShortcutOpener {
    static func launch(url: URL) {
        let shortcut = "shortcuts://run-shortcut?name=" +
                       "Open Magnet Link".addingPercentEncoding(withAllowedCharacters: .alphanumerics)! +
                       "&input=" +
                       url.absoluteString
        
        guard let shortcutURL = URL(string: shortcut) else {
            fatalError("Couldn't create shortcut URL from \(shortcut)")
        }
        
        UIApplication.shared.open(shortcutURL, options: [:], completionHandler: nil)
    }
}
