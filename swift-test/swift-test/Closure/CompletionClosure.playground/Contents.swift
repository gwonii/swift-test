import UIKit



func invoke(_ completion: ((String) -> Void)? = nil) -> String {
    let result = "finished"
    let completionResult = "completion finished"
    completion?(completionResult)
    return result
}

func completionBlock(_ block: (() -> Void)? = nil) {
    block?()
    return
}

var string: String?
completionBlock() {
    print(string)
}
string = "1234"

print("end")
