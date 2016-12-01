//
//  QuintupleVC.swift
//  Pods
//
//  Created by zaid.pathan on 01/12/16.
//
//
// ChildVC : https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/ImplementingaContainerViewController.html
import UIKit

public enum VCType{
    case centerVC
    case rightVC
    case topVC
    case leftVC
    case bottomVC
}

fileprivate enum ScrollDirection{
    case unknown
    case right
    case top
    case left
    case bottom
}

open class QuintupleVC: UIViewController {
    static open let shared = QuintupleVC()
    fileprivate var centerVC:UIViewController?
    fileprivate var rightVC:UIViewController?
    fileprivate var topVC:UIViewController?
    fileprivate var leftVC:UIViewController?
    fileprivate var bottomVC:UIViewController?
    fileprivate var panGesture:UIPanGestureRecognizer?
    fileprivate var shouldShowLogs:Bool = true
    fileprivate var currentScrollingDirection:ScrollDirection?
    public var currentVisibleVC:VCType = .centerVC
    
    //----------------------------------------
    //MARK:- VC lifecyle
    //----------------------------------------
    public convenience init(withCenterVC centerVC:UIViewController?,rightVC:UIViewController?,topVC:UIViewController?,leftVC:UIViewController?,bottomVC:UIViewController?) {
        self.init()
        self.centerVC   = centerVC
        self.rightVC    = rightVC
        self.topVC      = topVC
        self.leftVC     = leftVC
        self.bottomVC   = bottomVC
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        add(childVC: centerVC, vcType: .centerVC)
        add(childVC: rightVC, vcType: .rightVC)
        add(childVC: topVC, vcType: .topVC)
        add(childVC: leftVC, vcType: .leftVC)
        add(childVC: bottomVC, vcType: .bottomVC)
        showVC(vcType: currentVisibleVC)
        addPanGesture()
        // Do any additional setup after loading the view.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //----------------------------------------
    //MARK:- Custom methods
    //----------------------------------------
    fileprivate func addPanGesture(){
        if let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(gesture:))) as? UIPanGestureRecognizer{
            panGesture.maximumNumberOfTouches = 1
            view.addGestureRecognizer(panGesture)
        }
    }
    
    @objc fileprivate func panGestureAction(gesture:UIPanGestureRecognizer){
        switch gesture.state {
        case .began:
            handlePanBegan(gesture: gesture)
        case .changed:
            handlePanChanged(gesture: gesture)
        case .ended:
            handlePanEnded(gesture: gesture)
        case .failed:
            handlePanEnded(gesture: gesture)
        case .cancelled:
            handlePanEnded(gesture: gesture)
        default:
            handlePanEnded(gesture: gesture)
        }
    }
    
    fileprivate func handlePanBegan(gesture:UIPanGestureRecognizer){
        debugPrint("Began : \(gesture.translation(in: self.view))")
    }
    
    fileprivate func handlePanChanged(gesture:UIPanGestureRecognizer){
        debugPrint("Changed : \(gesture.translation(in: self.view))")
        
        if let currentScrollingDirection = currentScrollingDirection{
        
        }else{
            let gesturePoints = gesture.translation(in: self.view)
            
            // ▶︎ Direction
            if gesturePoints.x > QVCConstants.screenWidth/5{
                debugPrint("▶︎")
                currentScrollingDirection = .right
//                if currentVisibleVC == .rightVC{
//                    showVC(vcType: .centerVC)
//                }else if currentVisibleVC == .centerVC{
//                    showVC(vcType: .leftVC)
//                }
                // ▼ Direction
            }else if gesturePoints.y > QVCConstants.screenHeight/7{
                debugPrint("▼")
                currentScrollingDirection = .bottom
//                if currentVisibleVC == .bottomVC{
//                    showVC(vcType: .centerVC)
//                }else if currentVisibleVC == .centerVC{
//                    showVC(vcType: .topVC)
//                }
                // ◀︎ Direction
            }else if gesturePoints.x < -QVCConstants.screenWidth/5{
                debugPrint("◀︎")
                currentScrollingDirection = .left
//                if currentVisibleVC == .leftVC{
//                    showVC(vcType: .centerVC)
//                }else if currentVisibleVC == .centerVC{
//                    showVC(vcType: .rightVC)
//                }
                
                // ▲ Direction
            }else if gesturePoints.y < -QVCConstants.screenHeight/7{
                debugPrint("▲")
                currentScrollingDirection = .top
//                if currentVisibleVC == .topVC{
//                    showVC(vcType: .centerVC)
//                }else if currentVisibleVC == .centerVC{
//                    showVC(vcType: .bottomVC)
//                }
                
            }else{
                //            debugPrint("●")
            }
        }
        
    }
    
    fileprivate func handlePanEnded(gesture:UIPanGestureRecognizer){
        debugPrint("Ended : \(gesture.translation(in: self.view))")
        
            if currentScrollingDirection == .right{
                if currentVisibleVC == .rightVC{
                    showVC(vcType: .centerVC)
                }else if currentVisibleVC == .centerVC{
                    showVC(vcType: .leftVC)
                }
            }else if currentScrollingDirection == .bottom{
                if currentVisibleVC == .bottomVC{
                    showVC(vcType: .centerVC)
                }else if currentVisibleVC == .centerVC{
                    showVC(vcType: .topVC)
                }
            }else if currentScrollingDirection == .left{
                if currentVisibleVC == .leftVC{
                    showVC(vcType: .centerVC)
                }else if currentVisibleVC == .centerVC{
                    showVC(vcType: .rightVC)
                }
            }else if currentScrollingDirection == .top{
                if currentVisibleVC == .topVC{
                    showVC(vcType: .centerVC)
                }else if currentVisibleVC == .centerVC{
                    showVC(vcType: .bottomVC)
                }
            }else{
            
            }
            
        currentScrollingDirection = nil
    }
    
    fileprivate func add(childVC:UIViewController?,vcType:VCType){
        if let childVC = childVC{
            addChildViewController(childVC)
            childVC.view.frame = view.frame
            view.addSubview(childVC.view)
            childVC.didMove(toParentViewController: self)
        }else{
            if shouldShowLogs{
                debugPrint("\(vcType) not found")
            }
        }
    }
    
    fileprivate func updateConstraints(ofChildVC:UIViewController,topConstant:CGFloat,leadingConstant:CGFloat){
        if let superView = ofChildVC.view.superview{
            ofChildVC.view.removeFromSuperview()
            superView.addSubview(ofChildVC.view)
        }
        
        ofChildVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: ofChildVC.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: QVCConstants.screenWidth)
        let heightConstraint = NSLayoutConstraint(item: ofChildVC.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: QVCConstants.screenHeight)
        
        debugPrint(QVCConstants.screenWidth)
        debugPrint(QVCConstants.screenHeight)
        
        let topConstraint = NSLayoutConstraint(
            item: ofChildVC.view,
            attribute: NSLayoutAttribute.topMargin,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: NSLayoutAttribute.topMargin,
            multiplier: 1,
            constant: topConstant)
        
        let leadingConstraint = NSLayoutConstraint(
            item: ofChildVC.view,
            attribute: NSLayoutAttribute.leading,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: NSLayoutAttribute.leading,
            multiplier: 1,
            constant: leadingConstant)
        view.addConstraints([widthConstraint,heightConstraint,topConstraint,leadingConstraint])
    }
    
    fileprivate func showVC(vcType:VCType){
        currentVisibleVC = vcType
        
        var centerVCTopConstant:CGFloat = 0
        var centerVCLeadingConstant:CGFloat = 0
        var rightVCTopConstant:CGFloat = 0
        var rightVCLeadingConstant:CGFloat = 0
        var topVCTopConstant:CGFloat = 0
        var topVCLeadingConstant:CGFloat = 0
        var leftVCTopConstant:CGFloat = 0
        var leftVCLeadingConstant:CGFloat = 0
        var bottomVCTopConstant:CGFloat = 0
        var bottomVCLeadingConstant:CGFloat = 0
    
        
        if vcType == .centerVC {
            centerVCTopConstant = 0
            centerVCLeadingConstant = 0
            rightVCTopConstant = 0
            rightVCLeadingConstant = QVCConstants.screenWidth
            topVCTopConstant = -QVCConstants.screenHeight
            topVCLeadingConstant = 0
            leftVCTopConstant = 0
            leftVCLeadingConstant = -QVCConstants.screenWidth
            bottomVCTopConstant = QVCConstants.screenHeight
            bottomVCLeadingConstant = 0

        }else if vcType == .rightVC {
            centerVCTopConstant = 0
            centerVCLeadingConstant = -QVCConstants.screenWidth
            rightVCTopConstant = 0
            rightVCLeadingConstant = 0
            topVCTopConstant = -QVCConstants.screenHeight
            topVCLeadingConstant = 0
            leftVCTopConstant = 0
            leftVCLeadingConstant = -QVCConstants.screenWidth
            bottomVCTopConstant = QVCConstants.screenHeight
            bottomVCLeadingConstant = 0
        }else if vcType == .topVC {
            centerVCTopConstant = QVCConstants.screenHeight
            centerVCLeadingConstant = 0
            rightVCTopConstant = 0
            rightVCLeadingConstant = QVCConstants.screenWidth
            topVCTopConstant = 0
            topVCLeadingConstant = 0
            leftVCTopConstant = 0
            leftVCLeadingConstant = -QVCConstants.screenWidth
            bottomVCTopConstant = QVCConstants.screenHeight
            bottomVCLeadingConstant = 0
        }else if vcType == .leftVC {
            centerVCTopConstant = 0
            centerVCLeadingConstant = QVCConstants.screenWidth
            rightVCTopConstant = 0
            rightVCLeadingConstant = QVCConstants.screenWidth
            topVCTopConstant = -QVCConstants.screenHeight
            topVCLeadingConstant = 0
            leftVCTopConstant = 0
            leftVCLeadingConstant = 0
            bottomVCTopConstant = QVCConstants.screenHeight
            bottomVCLeadingConstant = 0
        }else if vcType == .bottomVC {
            centerVCTopConstant = -QVCConstants.screenHeight
            centerVCLeadingConstant = 0
            rightVCTopConstant = 0
            rightVCLeadingConstant = QVCConstants.screenWidth
            topVCTopConstant = -QVCConstants.screenHeight
            topVCLeadingConstant = 0
            leftVCTopConstant = 0
            leftVCLeadingConstant = -QVCConstants.screenWidth
            bottomVCTopConstant = 0
            bottomVCLeadingConstant = 0
        }else{
            
        }

        if let centerVC = centerVC{
            updateConstraints(ofChildVC: centerVC, topConstant: centerVCTopConstant, leadingConstant: centerVCLeadingConstant)
        }
        
        if let rightVC = rightVC{
            updateConstraints(ofChildVC: rightVC, topConstant: rightVCTopConstant, leadingConstant: rightVCLeadingConstant)
        }
        
        if let topVC = topVC{
            updateConstraints(ofChildVC: topVC, topConstant: topVCTopConstant, leadingConstant: topVCLeadingConstant)
        }
        
        if let leftVC = leftVC{
            updateConstraints(ofChildVC: leftVC, topConstant: leftVCTopConstant, leadingConstant: leftVCLeadingConstant)
        }
        
        if let bottomVC = bottomVC{
            updateConstraints(ofChildVC: bottomVC, topConstant: bottomVCTopConstant, leadingConstant: bottomVCLeadingConstant)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func remove(childVC:UIViewController){
        childVC.willMove(toParentViewController: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParentViewController()
    }
}
