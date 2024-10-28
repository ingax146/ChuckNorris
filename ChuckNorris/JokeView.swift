//
//  JokeView.swift
//  ChuckNorris
//
//  Created by Ingemar Axelsson on 2024-10-27.
//

import SwiftUI

struct JokeView : View {
    var joke: Joke;

    var body: some View {
        VStack(alignment:.center) {
            HStack {
                AsyncImage(url: joke.icon_url)
                Spacer()
                Text(joke.categories.joined(separator: ", "))
            }
            Text(joke.value)
            Text(AttributedString(joke.url.absoluteString))
                .font(.footnote)
        }
    }
}

extension RandomJokeView {
    @Observable
    class ViewModel {
        var category : String? = nil;
        private(set) var joke: Joke;

        init(_ category: String?) {
            self.category = category
            self.joke = Joke.init(categories: ["CategoryA, CategoryB"],
                                  created_at: "2020-01-01 12:55",
                                  icon_url: URL.init(string: "https://api.chucknorris.io/img/avatar/chuck-norris.png")!,
                                  id: "Test",
                                  updated_at: "2020-01-02 13:55",
                                  url: URL.init(string: "https://api.chucknorris.io/jokes/nVHI9qLjRXWfU3XA0Cy3gQ")!,
                                  value: "Chuck Norris does not own a house. He walks into random houses and people move.")
        }
        
        init(_ category: String?, _ joke: Joke) {
            self.category = category
            self.joke = joke
        }
        
        func refresh() async {
            do {
                var url = URL(string: "https://api.chucknorris.io/jokes/random")!
                if category != nil {
                   url = url.appending(queryItems: [URLQueryItem(name: "category", value: category)])
                }
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedData = try JSONDecoder().decode(Joke.self, from: data)
                joke = decodedData;
            } catch {
                print("Error fetching joke \(error)");
            }
        }
    }
}

struct RandomJokeView : View {
    @State var viewModel: ViewModel;

    init(_ category: String?) {
        viewModel = .init(category)
    }
    init(_ category: String?, _ joke: Joke) {
        viewModel = .init(category, joke)
    }
    
    var body: some View {
        List {
            JokeView(joke: viewModel.joke)
        }.refreshable {
            Task {
                await viewModel.refresh();
            }
        }.task {
            await viewModel.refresh();
        }
    }
}

#Preview {
    let joke = Joke.init(categories: ["CategoryA, CategoryB"],
                         created_at: "2020-01-01 12:55",
                         icon_url: URL.init(string: "https://api.chucknorris.io/img/avatar/chuck-norris.png")!,
                         id: "Test",
                         updated_at: "2020-01-02 13:55",
                         url: URL.init(string: "https://api.chucknorris.io/jokes/nVHI9qLjRXWfU3XA0Cy3gQ")!,
                         value: "Chuck Norris does not own a house. He walks into random houses and people move.")
    
    RandomJokeView(nil, joke)
}
