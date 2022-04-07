//
//  OnboardingViewController.swift
//  MC1 Sunpride
//
//  Created by Nikita Felicia on 07/04/22.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var arrOfOnboardingImage: [UIImage] = [UIImage(named: "logologo.svg")!]
    var slides: [OnboardingSlide] = []
    //var slides3: [OnboardingSlide3] = []
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextBtn.setTitle("START", for: .normal)
            } else {
                nextBtn.setTitle("NEXT", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                slides = [OnboardingSlide(title: "Personalize Reminder, Track Performance, and Reduce Movie Time", description: "", image: UIImage(named: "logologo.svg")),
                          OnboardingSlide(title: "Before you start...", description: "We'd recommend you to do these things", image: UIImage(named: "logologo.svg")),
                          OnboardingSlide(title: "Tell us a little bit about yourself", description: "", image: UIImage(named: "logologo.svg"))
                ]
        
              //  slides3 = [OnboardingSlide3(title: "Tell us a little bit about yourself",
        
                )
                ]
            }
  
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            let controller = storyboard?.instantiateViewController(identifier: "HomeNC") as! UINavigationController
            
            present(controller, animated: true, completion: nil)
        } else {
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
