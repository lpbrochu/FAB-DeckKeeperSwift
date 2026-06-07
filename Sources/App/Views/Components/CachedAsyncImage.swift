import SwiftUI
import Combine

#if os(macOS)
import AppKit
typealias PlatformImage = NSImage
#else
import UIKit
typealias PlatformImage = UIImage
#endif

// MARK: - Disk & Memory Image Cache
class ImageCache {
    static let shared = ImageCache()
    private let memoryCache = NSCache<NSString, PlatformImage>()

    private var cacheDirectory: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }

    func get(forKey key: String) -> PlatformImage? {
        let nsKey = key as NSString
        if let cached = memoryCache.object(forKey: nsKey) {
            return cached
        }

        // Check disk
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL), let image = PlatformImage(data: data) {
            memoryCache.setObject(image, forKey: nsKey)
            return image
        }
        return nil
    }

    func set(_ image: PlatformImage, forKey key: String) {
        let nsKey = key as NSString
        memoryCache.setObject(image, forKey: nsKey)

        let fileURL = cacheDirectory.appendingPathComponent(key)
        
        #if os(macOS)
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else { return }
        try? pngData.write(to: fileURL)
        #else
        guard let pngData = image.pngData() else { return }
        try? pngData.write(to: fileURL)
        #endif
    }
}

// MARK: - Image Loader ViewModel
class ImageLoader: ObservableObject {
    @Published var platformImage: PlatformImage?
    @Published var isLoading = false

    private var cancellable: AnyCancellable?
    private let url: URL
    private let cacheKey: String

    init(url: URL) {
        self.url = url
        // Sanitize the absolute URL string to create a safe, collision-free filename
        let allowed = CharacterSet.alphanumerics
        let clean = url.absoluteString.unicodeScalars.map { allowed.contains($0) ? String($0) : "_" }.joined()
        // Limit filename length to avoid filesystem limits (max 255 chars on APFS)
        self.cacheKey = String(clean.suffix(120))
    }

    func load() {
        if let cachedImage = ImageCache.shared.get(forKey: cacheKey) {
            self.platformImage = cachedImage
            return
        }

        isLoading = true
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { data, _ -> PlatformImage? in
                return PlatformImage(data: data)
            }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadedImage in
                guard let self = self else { return }
                self.isLoading = false
                if let image = loadedImage {
                    ImageCache.shared.set(image, forKey: self.cacheKey)
                    self.platformImage = image
                }
            }
    }

    func cancel() {
        cancellable?.cancel()
    }
}

// MARK: - SwiftUI CachedAsyncImage View
struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    init(
        url: URL,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.content = content
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let platformImage = loader.platformImage {
                #if os(macOS)
                content(Image(nsImage: platformImage))
                #else
                content(Image(uiImage: platformImage))
                #endif
            } else {
                placeholder()
            }
        }
        .onAppear(perform: loader.load)
        .onDisappear(perform: loader.cancel)
    }
}
