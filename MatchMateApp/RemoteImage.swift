import SwiftUI

struct RemoteImage: View {
    let url: String
    @StateObject private var cache = ImageCache()

    var body: some View {
        Group {
            if let img = cache.image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
            } else {
                Color(.systemGray5)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.gray.opacity(0.4))
                    )
            }
        }
        .onAppear { cache.fetch(url: url) }
        .onDisappear { cache.cancel() }
    }
}
