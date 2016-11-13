//
//  ViewController.swift
//  Slark
//
//  Created by ideapress on 2016/11/12.
//  Copyright © 2016年 ideapress. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDelegate {
    
    var pageControl: UIPageControl?
    var colorViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.init(red: 0xF9/255, green: 0xF9/255, blue: 0xF9/255, alpha: 1)
        
        let colors:[UIColor] = [.red, .yellow, .blue, .green]
        for i in 0..<3 {
            let colorViewController = UIViewController.init()
            colorViewController.view.backgroundColor = colors[i]
            colorViewController.view.bounds = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 150)
            colorViewControllers.append(colorViewController)
        }
        
        
        
        
        let pageView = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey:0])
        
        pageView.delegate = self
        pageView.dataSource = self
        
        // display it's view on our view controller
        pageView.willMove(toParentViewController: self)
        self.addChildViewController(pageView)
        
        let y = Int(UIApplication.shared.statusBarFrame.height) + Int((self.navigationController?.navigationBar.frame.height)!)
        
        pageView.view.frame = CGRect.init(x: 0, y: CGFloat.init(y), width: self.view.frame.width, height: 150)
        
        self.view.addSubview(pageView.view)
        pageView.didMove(toParentViewController: self)
        
        // set the first view controller for pageView
        
        pageView.setViewControllers([colorViewControllers[0]], direction: .forward, animated: false, completion: nil)
        
        // now setup the pageControl
        self.pageControl = UIPageControl.init()
        self.pageControl?.frame = CGRect.init(x: 0, y: CGFloat(y + 130), width: self.view.bounds.width, height: 20)
        self.pageControl?.numberOfPages = self.colorViewControllers.count
        
        self.view.addSubview(self.pageControl!)
        
        
        //
        let stackView = UIStackView.init(frame: CGRect.init(x: 0, y: y + 150, width: Int(self.view.bounds.width), height: 80))
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        let titles = ["宠物美容", "宠物寄样", "宠物洗澡", "宠物护理"]
        let backgrounds = [UIColor.init(red: 0xff / 255, green: 0xb9 / 255, blue: 0x7d / 255, alpha: 1), UIColor.init(red: 0xff / 255, green: 0xab / 255, blue: 0x97 / 255, alpha: 1),
            UIColor.init(red: 0xab / 255, green: 0xd7 / 255, blue: 0xff / 255, alpha: 1)
           ,UIColor.init(red: 0xa3 / 255, green: 0xb6 / 255, blue: 0xff / 255, alpha: 1)]
        
        for i in 0..<4 {
            let view = UIButton.init()
     
            view.backgroundColor = .white
            
            view.addGestureRecognizer(            UITapGestureRecognizer.init(target: self, action: #selector(ViewController.selectService(_:))))

            
            let header = UIView.init(frame: CGRect.init(x: view.center.x, y: 18, width: 30, height: 30))
            
            let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 21, height: 21))
            imageView.center = CGPoint.init(x: header.center.x, y: header.center.y / 2)
            imageView.image = UIImage.init(named: "\(i+1)")

            header.addSubview(imageView)
            
            
            header.center = CGPoint.init(x: self.view.bounds.width / 8, y: 18 + 15)
            header.backgroundColor = backgrounds[i]
            let title = UILabel.init(frame: CGRect.init(x: 0, y: 18 + 30, width: self.view.bounds.width / 4, height: 30))
            title.text = titles[i]
            title.textAlignment = .center
            view.addSubview(title)
            title.font = UIFont.init(name: "Helvetica", size: 11)
            header.layer.cornerRadius = 15
            
            view.addSubview(header)
            stackView.addArrangedSubview(view)
        }
        
        self.view.addSubview(stackView)
        
        let detailHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 54 + 150 + 80 + 20, width: self.view.bounds.width, height: 40))
        
        let detailTitleLabel = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: detailHeaderView.bounds.width - 15, height: detailHeaderView.bounds.height))
        
        detailHeaderView.addSubview(detailTitleLabel)
        
        detailHeaderView.backgroundColor = .white
        detailTitleLabel.text = "服务介绍"
        detailTitleLabel.font = UIFont.systemFont(ofSize: 15)

        
        let borderBottom = UIView.init(frame: CGRect.init(x: 0, y: 79/2, width: detailHeaderView.bounds.width, height: 0.5))
        borderBottom.backgroundColor = UIColor.init(red: 0xdf / 255, green: 0xdf / 255, blue: 0xdf / 255, alpha: 1)
        detailHeaderView.addSubview(borderBottom)
        self.view.addSubview(detailHeaderView)

        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        
    }
    
    func selectService(_ button: UIButton) {
        print("Wow!")
        let process = ProcessController.init()
        process.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(process, animated: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let index = self.colorViewControllers.index(of: pageViewController.viewControllers!.first!)
        self.pageControl?.currentPage = index!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController:UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.colorViewControllers.index(of: viewController) else {
            return nil
        }
        
        if index + 1 >= self.colorViewControllers.count {
            return self.colorViewControllers.first
        } else {
            return self.colorViewControllers[index + 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.colorViewControllers.index(of: viewController) else {
            return nil
        }
        
        if index - 1 < 0 {
            return self.colorViewControllers.last
        } else {
            return self.colorViewControllers[index - 1]
        }
    }
}

