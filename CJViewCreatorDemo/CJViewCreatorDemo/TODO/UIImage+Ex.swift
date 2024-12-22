//
//  UIImage+Ex.swift
//  WidgetIsland
//
//  Created by julian on 2024/3/14.
//

import Foundation
import UIKit
import AVFoundation

extension UIImage {
    func croppingImage(originalRect:CGRect, multiple: CGFloat) -> UIImage? {
        
        /// 转换裁剪区域为像素
//        let cropRectPixels = originalRect.applying(CGAffineTransform(scaleX: CGFloat(multiple), y: CGFloat(multiple)))
        
        /// 使用 CGImage 来裁剪
        guard let cgImage = cgImage?.cropping(to: originalRect) else { return nil }
        
        return UIImage(cgImage: cgImage, scale: multiple, orientation: imageOrientation)
    }
 }

extension UIImage {
    func heicData(compressionQuality: CGFloat) -> Data? {
        if #available(iOS 17.0, *) {
            return self.heicData()
        } else {
            guard let cgImage = self.cgImage else { return nil }
            let data = NSMutableData()
            guard let destination = CGImageDestinationCreateWithData(data, AVFileType.heic as CFString, 1, nil) else { return nil }
            let options: [NSString: Any] = [kCGImageDestinationLossyCompressionQuality: compressionQuality]
            CGImageDestinationAddImage(destination, cgImage, options as CFDictionary)
            CGImageDestinationFinalize(destination)
            return data as Data
        }
    }
    
    func cropToNonTransparentRegion() -> UIImage? {
            guard let cgImage = self.cgImage else { return nil }
            let width = cgImage.width
            let height = cgImage.height
            
            // 获取像素数据
            guard let data = cgImage.dataProvider?.data,
                  let pixelData = CFDataGetBytePtr(data) else { return nil }
            
            // 定义边界
            var minX = width
            var minY = height
            var maxX: Int = 0
            var maxY: Int = 0
            
            // 遍历像素，找到非透明部分的边界
            for y in 0..<height {
                for x in 0..<width {
                    let pixelIndex = (width * y + x) * 4
                    let alpha = pixelData[pixelIndex + 3]
                    
                    if alpha > 0 {
                        if x < minX { minX = x }
                        if x > maxX { maxX = x }
                        if y < minY { minY = y }
                        if y > maxY { maxY = y }
                    }
                }
            }
            
            // 计算裁剪区域
            let croppedRect = CGRect(x: CGFloat(minX), y: CGFloat(minY), width: CGFloat(maxX - minX + 1), height: CGFloat(maxY - minY + 1))
            
            // 裁剪图像
            guard let croppedCgImage = cgImage.cropping(to: croppedRect) else { return nil }
            return UIImage(cgImage: croppedCgImage, scale: max(self.scale, 1), orientation: self.imageOrientation)
        }
    
    /// 跟另一个图片融合
    func combineWithImage(_ image: UIImage, size: CGSize = CGSize(width: screenWidth, height: screenHeight), rect: CGRect) -> UIImage? {

        // 使用 UIGraphicsImageRenderer 创建绘图上下文
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let combinedImage = renderer.image { context in
            // 在上下文中绘制第一张图片
            self.draw(in: CGRect(origin: .zero, size: size))
            
            // 在上下文中绘制第二张图片（可以设置不同的绘制区域）
            image.draw(in: rect)
        }
        
        return combinedImage
    }
    
    /// 多张图片融合
    func combineImages(images: [UIImage], data: [WallpaperTextModel]) -> UIImage? {
        let size = CGSize(width: screenWidth, height: screenHeight)
        
        // 开启图像上下文
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            
            // 使用混合模式和透明度绘制图像
        self.draw(in: CGRect(origin: .zero, size: size))
        for (index, image) in images.enumerated() {
            if index < data.count {
                let text = data[index]
                image.draw(in: CGRect(x: text.realLeft, y: text.realTop, width: text.realWidth, height: text.realHeight))
            }
        }
            // 获取绘制后的图像
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            
            // 结束图像上下文
            UIGraphicsEndImageContext()
        
        return resultImage
    }
}
