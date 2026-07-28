//
// BrowserTools
// Favicon.swift
//
// Created on 2026-07-24
//
// Copyright ©2026 Thalia Myers.
//
    

import SwiftUI
import Kingfisher

/// Displays a favicon of the specified shape and size
///
/// - Parameters:
///     - url: A string representation of the URL you would like to format.
///     - size: The width and height the favicon should be displayed as.
///     - shape: The clip shape for the favicon to use.
public struct Favicon: View {
    private let url: String
    private let size: CGFloat
    private let shape: AnyShape

    public init(url: String, size: CGFloat, shape: AnyShape? = nil) {
        self.url = url
        self.size = size
        self.shape = shape ?? AnyShape(Circle())
    }

    private var faviconURL: URL? {
        var components = URLComponents(string: "https://www.google.com/s2/favicons")
        components?.queryItems = [
            URLQueryItem(name: "domain", value: url),
            URLQueryItem(name: "sz", value: "128")
        ]
        return components?.url
    }

    public var body: some View {
        KFImage(faviconURL)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(shape)
    }
}
