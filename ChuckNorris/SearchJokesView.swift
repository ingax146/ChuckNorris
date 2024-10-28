//
//  SearchJokes.swift
//  ChuckNorris
//
//  Created by Ingemar Axelsson on 2024-10-27.
//

import SwiftUI

struct SearchedJokes : Codable {
    let total: Int;
    let result: [Joke]
}

extension SearchJokesView {

    @Observable
    class ViewModel {
        var searchText: String = ""
        private(set) var results: [Joke] = [];

        func performSearch() {
            Task {
                do {
                    var url = URL(string: "https://api.chucknorris.io/jokes/search")!
                    url = url.appending(queryItems: [URLQueryItem(name: "query", value: searchText)])
                    
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let decodedData = try JSONDecoder().decode(SearchedJokes.self, from: data)
                    results = decodedData.result;
                } catch  {
                    print("Error fetching categories \(error)");
                }
            }
        }
    }
}

struct SearchJokesView : View {
    @State private var viewModel = ViewModel();

    var body: some View {
        ScrollView {
            VStack(spacing:10) {
                ForEach(viewModel.results, id: \.id) { joke in
                    JokeView(joke: joke)
                        .frame(minHeight: 150)
                }.padding()
            }
        }.searchable(text: $viewModel.searchText, prompt: "Search for jokes")
            .onSubmit(of: .search, viewModel.performSearch)
    }
}

#Preview {
    SearchJokesView()
}
