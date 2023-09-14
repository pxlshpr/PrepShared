import Foundation
import SwiftUI
import OSLog

import SwiftSugar

private let logger = Logger(subsystem: "PagedArray", category: "")

@Observable public class PagedArray<Type: Equatable> {
    public var array: [Type]
    public var isLoadingPage: Bool
    public var currentPage: Int
    public var canLoadMorePages: Bool
    public var shouldShowEmptyState: Bool
    
    public var fetchPageHandler: (Int, String?) async throws -> [Type]
    public var didFetchPageHandler: (() -> ())?
    
    public var searchTask: Task<Void, Error>? = nil
    public var displayedSearchText: String? = nil
    
    public init(
        _ fetchPageHandler: @escaping (Int, String?) async throws -> [Type],
        _ didFetchPageHandler: (() -> ())? = nil
    ) {
        self.array = []
        self.isLoadingPage = true
        self.shouldShowEmptyState = true
        self.currentPage = 1
        self.canLoadMorePages = true
        self.fetchPageHandler = fetchPageHandler
        self.didFetchPageHandler = didFetchPageHandler
    }
}

public extension PagedArray {
    
    //MARK: Public Functions
    func performSearch(_ text: String, showingLoading: Bool = true) {
        searchTask?.cancel()
        
        let text = text.trimmingWhitespaces.lowercased()
        guard !text.isEmpty else {
            clear()
            fetchFirstPage(showingLoading: showingLoading)
            return
        }
        
        shouldShowEmptyState = false
        isLoadingPage = showingLoading
        
        searchTask = Task {
            
            /// Wait a bit to allow fast typing to proceed uninterrupted
            try await sleepTask(0.3, tolerance: 0.05)
            try Task.checkCancellation()
            
            await MainActor.run {
                displayedSearchText = text
            }
            try Task.checkCancellation()
            
            try await fetchFirstPage(searchText: text, showingLoading: showingLoading)
        }
    }
    
    func fetchFirstPage(showingLoading: Bool = true) {
        Task {
            try await fetchFirstPage(searchText: nil, showingLoading: showingLoading)
        }
    }
    
    func fetchFirstPage(searchText: String? = nil, showingLoading: Bool = true) async throws {
        await MainActor.run {
            currentPage = 1
            shouldShowEmptyState = false
            isLoadingPage = showingLoading
        }
        try await fetchNextPage(searchText: searchText)
    }
    
    func fetchNextPageIfAvailable(for element: Type, searchText: String? = nil) {
        if shouldLoadNextPage(for: element), !isLoadingPage, canLoadMorePages {
            isLoadingPage = true
            Task.detached(priority: .userInitiated) {
                try await self.fetchNextPage(searchText: searchText)
            }
        }
    }
    
    func clear() {
        array = []
        isLoadingPage = true
        shouldShowEmptyState = true
        currentPage = 1
        canLoadMorePages = true
    }
}

extension PagedArray {
    
    func fetchNextPage(searchText: String? = nil) async throws {
        let results = try await fetchPageHandler(currentPage, searchText)
        try Task.checkCancellation()
        await MainActor.run {
            withAnimation(.smooth) {
                append(results)
            }
            didFetchPageHandler?()
        }
    }
    
    func append(_ results: [Type]) {
        if currentPage == 1 {
            array = results
        } else {
            array.append(contentsOf: results)
        }
            
        canLoadMorePages = results.count == FoodsPageSize
        currentPage += 1
        isLoadingPage = false
        shouldShowEmptyState = array.isEmpty
    }
    
    func shouldLoadNextPage(for element: Type) -> Bool {
        let thresholdIndex = array.index(array.endIndex, offsetBy: -5)
        return array.firstIndex(where: { $0 == element }) == thresholdIndex
    }
}
