//
//  SearchViewModel.swift
//  GithubUserSearch
//
//  Created by Songhee Choi on 2022/07/21.
//

import UIKit
import Combine

final class SearchViewModel {

    var network: NetworkService
    var subscriptions = Set<AnyCancellable>()
    
    init(network: NetworkService) {
        self.network = network
    }
    // Output
    @Published private(set) var users = [SearchResult]()
    
    // Intput
    func search(keyword: String) {
        let resource: Resource<SearchUserResponse> = Resource(
            base: "https://api.github.com/",
            path: "search/users",
            params: ["q": keyword],
            header: ["Content-Type": "application/json"]
        )
        
        network.load(resource)
            .map { $0.items }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .assign(to: \.users, on: self)
            .store(in: &subscriptions)
    }
}
