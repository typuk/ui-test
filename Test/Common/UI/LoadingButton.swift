import SwiftUI

struct AsyncButton<Label: View>: View {
    
    private var action: () async -> Void
    private var label: Label
    
    @State private var isPerformingTask = false
    
    init(
        action: @escaping () async -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.action = action
        self.label = label()
    }

    var body: some View {
        Button(action: {
            isPerformingTask = true
            
            Task {
                await action()
                isPerformingTask = false
            }
        }, label: {
            ZStack {
                label.opacity(isPerformingTask ? 0 : 1)
                
                if isPerformingTask {
                    ProgressView()
                }
            }
        })
        .disabled(isPerformingTask)
    }
}
