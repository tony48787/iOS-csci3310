//
//  MiniGameViewController.swift
//  CSCI3310
//
//  Created by Ka Hong Ngai on 17/5/2017.
//  Copyright © 2017 CSCI3310. All rights reserved.
//

import UIKit
import CoreMotion

class MiniGameViewController: UIViewController {
  
  @IBOutlet weak var monsterView: UIImageView!
  @IBOutlet weak var progressView: UIProgressView!
  
  var count = 0
  var motionManager = CMMotionManager()
  
  var monster : Monster?
  
  var player: Player?
  
  var tbvc: ParentTBViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tbvc = self.tabBarController as? ParentTBViewController
    
    guard let player = tbvc?.player else { return }
    guard let monster = tbvc?.monster else { return }
    
    self.count = 0
    
    monsterView.image = monster.icon
    progressView.setProgress(1.0, animated: true)
    
    // HP Bar Outline
    progressView.layer.borderWidth = 0.5
    progressView.layer.borderColor = UIColor.black.cgColor
    progressView.transform = progressView.transform.scaledBy(x: 1, y: 10)
    
    // Shake Motion
    
    monitorUpdate()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    //De register
    self.motionManager.stopAccelerometerUpdates()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    //register
    monitorUpdate()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    
    
  }
  
  func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case UISwipeGestureRecognizerDirection.right:
        print("Swiped right")
      case UISwipeGestureRecognizerDirection.down:
        print("Swiped down")
      case UISwipeGestureRecognizerDirection.left:
        print("Swiped left")
      case UISwipeGestureRecognizerDirection.up:
        print("Swiped up")
      default:
        break
      }
    }
  }
  
  func monitorUpdate(){
    motionManager.accelerometerUpdateInterval = 0.2
    motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
      if let myData = data {
        if myData.acceleration.y > 0.1 {
            
            self.count = self.count + 1
            print ("shaking \(self.count)")
          
          let hp = Float((self.tbvc?.monster?.hp)!)
          
            let remaining = (hp - Float(self.count)) / hp
          
            print(remaining)
          
            self.progressView.setProgress(remaining, animated: true)
            
            let monsterShakeAnimation = CABasicAnimation(keyPath: "position")
            monsterShakeAnimation.duration = 0.05
            monsterShakeAnimation.repeatCount = 5
            monsterShakeAnimation.autoreverses = true
            monsterShakeAnimation.fromValue = CGPoint(x:self.monsterView.center.x - 10, y:self.monsterView.center.y)
            monsterShakeAnimation.toValue = CGPoint(x:self.monsterView.center.x + 10, y:self.monsterView.center.y)
            self.monsterView.layer.add(monsterShakeAnimation, forKey: "position")
          
          if(remaining <= 0){
            //De register
            self.motionManager.stopAccelerometerUpdates()
            
            //Generate random Item
            let item = db.generateItem()
            
            self.tbvc?.player.addItem(item)
            
            let detailAlert = UIAlertController(title: "Details", message: "New Item", preferredStyle: .alert)
            
            let imageView = UIImageView(image: item.icon)
            
            detailAlert.inputView?.addSubview(imageView)
            
            detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(detailAlert, animated: true, completion: nil)
          }
        }
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    
  }
  
  
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
//   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//   // Get the new view controller using segue.destinationViewController.
//   // Pass the selected object to the new view controller.
//    if(segue.identifier == "minigameBackToMain"){
//      let controller = segue.destination as! MainViewController
//    
//    }
  
  
  
  
  
}
