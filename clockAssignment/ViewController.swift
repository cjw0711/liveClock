//
//  ViewController.swift
//  clockAssignment
//
//  Created by user242949 on 2/5/23
//

import AVFoundation
import UIKit


class ViewController: UIViewController, AVAudioPlayerDelegate
{
    var countDownTimer: Timer?;
    var endTime: Date?;
    var musicPlayer: AVAudioPlayer!;
    @IBOutlet   var backgroundImage:UIImageView!;
    @IBOutlet   var currentTimeLabel: UILabel!;
    @IBOutlet   var countDownTimeLabel: UILabel!;
    @IBOutlet   var datePicker:UIDatePicker!;
    @IBOutlet   var startButton:UIButton!;
    @IBOutlet   var stopButton:UIButton!;
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.datePicker.isHidden = false;
        self.countDownTimeLabel.isHidden = true;
        self.stopButton.isHidden = true;
        self.startButton.isHidden = false;
        self.UpdateCurrentTime()
        Timer.scheduledTimer(timeInterval:1.0, target:self, selector: #selector(self.UpdateCurrentTime), userInfo:nil, repeats: true);
        let path = Bundle.main.path(forResource: "rainforest.mp3", ofType:nil)!;
        do
        {
            self.musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path));
            self.musicPlayer.delegate = self;
        }
        catch{}
    }
   
    @IBAction func startTimer()
    {
        self.datePicker.isHidden = true;
        self.countDownTimeLabel.isHidden = false;
        self.startButton.isHidden = true;
        self.stopButton.isHidden = false;
        
        let currentTime: Date = Date()
        let timeLength: TimeInterval = self.datePicker.countDownDuration;
        let timeStop: Date = Date.init(timeInterval: timeLength, since: currentTime);
        let dinterval: DateInterval = DateInterval.init(start: currentTime, end: timeStop);
        self.endTime = timeStop;
        self.countDownTimeLabel.text = formatCountDown(currentInterval: dinterval)
        countDownTimer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(self.countDownTime), userInfo:nil, repeats: true);
    }
    @objc func formatCountDown( currentInterval: DateInterval) -> String
    {
        let componentFormat: DateComponentsFormatter = DateComponentsFormatter();
        componentFormat.unitsStyle = .positional
        componentFormat.zeroFormattingBehavior = .pad;
        componentFormat.allowedUnits = [.hour, .minute, .second];
    
        return componentFormat.string(from: currentInterval.duration)!
    }
    
    @objc func countDownTime(_sender: UIButton?)
    {
        let currentTime: Date = Date()
        
        if (currentTime > self.endTime!)
        {
            self.timerEnd();
        }
        else
        {
            let interval: DateInterval = DateInterval.init(start: currentTime, end: self.endTime!);
            self.countDownTimeLabel.text = formatCountDown(currentInterval: interval)
        }
    }
    @objc func UpdateCurrentTime()
    {
        let date = Date();
        let dateFormat: DateFormatter = DateFormatter();
        dateFormat.dateFormat = "E, d MMM Y HH:mm:ss";
        self.currentTimeLabel.text = dateFormat.string(from: date);
        let timeFormat: DateFormatter = DateFormatter();
        timeFormat.dateFormat = "HH";

        let hour:String = timeFormat.string(from: date)
      
        if (Int(hour)! < 12)
        {
            self.backgroundImage.image = UIImage(named: "day");
        }
        else
        {
            self.backgroundImage.image = UIImage(named: "night");
        }

    }
    @IBAction func stopButton(_sender: UIButton?)
    {
        countDownTimer?.invalidate();
        
        self.datePicker.isHidden = false;
        self.countDownTimeLabel.isHidden = true;
        self.startButton.isHidden = false;
        self.stopButton.isHidden = true;
     
        if (_sender != nil)
        {
            self.musicPlayer.stop();
        }
    }
    func musicDone(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        self.stopButton(_sender: nil);
    }
    
    func timerEnd()
    {
        self.musicPlayer.play();
        self.datePicker.isHidden = true;
        self.countDownTimeLabel.isHidden = true;
        self.startButton.isHidden = true;
        self.stopButton.isHidden = false;
    }
}

