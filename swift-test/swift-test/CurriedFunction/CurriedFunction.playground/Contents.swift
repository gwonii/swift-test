import UIKit
import RxSwift

func validate(_ pattern: String) -> (String) -> Bool {
    return { input in
                guard let pattern = try? Regex(pattern) else {
                    return false
                }

        return input.firstMatch(of: pattern) != nil
    }
}

let emailValidator = validate("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
let isValidEmail = emailValidator("hogwon.choi@nhndooray.com")

print("isValidEmail: \(isValidEmail)")


struct Logger {
    enum Level {
        case info
        case error
    }

    func log(_ level: Level, _ message: String) {
        print("[\(level)] \(message)")
    }

    func logCurry(_ level: Level) -> (String) -> Void {
        return { message in
            return print("[\(level)] \(message)")
        }
    }
}

let logger = Logger()
logger.log(.info, "로그인 완료")

let info = logger.logCurry(.info)
info("로그인")
info("로그인 시도중")
info("로그인 완료")


func fetchData(from baseURL: String, url endpoint: String) async throws -> Data {
    guard let url = URL(string: baseURL + endpoint) else {
        throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    return data
}


func createFetcher(for baseURL: String) -> (String) async throws -> Data {
    return { endpoint in
        return try await fetchData(from: baseURL, url: endpoint)
    }
}

Task {
    do {
        let githubFetcher = createFetcher(for: "https://api.github.com")

        let userData = try await githubFetcher("/users/octocat")
        print("Fetched user data:", userData)

        let reposData = try await githubFetcher("/users/octocat/repos")
        print("Fetched repos data:", reposData)

    } catch {
        print("Error fetching data:", error)
    }
}


struct User: Decodable {
    let id: Int
    let name: String
    let age: Int
    let isActivated: Bool

    func updateIsActivated(_ isActivated: Bool) -> Self {
        return User(id: id, name: name, age: age, isActivated: isActivated)
    }
}

func activateUser(user: User, isActivated: Bool) -> User {
    return user.updateIsActivated(isActivated)
}

func activateUser(isActivated: Bool) -> (User) -> User {
    return { user in
        return user.updateIsActivated(isActivated)
    }
}

let disposeBag = DisposeBag()
let subject = PublishSubject<User>()

subject
    .map(activateUser(isActivated: true))
    .subscribe(onNext: { updatedUser in
        print("Updated User: \(updatedUser)")
    })
    .disposed(by: disposeBag)


func incr(_ x: Int) -> Int {
  return x + 1
}

func square(_ x: Int) -> Int {
  return x * x
}


[1, 2, 3]
  .map(incr)
  .map(square)
