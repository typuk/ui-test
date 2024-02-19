import SwiftUI

struct JokeView: View {

    @State private var showPunchLine = false

    let joke: Joke

    var body: some View {

        Text(joke.setup)
            .padding()

        if showPunchLine {
            Text(joke.punchline)
        } else {
            Button {
                withAnimation {
                    showPunchLine = true
                }
            } label: {
                Text("joke.details.cta")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    JokeView(joke: .mock)
}
