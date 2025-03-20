import UIKit

protocol StoryboardInstantiable: NSObjectProtocol {
    associatedtype T
    static var defaultFileName: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> T
}

extension StoryboardInstantiable where Self: UIViewController {
    static var defaultFileName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let fileName = defaultFileName
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        guard let vc = storyboard.instantiateInitialViewController() as? Self else {
            
            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard with name \(fileName)")
        }
        return vc
    }
}

//protocol Storyboarded {
//    static func instatite() -> Self
//}

//extension Storyboarded where Self: UIViewController {
//    static func instantiate() -> Self {
//        let fullName = NSStringFromClass(self)
//        let className = fullName.components(separatedBy: ".")[1]
//        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        
//        return storyBoard.instantiateViewController(withIdentifier: className) as! Self
//    }
//}
