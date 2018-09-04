//
//  Animation.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 8/31/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit

class Animation: NSObject {
    var circle = UIView()
    var startingPoint  = CGPoint.zero{
        didSet{
            circle.center = startingPoint
        }
    }
    var color = UIColor.white
    var duration =  0.4
    enum mode:Int{
        case  present, dissmiss, pop
    }
    var transitionMode : mode = .present
    
}
extension Animation : UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if transitionMode == .present{
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to){
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                circle = UIView()
                circle.frame = frameForCircle(viewCenter: viewCenter, startPoint:startingPoint , size: viewSize)
                circle.layer.cornerRadius =  circle.frame.height/2
                circle.center = startingPoint
                circle.backgroundColor = color
                circle.transform = CGAffineTransform(scaleX: 0.001 , y: 0.001 )
                containerView.addSubview(circle)
                
                presentedView.center = startingPoint
                presentedView.transform = CGAffineTransform(scaleX: 0.001 , y: 0.001 )
                presentedView.alpha = 0
                containerView.addSubview(presentedView)
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform.identity
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha  = 1
                    presentedView.center = viewCenter
                }) { (success) in
                    transitionContext.completeTransition(success )
                    
                }
                
            }
        }
        else{
            let trancisionModeKy = ( transitionMode == mode.pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            if let returningView = transitionContext.view(forKey: trancisionModeKy){
                let viewCenter = returningView.center
                let viewSize =  returningView.frame.size
                circle.frame = frameForCircle(viewCenter: viewCenter, startPoint: startingPoint, size:viewSize )
                circle.layer.cornerRadius = circle.frame.height/2
                circle.center = startingPoint
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform =  CGAffineTransform(scaleX: 0.001 , y: 0.001 )
                    returningView.transform =   CGAffineTransform(scaleX: 0.001 , y: 0.001 )
                    returningView.center = self.startingPoint
                    returningView.alpha = 0
                    if self.transitionMode ==  mode.pop{
                        containerView.insertSubview(returningView, belowSubview: returningView)
                        containerView.insertSubview(self.circle, belowSubview: returningView)
                    }
                }) { (success) in
                    returningView.center = viewCenter
                    returningView.removeFromSuperview()
                    self.circle.removeFromSuperview()
                    transitionContext.completeTransition(success )
                }
            }
        }
    }
    func frameForCircle( viewCenter : CGPoint, startPoint : CGPoint, size : CGSize)-> CGRect{
        let  xLenght = fmax(startingPoint.x , size.width - startPoint.x)
        let  yLenght = fmax(startingPoint.y , size.height - startPoint.y)
        let offsetVector = sqrt(xLenght*xLenght + yLenght*yLenght)*2
        let size = CGSize(width: offsetVector, height: offsetVector)
        return CGRect(origin: CGPoint.zero, size: size)
    }
}
