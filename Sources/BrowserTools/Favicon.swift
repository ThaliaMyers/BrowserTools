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
    @State public var url: String
    @State public var size: CGFloat
    @State public var shape: AnyShape?
    
    public var body: some View {
        KFImage(
            URL(
                string: "https://www.google.com/s2/favicons?domain=\(url)&sz=\(128)"
                    .replacingOccurrences(of: "https://www.google.com/s2/favicons?domain=Optional(", with: "https://www.google.com/s2/favicons?domain=")
                    .replacingOccurrences(of: ")&sz=", with: "&sz=").replacingOccurrences(of: "\"", with: "")
            )
        )
        .resizable()
        .scaledToFit()
        .frame(width: size, height: size)
        .clipShape(shape ?? AnyShape(Circle()))
    }
}
