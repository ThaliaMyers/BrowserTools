//
// BrowserTools
// SearchSuggestions.swift
//
// Created on 2026-07-26
//
// Copyright ©2026 Thalia Myers.
//
    

import Foundation
import Observation

@MainActor
@Observable
public class SearchSuggestionsModel {
    public var searchSuggestions: [String] = []
    
    private var searchTask: Task<Void, Never>?
    
    public func updateGoogleSearchSuggestions(inputString: String) {
        searchTask?.cancel()
        
        guard !inputString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchSuggestions = []
            return
        }
        
        searchTask = Task {
            guard let xml = await fetchXML(searchRequest: inputString) else {
                return
            }
            
            guard !Task.isCancelled else {
                return
            }
            
            searchSuggestions = formatXML(from: xml)
        }
    }
    
    public func cancel() {
        searchTask?.cancel()
        searchTask = nil
    }

    nonisolated private func fetchXML(searchRequest: String) async -> String? {
        guard let url = URL(string: "https://toolbarqueries.google.com/complete/search?q=\(searchRequest.replacingOccurrences(of: " ", with: "+"))&output=toolbar&hl=en") else {
            print("Invalid URL")
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Fetch error: \(error.localizedDescription)")
            return nil
        }
    }

    nonisolated private func formatXML(from input: String) -> [String] {
        var results = [String]()
        var currentIndex = input.startIndex

        while let startIndex = input[currentIndex...].range(of: "data=\"")?.upperBound {
            let remainingSubstring = input[startIndex...]

            if let endIndex = remainingSubstring.range(of: "\"")?.lowerBound {
                let attributeValue = input[startIndex..<endIndex]
                results.append(String(attributeValue))
                currentIndex = endIndex
            } else {
                break
            }
        }

        return results
    }
}

