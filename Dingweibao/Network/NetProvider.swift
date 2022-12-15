//
//  NetProvider.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/10.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Moya
import FCUUID
import Alamofire
import FileKit
import Kingfisher
import AdSupport

let NetProvider = MoyaProvider<NetAPI>(requestClosure: { (endpoint, done) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = 20//设置请求超时时间
        done(.success(request))
    } catch {

    }
})

public enum CheckCodeEvent: String {
    case check = "check" //验证手机号
    case bind = "bind" //绑定手机号
    case regLogin = "reg_login" //使用手机号+验证码的方式进行注册或登录
}

//nickname=昵称,area=地区,sex=性别,constellation=星座,avatar=头像
public enum UserInfoChangeType: String {
    
    case nickname = "nickname"
    case area = "area"
    case sex = "sex"
    case constellation = "constellation"
    case avatar = "avatar"

}

//修改的字段名,avatar=群头像,name=群名称,join_auth=加群权限.1=群主验证通过,2=无需验证,3=拒绝所有人
public enum CircleInfoChangeType: String {
    
    case avatar = "avatar"
    case name = "name"
    case auth = "join_auth"

}

public enum ThirdLoginType: String {
    
    case weChat = "wechat"
    case apple = "apple_id"

}

public enum LocationAuthType: String {
    
    case open = "open"
    case close = "close"

}

public enum NetAPI {
    /// 激活
    case active
    /// 审核
    case isCheck
    /// 登录
    case aliAuth(token: String)
    case updateUser(token: String? = nil)
    case getCheckCode(mobile: String, event: CheckCodeEvent)
    case phoneLogin(mobile: String, checkCode: String)
    case thirdLogin(type: ThirdLoginType, openId: String, nickName: String, avatar: String, sex: Int, deviceToken: String)
    /// 消息
    case messageList(page: Int, limit: Int)
    ///分享
    case share(id: Int)
    ///修改个人资料
    case changeUserInfo(type: UserInfoChangeType, value: String)
    ///手机绑定
    case changePhone(mobile: String, code: String, oldCode: String)
    case bindPhone(mobile: String, code: String)
    case aliBindPhone(token: String)
    /// 上传文件
    case upFile(file: URL, dirName: String)
    case upImage(image: UIImage, dirName: String)
    /// 支付
    case payProductList
    case pay(receipt: String)
    /// 群组
    case circleList
    case addToCircle(id: String, encodeId: String?, userId: String?)
    case createCircle(name: String, avatar: String)
    case removeCircle(id: String)
    case selectCircle(id: String)
    case circleInfo(id: String)
    case circleEdit(id: String, type: CircleInfoChangeType, value: String)
    case circleUserInfo(id: String, userId: String)
    case circleOtherName(id: String, userId: String, value: String)
    case circleOtherHideLocation(id: String, userId: String, value: String)
    case circleOtherUserRemove(id: String, userId: String)
    case getCircleAvatars
    /// 群用户列表
    case homeUserList(circleId: String)
    /// 电量
    case powerList
    case powerSet(userId: String)
    /// 更新deviceToken
    case updateDeviceToken(token: String)
    /// 常规数据上传
    case uploadData(lng: String, lat: String, position: String, electric: Int)
    case uploadLocationAuth(auth: LocationAuthType)
    /// 发送通知
    case sharePosition(circleId: String, userId: String)
    case shareDistance(circleId: String, userId: String)
    case addAgree(applyId: String)
    case addIgnore(applyId: String)
}

extension NetAPI: TargetType {
    
    static var getBaseURL: String {
        return "https://api.dmwallpaper.cn/"
    }
    
    static func getHtmlProtocol(type: Int) -> URL? {
        return URL(string: String(format: "%@api/agreement/detail?id=%d", NetAPI.getBaseURL, type))
    }
    
    public var baseURL: URL {
        let baseUrl = URL(string: NetAPI.getBaseURL)!
        return baseUrl
    }
    
    public var path: String {
        switch self {
        case .active:
            return "api/common/active"
        case .isCheck:
            return "api/common/ios_status"
        case .aliAuth:
            return "api/user/bind_mobile"
        case .updateUser:
            return "api/user/info"
        case .getCheckCode:
            return "api/common/send_mobile_code"
        case .phoneLogin:
            return "api/user/mobile_code_reg_login"
        case .messageList:
            return "api/message/data"
        case .share:
            return "api/circle/invite"
        case .changeUserInfo:
            return "api/user/edit_profile"
        case .changePhone:
            return "api/user/change_mobile"
        case .bindPhone:
            return "api/user/bind_mobile_by_code"
        case .upFile:
            return "api/common/upload"
        case .upImage:
            return "api/common/upload"
        case .circleList:
            return "api/circle/get_list"
        case .homeUserList:
            return "api/circle/get_users"
        case .addToCircle:
            return "api/circle/apply_join"
        case .createCircle:
            return "api/circle/create"
        case .circleInfo:
            return "api/circle/get_info"
        case .circleEdit:
            return "api/circle/edit_profile"
        case .circleUserInfo:
            return "api/circle/get_user"
        case .circleOtherName:
            return "api/circle/set_remarks"
        case .circleOtherHideLocation:
            return "api/circle/set_hide"
        case .circleOtherUserRemove:
            return "api/circle/remove_user"
        case .removeCircle:
            return "api/circle/out"
        case .selectCircle:
            return "api/circle/select"
        case .thirdLogin:
            return "api/user/third_party_reg_login"
        case .payProductList:
            return "api/vip/ios_goods_list"
        case .pay:
            return "api/vip/apple_pay"
        case .aliBindPhone:
            return "api/user/bind_mobile"
        case .powerSet:
            return "api/remind/set_electric"
        case .powerList:
            return "api/remind/get_users"
        case .getCircleAvatars:
            return "api/circle/get_avatars"
        case .updateDeviceToken:
            return "api/user/update_device_token"
        case .uploadData:
            return "api/upload/normal"
        case .uploadLocationAuth:
            return "api/upload/auth"
        case .sharePosition:
            return "api/circle/request_share_position"
        case .shareDistance:
            return "api/remind/set_position"
        case .addAgree:
            return "api/circle/agree_join"
        case .addIgnore:
            return "api/circle/refuse_join"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        
        var params:[String:Any] = [:]
        
        switch self {
        case .active:
            params["device_id"] = UIDevice.current.uuid()
            params["idfa"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            params["platform"] = "1"
            params["version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        case .aliAuth(let token):
            params["access_token"] = token
        case .updateUser(let token):
            if let t = token {
                params["token"] = t
            }
        case let .getCheckCode(mobile: mobile, event: event):
            params["mobile"] = mobile
            params["event"] = event.rawValue
        case let .phoneLogin(mobile, checkCode):
            params["mobile"] = mobile
            params["code"] = checkCode
        case let .messageList(page, limit):
            params["page"] = page
            params["limit"] = limit
        case let .share(id):
            params["circle_id"] = id
        case let .changeUserInfo(type, value):
            params["field"] = type.rawValue
            params["field_val"] = value
        case let .changePhone(mobile, code, oldCode):
            params["old_code"] = oldCode
            params["code"] = code
            params["mobile"] = mobile
        case let .bindPhone(mobile, code):
            params["mobile"] = mobile
            params["code"] = code
        case let .upFile(file, dirName):
            params["upload_dir"] = dirName
            let data = Moya.MultipartFormData(provider: .file(file), name: "file")
            return .uploadCompositeMultipart([data], urlParameters: params)
        case let .upImage(image, dirName):
            params["upload_dir"] = dirName
            let imgData = image.jpegData(compressionQuality: 0.8) ?? Data()
            let data = Moya.MultipartFormData(provider: .data(imgData), name: "file", fileName: "file.png", mimeType: "image/jpg")
            return .uploadCompositeMultipart([data], urlParameters: params)
        case let .homeUserList(circleId):
            params["circle_id"] = circleId
        case let .addToCircle(id, encodeId, userId):
            params["circle_id"] = id
            params["circle_encode_id"] = encodeId
            params["invite_user_id"] = userId
        case let .circleInfo(id):
            params["circle_id"] = id
        case let .circleEdit(id, type, value):
            params["circle_id"] = id
            params["field"] = type.rawValue
            params["field_val"] = value
        case let .circleUserInfo(id, userId):
            params["circle_id"] = id
            params["circle_user_id"] = userId
        case let .circleOtherName(id, userId, value):
            params["circle_id"] = id
            params["circle_user_id"] = userId
            params["remarks"] = value
        case let .circleOtherHideLocation(id, userId, value):
            params["circle_id"] = id
            params["circle_user_id"] = userId
            params["status"] = value
        case let .circleOtherUserRemove(id, userId):
            params["circle_id"] = id
            params["circle_user_id"] = userId
        case let .removeCircle(id):
            params["circle_id"] = id
        case let .selectCircle(id):
            params["circle_id"] = id
        case let .thirdLogin(type, openId, nickName, avatar, sex, deviceToken):
            params["type"] = type.rawValue
            params["openid"] = openId
            params["nickname"] = nickName
            params["avatar"] = avatar
            params["sex"] = sex
            params["device_token"] = deviceToken
        case let .aliBindPhone(token):
            params["access_token"] = token
        case let .createCircle(name, avatar):
            params["name"] = name
            params["avatar"] = avatar
        case let .updateDeviceToken(token):
            params["device_token"] = token
        case let .uploadData(lng, lat, position, electric):
            params["lng"] = lng
            params["lat"] = lat
            params["position"] = position
            params["electric"] = electric
        case let .uploadLocationAuth(auth):
            params["position_auth"] = auth.rawValue
        case let .sharePosition(circleId, userId):
            params["circle_id"] = circleId
            params["circle_user_id"] = userId
        case let .shareDistance(circleId, userId):
            params["circle_id"] = circleId
            params["circle_user_id"] = userId
        case let .addAgree(applyId):
            params["apply_id"] = applyId
        case let .addIgnore(applyId):
            params["apply_id"] = applyId
        case let .powerSet(userId):
            params["circle_user_id"] = userId
        case let .pay(receipt):
            params["receipt"] = receipt
        default:
            break
        }
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    public var headers: [String : String]? {
        var headers:[String : String] = [:]
        headers["device-id"] = UIDevice.current.uuid()
        headers["idfa"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        headers["client-type"] = "1"
        headers["channel"] = "App Store"
        headers["version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        headers["token"] = UserManager.shared.login.value.0?.token ?? ""
        switch self {
        case .updateUser(let token):
            if let t = token {
                headers["token"] = t
            }
        default:
            break
        }
        return headers
    }
    
}

