//
//  UIFont+Ex.swift
//  WidgetIsland
//
//  Created by julian on 2024/2/21.
//

import Foundation
import UIKit

extension UIFont {
    /// ***********平方字体****************
    public class func pingFangSC(ofSize size: CGFloat) -> UIFont {
        return pingFangSCRegular(ofSize: size)
    }

    public class func pingFangSCUltralight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Ultralight", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    public class func pingFangSCRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    public class func pingFangSCLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    public class func pingFangSCMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    public class func pingFangSCSemibold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    public class func pingFangSCThin(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Thin", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

/**
*  闭包的调用，U是这个动作约定返回到handle里面的back值。使用方式为，在需要约定回调返回的地方创建一个LYAction，
*  需要回调的地方调用handle方法去实现回调，handle方法中的参数第一个值会原封不动的返回到handle的回调block中，只是这个
*  值是weak的，可以放心使用，不需要担心引用循环。甚至可以直接将这个值写为self：
*  class A: NSObject {

    let action = LYAction<A>()
    
    func userTouchBack() -> Void {
        action.doHandle(self)
    }
    
*  }

*  class B: NSObject {

    let a = A()
    override init() {
        a.action.handle(self) { (self, backA) in
            print(self.a)
        }
    }

*  }
*/

open class LYAction<U> {
   
   public private(set) weak var target: AnyObject? = nil
   
   public private(set) var handleBlock: ((_ target: AnyObject, _ back: U?) -> Void)? = nil
   
   public var isValid: Bool {
       (self.target != nil) && (self.handleBlock != nil)
   }
   
   public init() {}
   
   public func handle<T: AnyObject>(_ target: T, _ handle: @escaping ((_ target: T, _ back: U?) -> Void)) {
       self.target = target
       self.handleBlock = { (t, p) in
           guard let t = t as? T else {
               return
           }
           handle(t, p)
       }
   }
   
   final public func doHandle(_ res: U? = nil) -> Void {
       guard let t = target else {
           return
       }
       self.handleBlock?(t, res)
   }
}

/// 抽象归一化能力
public protocol LayoutNormalizationEnable {
    
    /// 标准的屏幕宽度
    static var standardWidth: CGFloat {get}
    
    /// 标准的屏幕高度
    static var standardHeight: CGFloat {get}
    
    /// 在当前设备中，最细的线条宽度
    static var minLine: CGFloat {get}
    
    /// 以设计图宽度为标准返回合适的值
    /// - Parameter x: <#x description#>
    static func x(_ x: CGFloat) -> CGFloat
    
    /// 以设计图高度为标准返回合适的值
    /// - Parameter y: <#y description#>
    static func y(_ y: CGFloat) -> CGFloat
    
    /// 返回适合当前屏幕布局的最合适的值
    /// - Parameter v: <#v description#>
    static func solid(_ v: CGFloat) -> CGFloat
    
    static func solidCeil(_ v: CGFloat) -> CGFloat
    
    static func solidFloor(_ v: CGFloat) -> CGFloat
}

public extension LayoutNormalizationEnable {
    private static var screenScale: CGFloat {
        UIScreen.main.scale
    }
    
    private static var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    private static var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }
    
    static func x(_ x: CGFloat) -> CGFloat {
        return (screenWidth / standardWidth * x)
    }
    
    static func y(_ y: CGFloat) -> CGFloat {
        return (screenHeight / standardHeight * y)
    }
    
    static func solidCeil(_ v: CGFloat) -> CGFloat {
        ceil(v * screenScale) / screenScale
    }
    
    static func solid(_ v: CGFloat) -> CGFloat {
        round(v * screenScale) / screenScale
    }
    
    static func solidFloor(_ v: CGFloat) -> CGFloat {
        floor(v * screenScale) / screenScale
    }
    
    static var minLine: CGFloat {
        get {
            return (screenScale == 3) ? (2 / screenScale) : (1 / screenScale)
        }
    }
}
