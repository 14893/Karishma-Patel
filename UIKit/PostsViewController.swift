import UIKit
import SwiftUI

/// A simple UIKit screen that shows the posts count and a button
/// to navigate into a SwiftUI detail screen.
final class PostsViewController: UIViewController {
    
    private let infoLabel = UILabel()
    private let openSwiftUIButton = UIButton(type: .system)
    
    // Data passed from SwiftUI
    var posts: [Post] = [] {
        didSet {
            updateLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIKit Screen"
        view.backgroundColor = .systemBackground
        
        setupViews()
        setupConstraints()
        updateLabel()
    }
    
    private func setupViews() {
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        
        openSwiftUIButton.setTitle("Open SwiftUI Detail", for: .normal)
        openSwiftUIButton.addTarget(self, action: #selector(openSwiftUIDetail), for: .touchUpInside)
        
        view.addSubview(infoLabel)
        view.addSubview(openSwiftUIButton)
    }
    
    private func setupConstraints() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        openSwiftUIButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            infoLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            openSwiftUIButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 24),
            openSwiftUIButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func updateLabel() {
        let count = posts.count
        infoLabel.text = "This is a UIKit view controller.\nCurrent posts count: \(count)"
    }
    
    @objc
    private func openSwiftUIDetail() {
        guard let first = posts.first else { return }
        let detail = PostDetailView(post: first)
        let hosting = UIHostingController(rootView: detail)
        navigationController?.pushViewController(hosting, animated: true)
    }
}

/// Wrapper to use `PostsViewController` in SwiftUI.
struct UIKitContainerView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PostListViewModel()
    
    func makeUIViewController(context: Context) -> UINavigationController {
        // Ensure the view model has data for the UIKit screen.
        // Because the view model is a @StateObject, this will only
        // trigger the async load once when posts are still empty.
        if viewModel.posts.isEmpty {
            viewModel.loadPostsAsync()
        }

        let vc = PostsViewController()
        vc.posts = viewModel.posts
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        if let vc = uiViewController.viewControllers.first as? PostsViewController {
            vc.posts = viewModel.posts
        }
    }
}
