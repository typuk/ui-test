import SwiftUI

struct LoadingButton<Label: View>: View {
    
    private var label: Label
    private var action: () async -> Void
    @Binding var isLoading: Bool
    
    init(
        action: @escaping () async -> Void,
        @ViewBuilder label: () -> Label,
        isLoading: Binding<Bool>
    ) {
        self.label = label()
        self.action = action
        self._isLoading = isLoading
    }
    
    var body: some View {
        Button(action: {
            Task {
                await action()
            }
        }, label: {
            ZStack {
                label.opacity(isLoading ? 0 : 1)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
        })
        .disabled(isLoading)
    }
}
