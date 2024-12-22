//
//  UIImageView+Ex.swift
//  WidgetIsland
//
//  Created by julian on 2024/5/28.
//

import Kingfisher
import KingfisherWebP

private var imageDownloadUrlKey: Void?
private var imageCacheKeyKey: Void?
private var originImageCacheKeyKey: Void?

public extension UIImageView {
    private struct AssociatedKey {
        static var cacheKey: String = "cacheKey"
    }
    
    private var cacheKey: String {
        get { return objc_getAssociatedObject(self, &AssociatedKey.cacheKey) as? String ?? "" }
        set { objc_setAssociatedObject(self, &AssociatedKey.cacheKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    func loadWebImage(
        _ urlString: String? = nil,
        placeholderImage: UIImage? = nil,
        indicatorType: IndicatorType? = nil,
        loadFaildImage: UIImage? = nil,
        cacheOriginImage: Bool = false,
        cacheKey: String? = nil,
        maxWidth: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        options: KingfisherOptionsInfo = [],
        progressBlock: DownloadProgressBlock? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
        guard let urlStr = urlString, let url = URL(string: urlStr) else {
            if completionHandler == nil {
                self.image = placeholderImage
            } else {
                completionHandler?(.failure(.requestError(reason: .emptyRequest)))
            }
            return
        }
        
        self.cacheKey = String.isEmpty(cacheKey) ? urlString ?? "" : cacheKey!
        let keyName =  self.cacheKey
        
        let resouce = Kingfisher.KF.ImageResource(downloadURL: url, cacheKey: keyName)
        
        let anyImageModifier = AnyImageModifier { image in
            return image
        }
        
        var totalOptions: KingfisherOptionsInfo = options
//        totalOptions.append(.imageModifier(anyImageModifier))
//        totalOptions.append(.cacheSerializer(DefaultCacheSerializer.default))
        totalOptions.append(.processor(WebPProcessor.default))
        totalOptions.append(.cacheSerializer(WebPSerializer.default))
        totalOptions.append(.scaleFactor(3))
        
        self.kf.indicatorType = indicatorType ?? .none
        self.kf.cancelDownloadTask()
        self.kf.setImage(with: resouce,
                         placeholder: placeholderImage,
                         options: totalOptions,
                         progressBlock: progressBlock) { result in
            switch result {
            case .success(_):
                completionHandler?(result)
            case .failure(let error):
                switch error {
                case .responseError(_):
                    handleErrorRequest()
                default: break
                }
            }
        }
            
        func handleErrorRequest() {
            if self.image == nil, placeholderImage != nil {
                self.image = placeholderImage
            }
        }
    }
    
    /// 全局添加webP格式解析
    static func addWebPParsing() {
        KingfisherManager.shared.defaultOptions += [
            .processor(WebPProcessor.default),
            .cacheSerializer(WebPSerializer.default)
        ]
    }

    /// 最新一次图片下载地址
    private var imageDownloadUrl: String? {
        get { return objc_getAssociatedObject(self, &imageDownloadUrlKey) as? String }
        set { objc_setAssociatedObject(self, &imageDownloadUrlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }

    /// 最新一次原图缓存Key
    private var originImageCacheKey: String? {
        get { return objc_getAssociatedObject(self, &originImageCacheKeyKey) as? String }
        set { objc_setAssociatedObject(self, &originImageCacheKeyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    /// 最新一次小图缓存Key
    private var imageCacheKey: String? {
        get { return objc_getAssociatedObject(self, &imageCacheKeyKey) as? String }
        set { objc_setAssociatedObject(self, &imageCacheKeyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }

    /// 判断是否需要渐变动画
    private func needsTransition(options: KingfisherOptionsInfo) -> Bool {
        for item in options {
            switch item {
            case .transition(let transition):
                switch transition {
                case .none:
                    return false
                #if !os(macOS)
                default:
                    return true
                #endif
                }
            default:
                continue
            }
        }
        return false
    }
    
    /// 展示动画
    private func makeTransition(image: KFCrossPlatformImage, options: KingfisherOptionsInfo, done: @escaping () -> Void) {
        #if !os(macOS)
        // 获取动画类型
        var transition: ImageTransition = .none
        for item in options {
            switch item {
            case .transition(let t):
                transition = t
                break
            default:
                continue
            }
        }
        // 先隐藏加载提示
        UIView.transition(
            with: self,
            duration: 0.0,
            options: [],
            animations: { self.kf.indicator?.stopAnimatingView() },
            completion: { _ in
                /// 参数转换
                var duration: TimeInterval = 0
                var options: AnimationOptions = []
                var animations: ((UIImageView, UIImage) -> Void)? = { $0.image = $1 }
                var completion: ((Bool) -> Void)?
                switch transition {
                case .none:
                    break
                case .fade(let d):
                    duration = d
                    options = .transitionCrossDissolve
                case .flipFromLeft(let d):
                    duration = d
                    options = .transitionFlipFromLeft
                case .flipFromRight(let d):
                    duration = d
                    options = .transitionFlipFromRight
                case .flipFromTop(let d):
                    duration = d
                    options = .transitionFlipFromTop
                case .flipFromBottom(let d):
                    duration = d
                    options = .transitionFlipFromBottom
                case .custom(duration: let d, options: let o, animations: let a, completion: let c):
                    duration = d
                    options = o
                    animations = a
                    completion = c
                }
                /// 展示动画
                UIView.transition(
                    with: self,
                    duration: duration,
                    options: [options, .allowUserInteraction],
                    animations: { animations?(self, image) },
                    completion: { finished in
                        completion?(finished)
                        done()
                    }
                )
            }
        )
        #else
        done()
        #endif
    }
}

