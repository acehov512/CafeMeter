
import UIKit
import SwiftUI

class ViewController: UIViewController {
    @Namespace private var animation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let onbScreen = LaunchView(namespace: animation)
        let hostContr = UIHostingController(rootView: onbScreen)
        
        addChild(hostContr)
        view.addSubview(hostContr.view)
        hostContr.didMove(toParent: self)
        
        hostContr.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostContr.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostContr.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostContr.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostContr.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func rootViewC(_ viewController: UIViewController) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = viewController
        }
    }
    
    func openStart() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let onboardingScreen = CoordinatorView()
            let hostingController = UIHostingController(rootView: onboardingScreen)
            self.rootViewC(hostingController)
        }
    }
    
    func helperString(mainSting: String, deviceID: String, advertaiseID: String, appsflId: String) -> (String) {
        var str = ""
        
        str = "\(mainSting)?hhft=\(deviceID)&ndgs=\(advertaiseID)&abst=\(appsflId)"
        
        return str
    }
    
    func openFinish(string: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            for child in self.children {
                if child is AppViewController {
                    return
                }
            }
            guard !string.isEmpty else { return }
            let secondController = AppViewController(url: string)
            self.addChild(secondController)
            secondController.view.frame = self.view.bounds
            secondController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(secondController.view)
            secondController.didMove(toParent: self)
        }
    }
}
