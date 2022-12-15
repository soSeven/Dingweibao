//
//  HomeViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/27.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import SnapKit
import SwifterSwift
import RxSwift
import RxCocoa

protocol HomeViewControllerDelegate: AnyObject {
    
    func homeShowUserController(controller: HomeViewController)
    func homeShowPayController(controller: HomeViewController)
    func homeShowCircleInfoController(controller: HomeViewController, circleModel: CircleListCellViewModel?)
}

class HomeViewController: ViewController {
    
    var viewModel: HomeViewModel!
    
    private let locationModel = LocationModel()
    
    private var currentListModel: CircleListCellViewModel?
    
    weak var delegate: HomeViewControllerDelegate?
    
    lazy var mapView: MAMapView = {
        let mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsCompass = false
        mapView.zoomLevel = self.zoomLevel
        return mapView
    }()
    
    lazy var locationManager: AMapLocationManager = {
        let l = AMapLocationManager()
        l.delegate = self
        l.pausesLocationUpdatesAutomatically = false
        l.allowsBackgroundLocationUpdates = true
        l.locatingWithReGeocode = true
        return l
    }()
    
    private let navBar = HomeNavBar()
    private let usersView = HomeUsersView()
    
    private let requestUserList = PublishRelay<CircleListCellViewModel?>()
    
    let removeCircle = PublishSubject<CircleListCellViewModel>()
    let addCircle = PublishSubject<CircleListCellViewModel>()
    
    let currentSelectedUserId = BehaviorRelay<(String?, String?)>(value: (nil, nil))
    var currentUserId = ""
    var currentUser: HomeUserItemCellViewModel?
    
    var mapViewSelectedShouldReturn: Bool = false
    
    let requestCurrentUserList = PublishRelay<Void>()
    let showCircleAlert = PublishRelay<Void>()
    
    let zoomLevel: Double = 18
    
    private var pointAnnotations = [UserPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hbd_barHidden = true
        locationManager.startUpdatingLocation()
        setupUI()
        setupBinding()
        selectUserId(userId: nil, lastUserId: nil)
        
    }
    
    deinit {
        print("\(self) deinit")
        locationManager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestCurrentUserList.accept(())
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        guard let vip = UserManager.shared.login.value.0?.isVip, vip else {
            self.delegate?.homeShowPayController(controller: self)
            return
        }
    }
    
    // MARK: - UI
    
    func setupUI() {

        self.view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navBar.mapBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.mapView.mapType == .standard {
                self.mapView.mapType = .satellite
            } else {
                self.mapView.mapType = .standard
            }
        }).disposed(by: rx.disposeBag)
        navBar.myBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.homeShowUserController(controller: self)
        }).disposed(by: rx.disposeBag)
        
        usersView.infoBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.homeShowCircleInfoController(controller: self, circleModel: self.currentListModel)
        }).disposed(by: rx.disposeBag)
        
        view.addSubview(navBar)
        view.addSubview(usersView)
        
        navBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(UIDevice.statusBarHeight + 64.uiX);
        }
        
        usersView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.snp.bottom).offset(-(UIDevice.safeAreaBottom + 15.uiX))
            make.left.equalTo(self.view.snp.left).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-10)
        }
        
    }
    
    // MARK: - Binding
    
    func setupBinding() {
        
        let input = HomeViewModel.Input(requestCircleList: Observable<Void>.just(()),
                                        requestUserList: requestUserList.asObservable(),
                                        removeCircle: removeCircle.asObserver(),
                                        addCircle: addCircle.asObserver(),
                                        requestCurrentUserList: requestCurrentUserList.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.circleList.bind(to: navBar.circleListRelay).disposed(by: rx.disposeBag)
        output.userList.bind(to: usersView.userListRelay).disposed(by: rx.disposeBag)
        output.userList.bind {[weak self] userList in
            guard let self = self else { return }
            
            self.mapView.removeAnnotations(self.pointAnnotations)
            self.pointAnnotations.removeAll()
            
            let lastUserId = self.currentSelectedUserId.value.0
            var existLastUserId = false
            
            userList.forEach { user in
                
                if user.type == .all || user.type == .add {
                    return
                }
                
                if user.uniqueId.value == lastUserId {
                    existLastUserId = true
                }
                
                if user.isMe.value {
                    self.currentUserId = user.uniqueId.value
                    self.currentUser = user
                    user.lastPosition.accept(self.locationModel.position)
                    user.lastLng.accept(self.locationModel.lng)
                    user.lastLat.accept(self.locationModel.lat)
                    return
                }
                
                let la: Double = user.lastLat.value.double() ?? 0.0
                let long: Double = user.lastLng.value.double() ?? 0.0
                let pointAnnotation = UserPointAnnotation(user: user)
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: la, longitude: long)
                pointAnnotation.title = user.nickname.value
                pointAnnotation.subtitle = user.lastPosition.value
                self.pointAnnotations.append(pointAnnotation)
                self.mapView.addAnnotation(pointAnnotation)
            }
            
            if existLastUserId {
                self.selectUserId(userId: self.currentSelectedUserId.value.0, lastUserId: self.currentSelectedUserId.value.1)
            }
            else {
                self.selectUserId(userId: nil, lastUserId: nil)
            }
            
        }.disposed(by: rx.disposeBag)
        
//        let addSelectedMerge = Observable.merge(usersView.addSelected.asObservable(), showCircleAlert.asObservable())
        showCircleAlert.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard let id = self.currentListModel?.id else { return }
            let c = CreateCircleAlertView(name: nil, avatar: nil, currentID: id, title: "查看第一位家人位置")
            c.show()
        }).disposed(by: rx.disposeBag)
        usersView.addSelected.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard let id = self.currentListModel?.id else { return }
            let c = CreateCircleAlertView(name: nil, avatar: nil, currentID: id)
            c.show()
        }).disposed(by: rx.disposeBag)
        usersView.itemSelected.subscribe(onNext: { [weak self] userId in
            guard let self = self else { return }
            self.selectUserId(userId: userId, lastUserId: self.currentSelectedUserId.value.0)
        }).disposed(by: rx.disposeBag)
        currentSelectedUserId.bind(to: usersView.currentSelectedUserId).disposed(by: rx.disposeBag)
        
        output.userListStatus.bind(to: usersView.userListStatus).disposed(by: rx.disposeBag)
        
        output.currentCircle.subscribe(onNext: { [weak self] m in
            guard let self = self else { return }
            self.currentListModel = m
            m.name.bind(to: self.navBar.dropBtn.titleLbl.rx.text).disposed(by: self.rx.disposeBag)
            m.name.bind(to: self.usersView.titleLbl.rx.text).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        output.vipRelay.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.homeShowPayController(controller: self)
        }).disposed(by: rx.disposeBag)
        
        output.hudTextRelay.bind(to: view.rx.mbHudText).disposed(by: rx.disposeBag)
        viewModel.parsedError.bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        
        navBar.selectRelay.bind(to: requestUserList).disposed(by: rx.disposeBag)
        
        navBar.addCircle.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let a = AddCircleAlertView()
            a.addCircle = self.addCircle
            a.show()
        }).disposed(by: rx.disposeBag)
        navBar.createCircle.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let c = CreateCircleAlertView(name: nil, avatar: nil)
            c.addCircle = self.addCircle
            c.show()
        }).disposed(by: rx.disposeBag)
        
        PushManager.shared.addCircle = addCircle
        PushManager.shared.showViewRelay.bind { _ in
            PushManager.shared.show()
        }.disposed(by: rx.disposeBag)
        
    }
    
    // MARK: - Tool
    
    func selectUserId(userId: String?, lastUserId: String?) {
        
        if let lastUserId = lastUserId {
            pointAnnotations.filter { $0.user.uniqueId.value == lastUserId }.forEach { ano in
                mapView.deselectAnnotation(ano, animated: false)
            }
        }
        if let userId = userId {
            mapViewSelectedShouldReturn = true
            if userId == currentUserId {
                mapView.selectAnnotation(mapView.userLocation, animated: false)
                mapView.showAnnotations([mapView.userLocation!], animated: false)
                if mapView.zoomLevel < zoomLevel {
                    mapView.setZoomLevel(zoomLevel, animated: false)
                }
            } else {
                pointAnnotations.filter { $0.user.uniqueId.value == userId }.forEach { ano in
                    mapView.selectAnnotation(ano, animated: false)
                    mapView.showAnnotations([ano], animated: false)
                    if mapView.zoomLevel < zoomLevel {
                        mapView.setZoomLevel(zoomLevel, animated: false)
                    }
                }
            }
            mapViewSelectedShouldReturn = false
        } else {
            var point = [MAAnnotation]()
            point.append(contentsOf: pointAnnotations)
            if let user = mapView.userLocation {
                point.append(user)
            }
            
            mapView.showAnnotations(point, edgePadding: .init(top: UIDevice.statusBarHeight + 130.uiX, left: 30.uiX, bottom: UIDevice.safeAreaBottom + 200.uiX, right: 30.uiX), animated: true)
            
        }
        currentSelectedUserId.accept((userId, lastUserId))
    }

}


extension HomeViewController: MAMapViewDelegate {
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if let userAnnotation = annotation as? UserPointAnnotation {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: UserAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? UserAnnotationView
            
            let scale: CGFloat = 173/156.0
            let w: CGFloat = 78.uiX
            let h = w * scale
            
            if annotationView == nil {
                annotationView = UserAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
//                annotationView?.backgroundColor = .red
                annotationView?.frame = .init(x: 0, y: 0, width: w, height: h)
            }
            
            annotationView!.canShowCallout = true
            annotationView!.isDraggable = false
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView!.centerOffset = CGPoint(x: 0.0, y: -(h/2) + 15.uiX);
            annotationView!.bind(to: userAnnotation.user)
            
            return annotationView!
            
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        views.forEach { v in
            if let view = v as? MAAnnotationView {
                view.canShowCallout = false
            }
        }
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        if let userView = view as? UserAnnotationView {
            userView.setupSelectedStatus(selected: true)
            if !mapViewSelectedShouldReturn {
                if let useran = userView.annotation as? UserPointAnnotation {
                    selectUserId(userId: useran.user.uniqueId.value, lastUserId: currentSelectedUserId.value.0)
                }
            }
        } else {
            selectUserId(userId: currentUserId, lastUserId: currentSelectedUserId.value.0)
        }
    }
    
    func mapView(_ mapView: MAMapView!, didDeselect view: MAAnnotationView!) {
        if let userView = view as? UserAnnotationView {
            userView.setupSelectedStatus(selected: false)
        }
    }
    
    func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {

        selectUserId(userId: currentSelectedUserId.value.0, lastUserId: currentSelectedUserId.value.1)
    }
    
}

extension HomeViewController: AMapLocationManagerDelegate {
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        if let loca = location {
            locationModel.lng = loca.coordinate.longitude.string
            locationModel.lat = loca.coordinate.latitude.string
        }
        if let re = reGeocode, let address = re.formattedAddress {
            locationModel.position = address
            if let user = currentUser {
                user.lastPosition.accept(address)
            }
        }
    }

    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }

    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        
    }
}
