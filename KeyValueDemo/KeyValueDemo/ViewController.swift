//
//  ViewController.swift
//  KeyValueDemo
//
//  Created by 华惠友 on 2020/9/27.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let Defaults = DefaultsAdapter<DefaultsKeys>(keyStore: .init())

        let p1: Person = Defaults.aa
        p1.dynamicallyCall(withKeywordArguments: ["wei_suo_yu_wei": "123"])
        
        let a = Defaults.hotkeyEnabled
        print(a)
        
    }
}

public protocol DefaultsKeyStore {}

public struct DefaultsKeys: DefaultsKeyStore {
    public init() {}
}

extension DefaultsKeys {
    var hotkeyEnabled: DefaultsKey<Bool> { .init() }
}

protocol DefaultsSerializable {
    
}
extension Bool: DefaultsSerializable {
    
}
struct DefaultsKey<ValueType: DefaultsSerializable> {

}

@dynamicMemberLookup
public struct DefaultsAdapter<KeyStore: DefaultsKeyStore> {
    public let keyStore: KeyStore

    public init(keyStore: KeyStore) {
        self.keyStore = keyStore
    }
}

extension DefaultsAdapter {
    subscript(dynamicMember member: String) -> String {
        let properties = ["nickname": "huayoyu", "city": "Shanghai"]
        return properties[member, default: "undefined"]
    }
    subscript(dynamicMember member: String) -> Int {
        return 18
    }
    
    subscript(dynamicMember member: String) -> Person {
        return Person()
    }
    
    subscript(dynamicMember member: String) -> (_ input: String) -> Void {
        return {
            print("Hello! I live at the address \($0).")
        }
    }
    
    subscript<T: DefaultsSerializable>(dynamicMember keyPath: KeyPath<KeyStore, DefaultsKey<T>>) -> Int {
        return 1
    }
    

}
@dynamicCallable
class Person {
    func dynamicallyCall(withArguments: [String]) {
        for item in withArguments {
            print(item)
        }
    }
    
    // 实现方法二
    func dynamicallyCall(withKeywordArguments: KeyValuePairs<String, String>){
        for (key, value) in withKeywordArguments {
            print("\(key) --- \(value)")
        }
    }
}
