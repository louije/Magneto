//
//  MagnetLink.swift
//  Magneto
//
//  Created by Louis-Jean Teitelbaum on 21/04/2020.
//  Copyright © 2020 Meidosem. All rights reserved.
//

import Combine
import Foundation

class MagnetLink: ObservableObject {
    @Published var url: URL?
    @Published var urlString = ""
    @Published var urlComponents = [(String, Array<String>)]()
    @Published var isValid: Bool = false
    
    private var cancellableSet: Set<AnyCancellable>  = []
    
    init(url: URL?) {
        self.url = url
        
        let urlStringPublisher = $url.share()
        let urlComponentsPublisher = $url.share()
        
        urlStringPublisher
            .receive(on: RunLoop.main)
            .map { optionalUrl in
                guard let url = optionalUrl else {
                    return "magnet:"
                }
                return url.absoluteString
            }
            .assign(to: \.urlString, on: self)
            .store(in: &cancellableSet)
        
        urlComponentsPublisher
            .receive(on: RunLoop.main)
            .map { optionalUrl in
                guard let url = optionalUrl else {
                    return [(String, Array<String>)]()
                }
                return self.decomposeMagnet(url: url)
            }
            .assign(to: \.urlComponents, on: self)
            .store(in: &cancellableSet)
        
        let isValidPublisher = $urlComponents.share()
        
        isValidPublisher
            .receive(on: RunLoop.main)
            .map { arr in
                return (arr.first(where: { (str, vals) in
                    str == "Hash" && !vals.isEmpty
                }) != nil)
            }
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
        
    }
    
    convenience init() {
        self.init(url: nil)
    }

    private func decomposeMagnet(url: URL) -> [(String, Array<String>)] {
        let string = url.absoluteString
        let lastIndex = string.endIndex
        var currentIndex = string.startIndex
        var results = [(String, Array<String>)]()
        
        let scheme = string.range(of: "magnet:?")
        currentIndex ?= scheme?.upperBound
        
        let xt = string.range(of: #"(?<=xt=).*?(?=&)"#, options: .regularExpression, range: currentIndex..<lastIndex)
        currentIndex ?= xt?.upperBound
        
        let dn = string.range(of: #"(?<=dn=).*?(?=&)"#, options: .regularExpression, range: currentIndex..<lastIndex)
        currentIndex ?= dn?.upperBound
        
        var trackers = [String]()
        while let tr = string.range(of: "(?<=&tr=).*?(?=&|$)", options: .regularExpression, range: currentIndex..<lastIndex) {
            trackers.append(String(string[tr]).removingPercentEncoding ?? String(string[tr]))
            currentIndex ?= tr.upperBound
        }
        
        let trail = currentIndex..<lastIndex
        
        func appendToResults(key: String, optionalRange: Range<String.Index>?) {
            if let range = optionalRange {
                results.append((key, [String(string[range]).removingPercentEncoding ?? String(string[range])]))
            }
        }
        
//        appendToResults(key: "Scheme", optionalRange: scheme)
        appendToResults(key: "File name", optionalRange: dn)
        appendToResults(key: "Hash", optionalRange: xt)
        results.append(("Trackers", trackers))
        
        if !trail.isEmpty {
            results.append(("Trailing", [String(string[trail])]))
        }
        
        return results
    }
}

fileprivate func ?=<T>(lhs: inout T, rhs: T?) {
    if let rhs = rhs {
        lhs = rhs
    }
}

infix operator ?=
