import SwiftUI

extension Alert {

    init(error: String?) {
        self.init(
           title: Text("error.title"),
           message: Text(error ?? ""),
           dismissButton: .default(Text("okay"))
        )
    }
}
