import UIKit

class PerformanceController: UIViewController
{
    var totalWatchtime : Double!
    var breaksTaken : Double!
    var sessionsDone : Double!
    var timesOvertime : Double!
    
    var breaksTakenPerHour : String = "0"
    var avgWatchTime : String = "0"
    
    @IBOutlet weak var watchText: UILabel!
    @IBOutlet weak var breaksText: UILabel!
    @IBOutlet weak var avgWatchText: UILabel!
    @IBOutlet weak var overtimeText: UILabel!
    
    @IBOutlet weak var lastWeekLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    private func loadData(){
        UserPerformance.shared.updateWeeklyStats()
        
        totalWatchtime = UserPerformance.shared.totalWatchtime/60
        breaksTaken = UserPerformance.shared.breaksTaken
        sessionsDone = UserPerformance.shared.sessionsDone
        timesOvertime = UserPerformance.shared.timesOvertime
        
        calculateStats()
        
        watchText.text = "\(roundDouble(x: totalWatchtime)) mins"
        breaksText.text = "\(breaksTakenPerHour) per hour"
        overtimeText.text = "\(roundDouble(x: timesOvertime)) time(s)"
        avgWatchText.text = "\(avgWatchTime) mins"
        
        let lastWeekTime = UserPerformance.shared.getLastWeekStat()
        lastWeekLabel.text = "\(roundDouble(x: lastWeekTime)) minutes"
    }
    
    private func calculateStats(){
        if totalWatchtime != 0{
            avgWatchTime = roundDouble(x:(totalWatchtime / Double(sessionsDone)))
            breaksTakenPerHour = roundDouble(x:( (totalWatchtime/3600)/Double(breaksTaken)))
        }
    }
        
    
    private func roundDouble(x: Double) -> String{
        return x == 0 || x < 0.1 ? "0" : String(format: "%.1f", x)
    }
}
