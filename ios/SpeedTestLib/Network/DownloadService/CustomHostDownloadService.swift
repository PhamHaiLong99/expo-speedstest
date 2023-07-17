import Foundation
import ExpoModulesCore
class CustomHostDownloadService: NSObject, SpeedService {
    private var firstRecvDate: Date?
    private var latestDate: Date?
    private var current: ((Speed, Speed) -> ())!
    private var final: ((Result<Speed, NetworkError>) -> ())!
    private var isCancelled: Bool = false
    func test(_ url: URL, fileSize: Int, timeout: TimeInterval, current: @escaping (Speed, Speed) -> (), final: @escaping (Result<Speed, NetworkError>) -> ()) {
        self.isCancelled = false
        self.current = current
        self.final = final
//        self.final = { [weak self] result in
//            guard let self = self, !self.isCancelled else { return } // Check cancellation flag
//            DispatchQueue.main.async {
//                final(result)
//            }
//        }
        let resultURL = HostURLFormatter(speedTestURL: url).downloadURL(size: fileSize)
        URLSession(configuration: sessionConfiguration(timeout: timeout), delegate: self, delegateQueue: OperationQueue())
            .downloadTask(with: resultURL)
            .resume()
    }
    func cancelCompletion() {
        self.isCancelled = true
    }
}

extension CustomHostDownloadService: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let result = calculate(bytes: downloadTask.countOfBytesReceived, seconds: Date().timeIntervalSince(self.firstRecvDate!))
        DispatchQueue.main.async {
            self.final(.value(result))
            self.cancelCompletion()
        }
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        DispatchQueue.main.async {
            log.info("urlSession didBecomeInvalidWithError")
            self.final(.error(NetworkError.requestFailed))
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async {
            log.info("urlSession didCompleteWithError here")
            guard !self.isCancelled else {
                return
            }
            self.final(.error(NetworkError.requestFailed))
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let startDate = firstRecvDate, let latesDate = latestDate else {
            firstRecvDate = Date();
            latestDate = firstRecvDate
//            log.debug("not having startDate: \(firstRecvDate)")
            return
        }
        let currentTime = Date()
//        log.info("currentTime : \(currentTime), latesDate: \(latesDate), startDate: \(startDate), firstRecvDate: \(firstRecvDate)")
        let current = calculate(bytes: bytesWritten, seconds: currentTime.timeIntervalSince(latesDate))
        let average = calculate(bytes: totalBytesWritten, seconds: -startDate.timeIntervalSinceNow)
        latestDate = currentTime
        DispatchQueue.main.async {
            self.current(current, average)
        }
    }
}
