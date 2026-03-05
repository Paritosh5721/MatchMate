import SwiftUI

struct MatchListView: View {
    @StateObject private var vm = MatchViewModel()

    var body: some View {
        NavigationView {
            Group {
                if vm.isLoading && vm.profiles.isEmpty {
                    ProgressView("Loading matches…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let err = vm.error, vm.profiles.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.system(size: 44))
                            .foregroundColor(.secondary)
                        Text(err)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        Button("Retry") { vm.load() }
                            .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    cardList
                }
            }
            .navigationTitle("Profile Matches")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .top) {
                if !vm.monitor.isOnline {
                    offlineBanner
                }
            }
        }
        .onAppear { vm.load() }
    }

    private var cardList: some View {
        List {
            ForEach(vm.profiles) { profile in
                MatchCardView(
                    profile: profile,
                    onAccept:  { vm.accept(profile.id) },
                    onDecline: { vm.decline(profile.id) }
                )
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .refreshable {
            vm.load()
        }
        .background(Color(.systemGroupedBackground))
    }

    private var offlineBanner: some View {
        HStack(spacing: 6) {
            Image(systemName: "wifi.slash")
            Text("No internet · showing cached data")
                .font(.caption)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.orange)
    }
}
