# iOS App with Multiple State Management Approaches

This project illustrates **various ways to manage state** in an iOS application, leveraging the same **Domain** and **Data** layers (in a Clean Architecture style). We only vary the **presentation layer**, demonstrating **six** approaches:

1. **SwiftUI + Swift Concurrency** (async/await)
2. **SwiftUI + Combine**
3. **SwiftUI + RxSwift**
4. **UIKit + RxSwift** (imperative UI, reactive data)
5. **UIKit + Delegates** (classic “old-fashioned” state management)

---

## Folder Structure

```.
    └── StateManagementPoc/
        ├── Data/
        │   ├── Model/
        │   │   └── PostModel.swift
        │   ├── Repository/
        │   │   └── HttpPostRepository.swift
        │   └── Service/
        │       └── PostService.swift
        ├── Domain/
        │   ├── Entity/
        │   │   └── PostEntity.swift
        │   ├── Repository/
        │   │   └── PostRepository.swift
        │   └── Usecase/
        │       └── FetchPostsUseCase.swift
        └── Presentation/
            ├── View/
            │   ├── SwiftUI/
            │   │   └── PostsFeatureView.swift
            │   └── UIKit/
            │       ├── DelegatedManagement
            │       ├── DelegateViewController
            │       ├── RxSwift/
            │       │   └── PostsTableViewController.swift
            │       ├── SwiftUIBridge
            │       └── UIKitGenericContainer
            ├── ViewModel/
            │   ├── SwiftUI/
            │   │   ├── Combine/
            │   │   │   └── CombinePostsViewModel.swift
            │   │   ├── RxSwift/
            │   │   │   └── RxSwiftPostsViewModel.swift
            │   │   └── SwiftConcurrency/
            │   │       └── ConcurrentPostsViewModel.swift
            │   └── UIKit/
            │       └── UIKitRxPostsViewModel.swift
            ├── PostsViewModelProtocol.swift
            └── MenuView.swift

```

Each **layer** has its responsibilities:

- **Domain**:

  - Pure business entities (`PostEntity`),
  - Repository protocols (`PostRepository`),
  - Use cases (`FetchPostsUseCase`).

- **Data**:

  - Data structures for network or persistence (`PostModel`),
  - Services for network calls (`PostAPIService`),
  - Repository implementations (`PostRepositoryImpl`).

- **Presentation**:
  - Multiple UI front-ends + state management patterns.
  - Each subfolder shows how Domain/Data is wired to the UI in a different way.

---

## Motivation

1. **Demonstrate** how to separate concerns:

   - **Domain** is business logic, with no awareness of UI or storage.
   - **Data** handles the low-level tasks (network, DB, etc.).
   - **Presentation** decides how to display and react to changes (via Concurrency, Combine, Rx, TCA, or Delegates).

2. **Compare** state management patterns:

   1. **SwiftUI + Concurrency**: uses `async/await` for data fetching.
   2. **SwiftUI + Combine**: uses publishers (`@Published`, `sink`, `Future`) for reactivity.
   3. **SwiftUI + RxSwift**: uses `Observable`, `subscribe`, `disposed(by:)`.
   4. **UIKit + RxSwift**: classic `UITableViewController` approach but reactive calls with Rx.
   5. **UIKit + Delegates**: the most “old-school” approach, purely imperative with manual callbacks.

3. **DRY (Don’t Repeat Yourself) and KISS (Keep It Simple)**:
   - Shared logic (e.g., `PostsViewModelProtocol`) is reused across approaches.
   - Each approach minimizes duplication by leveraging the same Domain and Data layers.

---

## Overall Flow

- The **App** might show a `MenuView` listing each approach.
- Selecting an approach navigates to that approach’s screen or SwiftUI container.
- Each approach calls the same `Domain` logic (`FetchPostsUseCase`) which calls the same `Data` logic.
- The difference is only in **how** the data or errors are published to the UI.

---

## How to Run

1. **Install dependencies**:
   - RxSwift (via SwiftPM).
2. **Open the project** in Xcode (iOS 15+).
3. **Run** on the simulator.
4. On the main menu, select each approach to see how it handles:
   - Data fetch,
   - Loading states,
   - Error states,
   - Presenting a list of posts.

---
