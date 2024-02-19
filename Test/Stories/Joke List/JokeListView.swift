import SwiftUI

struct JokeListView: View {

    @State private var viewModel: JokeListViewModel
    @Bindable private var navigationState = BaseComponents.shared.navigationState

    private var showErrorBinding: Binding<Bool> {
        .init(get: {
            viewModel.state.error != nil
        }, set: { _ in
            viewModel.state.error = nil
        })
    }

    init() {
        let viewModel = JokeListViewModel(
            jokeRepository: BaseComponents.shared.jokeRepository,
            navigationState: BaseComponents.shared.navigationState
        )
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $navigationState.routes) {
            rootView
                .navigationDestination(for: Joke.self) { joke in
                    JokeDetailView(joke: joke)
                }
        }
        .alert(isPresented: showErrorBinding) {
            Alert(error: viewModel.state.error)
        }
        .task {
            await viewModel.prepare()
        }
    }
}

private extension JokeListView {

    var rootView: some View {
        VStack {
            switch viewModel.state.dataState {
            case .data(let jokes):
                jokeListView(for: jokes)
            case .empty:
                emptyView
            case .initiating:
                EmptyView()
            }
        }
        .navigationTitle("joke.list.navigation.bar.title")
        .toolbar {
            AsyncButton(action: {
                await viewModel.showRandomJoke()
            }, label: {
                Text("joke.list.navigation.bar.random")
            })
        }
    }

    func jokeListView(for jokes: [Joke]) -> some View {
        List {
            Section(content: {
                ForEach(jokes) { joke in
                    Button(action: {
                        viewModel.didSelectJoke(joke: joke)
                    }, label: {
                        Text("joke.list.cell.title \(joke.id)")
                    })
                }
            }, footer: {
                HStack(alignment: .center, content: {
                    Spacer()
                    
                    AsyncButton(action: {
                        await viewModel.fetchJokes()
                    }, label: {
                        Text("joke.list.load.cta")
                    })
                    .padding(32)
                    .buttonStyle(.bordered)
                    
                    Spacer()
                })
            })
        }
    }

    var emptyView: some View {
        VStack {
            Image(systemName: "square.and.arrow.down")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 48))
                .padding(.bottom, 32)

            Text("joke.list.no.data.saved")
                .padding(.bottom, 16)
            
            AsyncButton(action: {
                await viewModel.fetchJokes()
            }, label: {
                Text("joke.list.load.cta")
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
    }
}
