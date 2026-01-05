import SwiftUI

struct PostListView: View {
    @StateObject private var viewModel = PostListViewModel()
    @State private var useAsyncAwait = true
    
    var body: some View {
        NavigationView {
            VStack {
                // Toggle between async/await and Combine loading
                Picker("Loading Style", selection: $useAsyncAwait) {
                    Text("Async/Await").tag(true)
                    Text("Combine").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if viewModel.isLoading {
                    ProgressView("Loading posts...")
                        .padding()
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                List(viewModel.posts) { post in
                    NavigationLink(destination: PostDetailView(post: post)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(post.title)
                                .font(.headline)
                                .lineLimit(2)
                            Text(post.body)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                HStack {
                    NavigationLink("Open UIKit Screen") {
                        UIKitContainerView()
                            .navigationTitle("UIKit in SwiftUI")
                    }

                    Spacer()

                    NavigationLink("Open Image List") {
                        PhotoListView()
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .navigationTitle("Posts")
            .onAppear {
                if viewModel.posts.isEmpty {
                    if useAsyncAwait {
                        viewModel.loadPostsAsync()
                    } else {
                        viewModel.loadPostsWithCombine()
                    }
                }
            }
            .onChange(of: useAsyncAwait) { _ in
                if useAsyncAwait {
                    viewModel.loadPostsAsync()
                } else {
                    viewModel.loadPostsWithCombine()
                }
            }
        }
    }
}

struct PostDetailView: View {
    let post: Post
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(post.title)
                    .font(.title2)
                    .bold()
                Text(post.body)
                    .font(.body)
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Detail")
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView()
    }
}
