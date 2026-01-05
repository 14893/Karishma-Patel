# SwiftUI + UIKit Mix App

A modern iOS application demonstrating **SwiftUI**, **UIKit integration**, **MVVM architecture**, **Combine framework**, **async/await**, and **lazy loading** with public API integration.

## 📱 Features

- ✅ **MVVM Architecture** - Clean separation of concerns
- ✅ **SwiftUI Views** - Modern declarative UI
- ✅ **UIKit Integration** - Seamless mixing of UIKit and SwiftUI
- ✅ **Combine Framework** - Reactive programming with publishers
- ✅ **Async/Await** - Modern concurrency patterns
- ✅ **Lazy Loading** - Efficient pagination (10 items at a time)
- ✅ **Image Loading** - AsyncImage with proper error handling
- ✅ **Public API Integration** - JSONPlaceholder API for posts and photos
- ✅ **Dependency Injection** - Testable architecture

## 🏗️ Architecture

### MVVM Pattern
- **Models**: `Post`, `Photo` - Data structures
- **ViewModels**: `PostListViewModel`, `PhotoListViewModel` - Business logic and state management
- **Views**: SwiftUI views for UI presentation
- **Networking**: `APIClient` - API service layer

### Project Structure
```
SwiftUIDemoApp/
├── MixUIKitSwiftUIApp.swift    # App entry point
├── Models/
│   ├── Post.swift              # Post data model
│   └── Photo.swift             # Photo data model
├── ViewModels/
│   ├── PostListViewModel.swift # Posts view model (Combine + async/await)
│   └── PhotoListViewModel.swift # Photos view model with lazy loading
├── Views/
│   ├── PostListView.swift      # Main posts list view
│   └── PhotoListView.swift     # Photos list with images
├── Networking/
│   └── APIClient.swift         # API client (async/await + Combine)
└── UIKit/
    └── PostsViewController.swift # UIKit view controller + SwiftUI bridge
```

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0 or later
- Swift 5.7 or later

### Setup Instructions

1. **Create a new Xcode project:**
   - Open Xcode
   - Create a new iOS App project
   - Choose **SwiftUI** for Interface
   - Choose **SwiftUI App** for Lifecycle
   - Name it `MixUIKitSwiftUIApp` (or any name you prefer)

2. **Add the source files:**
   - Copy all files from this repository into your Xcode project
   - Maintain the folder structure (Models, ViewModels, Views, Networking, UIKit)
   - Make sure all files are added to your app target

3. **Update the App file:**
   - Replace the auto-generated `App` file with `MixUIKitSwiftUIApp.swift`
   - Ensure there's only **one** `@main` entry point

4. **Build and Run:**
   - Select a simulator or device
   - Press ⌘R to build and run

## 📖 Usage

### Main Features

1. **Posts List Screen**
   - Toggle between **Async/Await** and **Combine** loading styles
   - View list of posts from JSONPlaceholder API
   - Navigate to post details
   - Navigate to UIKit screen
   - Navigate to Photos list

2. **Photos List Screen**
   - View photos with thumbnails
   - **Lazy loading**: Loads 10 items at a time as you scroll
   - Automatic pagination when reaching the bottom

3. **UIKit Integration**
   - UIKit view controller embedded in SwiftUI
   - Navigate from UIKit back to SwiftUI detail view
   - Demonstrates bidirectional integration

## 🔧 Technical Details

### APIs Used
- **Posts API**: `https://jsonplaceholder.typicode.com/posts`
- **Photos API**: `https://jsonplaceholder.typicode.com/photos`

### Key Technologies

- **SwiftUI**: Declarative UI framework
- **UIKit**: Traditional iOS UI framework
- **Combine**: Reactive programming framework
- **Async/Await**: Modern Swift concurrency
- **MVVM**: Model-View-ViewModel architecture pattern
- **URLSession**: Network requests
- **AsyncImage**: SwiftUI image loading

### Code Highlights

#### Async/Await Example
```swift
func loadPostsAsync() {
    Task {
        await loadPostsWithAsyncAwait()
    }
}

private func loadPostsWithAsyncAwait() async {
    isLoading = true
    do {
        let result = try await apiClient.fetchPosts()
        posts = result
    } catch {
        errorMessage = "Failed to load posts: \(error.localizedDescription)"
    }
    isLoading = false
}
```

#### Combine Example
```swift
func loadPostsWithCombine() {
    isLoading = true
    apiClient.fetchPostsPublisher()
        .sink { [weak self] completion in
            // Handle completion
        } receiveValue: { [weak self] posts in
            self?.posts = posts
        }
        .store(in: &cancellables)
}
```

#### Lazy Loading
```swift
func loadMoreIfNeeded(currentItem: Photo?) {
    guard let currentItem = currentItem,
          !visiblePhotos.isEmpty else { return }
    
    guard let index = visiblePhotos.firstIndex(where: { $0.id == currentItem.id }) else { return }
    
    let thresholdIndex = visiblePhotos.index(visiblePhotos.endIndex, offsetBy: -1)
    if index == thresholdIndex {
        loadMore() // Load next 10 items
    }
}
```

#### UIKit in SwiftUI
```swift
struct UIKitContainerView: UIViewControllerRepresentable {
    @StateObject private var viewModel = PostListViewModel()
    
    func makeUIViewController(context: Context) -> UINavigationController {
        if viewModel.posts.isEmpty {
            viewModel.loadPostsAsync()
        }
        let vc = PostsViewController()
        vc.posts = viewModel.posts
        return UINavigationController(rootViewController: vc)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Update when viewModel.posts changes
    }
}
```

## 🎯 Best Practices Demonstrated

- ✅ **SOLID Principles**: Single Responsibility, Dependency Inversion
- ✅ **Dependency Injection**: ViewModels accept dependencies via initializer
- ✅ **Error Handling**: Proper error states and user feedback
- ✅ **Loading States**: Loading indicators during API calls
- ✅ **Memory Management**: Weak references in Combine subscriptions
- ✅ **Main Actor**: Proper thread safety with `@MainActor`
- ✅ **Empty State Handling**: Guards against crashes with empty arrays

## 📝 Notes

- The app uses public APIs that don't require authentication
- All data is fetched from JSONPlaceholder (test data)
- Images are loaded asynchronously with proper error handling
- The lazy loading implementation loads 10 items at a time for optimal performance

## 👨‍💻 Author

**Karishma Patel**
- GitHub: [@14893](https://github.com/14893)
- LinkedIn: [Karishma Patel](https://linkedin.com/in/Karishma Patel)
- Email: karishmapatel1493@gmail.com

## 📄 License

This project is open source and available for learning purposes.

---

**Built with ❤️ using SwiftUI, UIKit, Combine, and async/await**
