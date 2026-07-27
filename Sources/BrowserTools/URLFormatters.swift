//
// BrowserTools
// File.swift
//
// Created on 2026-07-24
//
// Copyright ©2026 Thalia Myers.
//
    

import Foundation

/// Formats a URL as a string from provided plain text input.
///
/// - Returns: The input URL formatted for web content such as WKWebView
///
/// - Parameters:
///     - urlString: A string representation of the URL you would like to format.
///     - treatAsSearch: Whether the function should treat the input as a web search if applicable or not. When disabled, input containing spaces and/or missing a TLD will fail to parse. Defaults to true.
///     - searchTermBaseUrl: If treat as search is true, this is used as the url format for the search engine. If none is provided, it defaults to google search.
public func formatURL(_ urlString: String, treatAsSearch: Bool?, searchTermBaseUrl: String?) -> String {
    var formattedInput = urlString
    
    // URL already has scheme - return unmodified input
    if let url = URL(string: urlString), url.scheme != nil {
        if var components = URLComponents(string: urlString) {
            components.scheme = components.scheme?.lowercased()
            components.host = components.host?.lowercased()
            return components.string ?? urlString
        }
        return urlString
    }
    
    // URL missing scheme - add https://
    if let url = URL(string: "https://\(urlString)"), url.host != nil {
        if url.absoluteString.contains(".") && !url.absoluteString.contains(" ") {
            if var components = URLComponents(string: "https://\(urlString)") {
                components.scheme = components.scheme?.lowercased()
                components.host = components.host?.lowercased()
                return components.string ?? url.absoluteString
            }
            return url.absoluteString
        }
    }
    
    // Treat as a search term - parse spaces and insert with search url
    var searchTerms: String = ""
    
    if treatAsSearch == true || treatAsSearch == nil {
        searchTerms = urlString.split(separator: " ").joined(separator: "+")
        
        return "\(searchTermBaseUrl ?? "https://www.google.com/search?q=")\(searchTerms)"
    }
    
    // If all cases fail, return input url
    return urlString
}


/// Unformats a URL. Automatically detects and converts search urls into base search terms or full urls into simplified ones.
///
/// For example: `https://www.google.com/search?q=hello+world` becomes `hello world`
///
/// or: `https://heyitsthalia.com/home` becomes `heyitsthalia.com`.
public func unformatURL(_ urlString: String, searchTermBaseUrl: String?) -> String {
    let searchEngine = searchTermBaseUrl ?? "https://www.google.com/search?q="
    
    var formattedUrl = urlString
    if urlString.starts(with: searchEngine) {
        formattedUrl = formattedUrl.replacingOccurrences(of: searchEngine, with: "")
        formattedUrl = formattedUrl.components(separatedBy: "&")[0]
        if formattedUrl.last == "/" {
            formattedUrl.removeLast()
        }
        formattedUrl = formattedUrl.replacingOccurrences(of: "+", with: " ")
        formattedUrl = formattedUrl.replacingOccurrences(of: "%20", with: " ")
    }
    else {
        formattedUrl = formattedUrl.replacingOccurrences(of: "https://", with: "")
        formattedUrl = formattedUrl.replacingOccurrences(of: "http://", with: "")
        formattedUrl = formattedUrl.replacingOccurrences(of: "www.", with: "")
        if formattedUrl.last == "/" {
            formattedUrl.removeLast()
        }
    }
    
    
    return formattedUrl
}
