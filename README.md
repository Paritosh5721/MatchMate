# MatchMate

A simple matrimonial app built as part of an iOS assignment. It fetches profiles from an API, shows them as cards, and lets you accept or decline each match. Decisions are stored in Core Data so they stick between launches.

---

## What it does

- Loads user profiles from JSONPlaceholder API
- Shows each profile as a card with photo, name, city and company
- Accept / Decline buttons update the card immediately
- Accepted/declined status is saved to Core Data
- Works offline — shows cached profiles if there's no internet
- Automatically re-fetches when connection comes back
- Pull to refresh

---

## Stack

- SwiftUI
- MVVM
- URLSession + Combine
- Core Data (programmatic model, no .xcdatamodeld)
- NWPathMonitor for connectivity
- NSCache for image caching

---

## Structure

```
MatchMate/
├── Protocols.swift
├── Models/
│   └── User.swift
├── CoreData/
│   └── CoreDataStack.swift
├── Services/
│   ├── NetworkService.swift
│   ├── StorageService.swift
│   └── NetworkMonitor.swift
├── ViewModels/
│   └── MatchViewModel.swift
├── Views/
│   ├── MatchListView.swift
│   └── MatchCardView.swift
└── Helpers/
    ├── ImageCache.swift
    └── RemoteImage.swift
```

---

## Running it

Xcode 15+, iOS 16+. No packages to install, just open and run.

---

## API

```
GET https://jsonplaceholder.typicode.com/users
```

Profile photos are pulled from randomuser.me using the user ID as a seed so they stay consistent.

---

## Notes

- Core Data model is built in code so there's no .xcdatamodeld file needed
- Accept/decline status is preserved when you pull to refresh
- If you kill the app and reopen offline, it loads whatever was last cached
