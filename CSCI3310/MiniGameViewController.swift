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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("Minigame Controller")
    print(player?.hp)
    print(monster?.hp)
    print("______")
    monsterView.image = monster?.icon
    progressView.setProgress(1.0, animated: true)
    // Swape Motion
    let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
    for direction in directions {
      let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
      gesture.direction = direction
      self.view.addGestureRecognizer(gesture)
    }
    
    // Shake Motion
    motionManager.accelerometerUpdateInterval = 0.2
    motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
      if let myData = data {
        if myData.acceleration.y > 0.1 {
          self.count = self.count + 1
          print ("shaking \(self.count)")
          
          let hp = Float((self.monster?.hp)!)
          
          let remaining = (hp - Float(self.count)) / hp
          
          print(remaining)
          
          self.progressView.setProgress(remaining, animated: true)
          
          
          if(remaining <= 0){
            //Generate random Item
            let item = db.generateItem()
            
            self.player!.addItem(item)
            
            
            
            print("Inventory")
            print(self.player!.inventory)
            
            self.performSegue(withIdentifier: "minigameBackToMain", sender: self)
          }
        }
      }
    }
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
  
  
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
    if(segue.identifier == "minigameBackToMain"){
      let controller = segue.destination as! MainViewController
      
      controller.player = self.player!
      controller.monster = self.monster
    }
  
  }
 
  
  
  
  
  
}
