//
//  AppEventHandler.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/08.
//

import Foundation
import UIKit
import Firebase

class AppEventHandler: NSObject {
    let db = Firestore.firestore()
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let sharedInstance = AppEventHandler()
    

    override private init() {
        super.init()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // 各イベントの通知を受け取れるよう、NotificationCenterに自身を登録
    func startObserving() {
        // アプリ起動時
        NotificationCenter.default.addObserver(self, selector: #selector(self.didFinishLaunch),
                                               name: UIApplication.didFinishLaunchingNotification, object: nil)

        // フォアグラウンド復帰時
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)

        // バックグラウンド移行時
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification, object: nil)

        // アプリ終了時
        NotificationCenter.default.addObserver(self, selector: #selector(self.willTerminate),
                                               name: UIApplication.willTerminateNotification, object: nil)
    }

    // アプリ起動時の処理
    @objc func didFinishLaunch() {
        print("App Start")
    }

    // フォアグラウンドへの復帰時の処理
    @objc func willEnterForeground() {
        print("App forground")
        
        if let className = self.appDelegate.whichClass, let UserName = self.appDelegate.UserName{
            let ref = self.db.collection("class").document(className)

            ref.getDocument{(document, err) in
                if let document = document{
                    var ClassMate = document.get("member") as! [String : String]
                    print(document.get("member") as! [String : String])
                    ClassMate[UserName] = "lalalala"

                    ref.updateData([
                        "member": ClassMate
                    ]){ err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
            }
        }
    }

    // バックグラウンドへの移行時の処理
    @objc func didEnterBackground() {
        print("App background")
        let ref = self.db.collection("class").document(self.appDelegate.whichClass!)

        ref.getDocument{(document, err) in
            if let document = document{
                var ClassMate = document.get("member") as! [String : String]
                print(document.get("member") as! [String : String])
                ClassMate.removeValue(forKey: self.appDelegate.UserName!)
                print(ClassMate)

                ref.updateData([
                    "member": ClassMate
                ]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Member log out")
                    }
                }
            }
        }
    }

    // アプリ終了時の処理
    @objc func willTerminate() {
        print("App finished")
        let ref = self.db.collection("class").document(self.appDelegate.whichClass!)
        
        ref.getDocument{(document, err) in
            if let document = document{
                var ClassMate = document.get("member") as! [String : String]
                print(document.get("member") as! [String : String])
                ClassMate[self.appDelegate.UserName!] = nil

                ref.updateData([
                    "member": ClassMate
                ]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                        print("App finished")
                        // NotificationCenterから自身を削除
                        NotificationCenter.default.removeObserver(self)
                    }
                }
            }
        }
    }
}
