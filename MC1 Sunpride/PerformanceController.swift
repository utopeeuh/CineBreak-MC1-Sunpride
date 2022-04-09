import UIKit

class PerformanceController: UIViewController
{
    var breaksTakenPerHour : Double = 0
    var avgWatchTime : Double = 0
    
    let totalWatchtime = UserPerformance.shared.totalWatchtime
    let breaksTaken = UserPerformance.shared.breaksTaken
    let sessionsDone = UserPerformance.shared.sessionsDone
    let timesOvertime = UserPerformance.shared.timesOvertime
    
    override func viewDidLoad() {
        calculateStats()
    }
    
    private func calculateStats(){
        avgWatchTime = totalWatchtime / Double(sessionsDone)
        breaksTakenPerHour = Double(breaksTaken) / (totalWatchtime/3600)
    }
}
