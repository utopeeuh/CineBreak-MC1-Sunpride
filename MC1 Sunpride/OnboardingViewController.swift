import Foundation
import UIKit

class OnboardingViewController: UIViewController
{
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var arrOfOnboardingImage: [UIImage] = [UIImage(named: "logologo.svg")!]
    var slides: [OnboardingSlide] = []
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextBtn.setTitle("Start", for: .normal)
            } else {
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                slides = [OnboardingSlide(title: "", description: "", image: UIImage(named: "onboardingPage1.png")),
                          OnboardingSlide(title: "Before you start...", description: "We'd recommend you to do these things", image: UIImage(named: "onboardingPage2.png")),
                          OnboardingSlide(title: "And after you do the previous steps...", description: "", image: UIImage(named: "onboardingPage3.png"))
                ]
            
    }
  
    
    @IBAction func nextBtnClicked(_ sender: UIButton)
    {
        if (currentPage == slides.count - 1)
        {
            let vc = storyboard!.instantiateViewController(identifier: "dashboard")
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
            
            notificationRequestVC.modalPresentationStyle = .fullScreen
            // vc.present(notificationRequestVC, animated: true)
            
            let vcSetup = UIStoryboard(name: "OnboardingSetup", bundle: nil).instantiateViewController(withIdentifier: "onboardingSetup")
            vcSetup.modalPresentationStyle = .fullScreen
            vc.present(notificationRequestVC, animated: true) {
                notificationRequestVC.present(vcSetup, animated: true)
            }
            
            
        }
        else
        {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
