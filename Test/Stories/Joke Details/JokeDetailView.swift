import SwiftUI

struct JokeDetailView: View {

    @State private var viewModel: ViewModel

    init(joke: Joke) {
        _viewModel = State(initialValue: ViewModel(joke: joke))
    }

    var body: some View {
        VStack {
            Text(viewModel.state.joke.setup)
                .padding(.bottom, 32)
            
            if viewModel.state.showPunchLine {
                Text(viewModel.state.joke.punchline)
            } else {
                Button {
                    withAnimation {
                        viewModel.showPunchLine()
                    }
                } label: {
                    Text("joke.details.cta")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .navigationTitle("joke.list.cell.title \(viewModel.state.joke.id)")
    }
}

#Preview {
    JokeDetailView(joke: .mock)
}

private extension JokeDetailView {
    
    @Observable
    class ViewModel {
        
        struct State {
            let joke: Joke
            var showPunchLine = false
        }
        
        var state: State
        
        init(joke: Joke) {
            self.state = .init(joke: joke)
        }
        
        func showPunchLine() {
            state.showPunchLine.toggle()
        }
    }
    
}
