import SwiftUI

struct MatchCardView: View {
    let profile: MatchProfile
    var onAccept: () -> Void
    var onDecline: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            RemoteImage(url: profile.photoURL)
                .frame(height: 200)
                .clipped()

            VStack(spacing: 4) {
                Text(profile.name)
                    .font(.system(size: 20, weight: .semibold))

                Text(profile.city)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(profile.company)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 12)

            Divider()

            bottomSection
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 3)
    }

    @ViewBuilder
    private var bottomSection: some View {
        switch profile.status {
        case .pending:
            HStack(spacing: 0) {
                Button {
                    onDecline()
                } label: {
                    HStack {
                        Image(systemName: "xmark")
                        Text("Decline")
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                Divider().frame(height: 44)

                Button {
                    onAccept()
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Accept")
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        case .accepted:
            statusBar("Member Accepted", color: .green)
        case .declined:
            statusBar("Member Declined", color: .red)
        }
    }

    private func statusBar(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color)
    }
}
