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
  @IBOutlet weak var timerTextView: UILabel!
  @IBOutlet weak var timerProgressView: UIProgressView!
  @IBOutlet weak var hpTextView: UILabel!
  
  @IBOutlet weak var monsterNameTextView: UILabel!
  
  
  var count = 0
  var readyTimeCount = 3
  var gameTimeCount = 30
  var motionManager = CMMotionManager()
  
  var monster : Monster?
  
  var player: Player?
  
  var tbvc: ParentTBViewController?
  
  var timer: Timer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tbvc = self.tabBarController as? ParentTBViewController
  
    guard let monster = tbvc?.monster else { return }
    
    self.count = 0
    
    monsterNameTextView.text = monster.name
    hpTextView.text = "\(monster.hp) / \(monster.hp)"
    
    
    monsterView.image = monster.icon
    progressView.setProgress(1.0, animated: true)
    
    // HP Bar Outline
    progressView.layer.borderWidth = 0.5
    progressView.layer.borderColor = UIColor.black.cgColor
    progressView.transform = progressView.transform.scaledBy(x: 1, y: 10)
    
  
  }
  
  override func viewWillAppear(_ animated: Bool) {
    timer?.invalidate()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    //De register
    self.motionManager.stopAccelerometerUpdates()
    timer?.invalidate()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    //register
    self.count = 0
    self.readyTimeCount = 3
    self.gameTimeCount = 30
    monitorUpdate()
    timer = Timer.scheduledTimer(timeInterval: 1,
                                 target: self, selector: #selector(ready), userInfo: nil, repeats: true)
    timer?.fire()
    
    updateTimer(self.readyTimeCount, 3)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    
    
  }
  
  func updateTimer(_ remaining: Int, _ total: Int){
    let progress = Float(remaining) / Float(total)
    timerProgressView.setProgress(progress, animated: true)
    timerTextView.text = "\(remaining)";
  }
  
  @objc func ready(){
    self.readyTimeCount -= 1
    //Update UI
    updateTimer(self.readyTimeCount, 3)
    if(self.readyTimeCount == 0){
      timer?.invalidate()
      timer = Timer.scheduledTimer(timeInterval: 1,
                                   target: self, selector: #selector(go), userInfo: nil, repeats: true)
      timer?.fire()
      // Shake Motion
      monitorUpdate()
    }
  }
  
  @objc func go(){
    self.gameTimeCount -= 1
    //Update UI
    updateTimer(self.gameTimeCount, 30)
    if(self.gameTimeCount == 0){
      timer?.invalidate()
      timer = nil
      //Force end game
      alert("Time's Up!", "We are sorry to inform you that you are not qualified to get this item!", UIImage(named: "egg")!)
    }
  }
  
  func monitorUpdate(){
    motionManager.accelerometerUpdateInterval = 0.2
    motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
      if let myData = data {
        if myData.acceleration.y > 0.1 {
          self.count = self.count + 1
          //print ("shaking \(self.count)")
          
          let hp = Float((self.tbvc?.monster?.hp)!)
          
          let remaining = (hp - Float(self.count * (self.tbvc?.player.dmg)!)) / hp
          
          self.hpTextView.text = "\((hp - Float(self.count * (self.tbvc?.player.dmg)!))) / \(hp)"
          
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
            
            self.tbvc?.player.updateStatus()
            
            self.alert("You won!", "Check your Inventory.", UIImage(named: "success")!)
            
          }
        }
      }
    }
  }
  
  func alert(_ title: String, _ message: String, _ image: UIImage){
    let detailAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 200, height: 100))
    imageView.image = image
    detailAlert.view.addSubview(imageView)
    
    detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
      (alert: UIAlertAction!) in
      self.navigationController?.popViewController(animated: true)
    }))
    self.present(detailAlert, animated: true, completion: nil)
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
