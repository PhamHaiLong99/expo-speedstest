import ExpoModulesCore
public class ExpoSpeedstestModule: Module{
    //  private var sut: HostsProviderService?
    lazy var speedtestService = {
        SpeedTestService()
    }()
    lazy var downloadService = {
        CustomHostDownloadService()
    }()
    lazy var uploadService = {
        CustomHostUploadService()
    }()
    lazy var speedtest = {
        SpeedTest(
            // hosts: speedtestService, ping: DefaultHostPingService()
            )
    }()
    private let standartTimeout: TimeInterval = 5
    private let fileSize: Int = 10000000
    public func definition() -> ModuleDefinition {
        Name("ExpoSpeedstest")
        Constants([ "PI": Double.pi])
        Events("onChange")
        AsyncFunction("checkInternet") { (promise: Promise) in
            self.speedtestService.getHosts(max: 1, timeout: standartTimeout) { result in
                switch result {
                case .error(let error):
                    log.error(error)
                    promise.reject(InternetError())
                case .value(let hosts):
                    log.info("Success \(hosts.count))")
                    promise.resolve("Success")
                }
            }
        }
        AsyncFunction("downloadSpeedTest") { (promise: Promise) in
            self.downloadService.test(URL(string: "http://speedtest.fpt.vn.prod.hosts.ooklaserver.net:8080/download?size=\(self.fileSize)")!,
                                      fileSize:  10000000,
                                      timeout: self.standartTimeout,
                                      current: { (speed, average) in
                log.info("Speed: \(speed), average: \(average)")
            },
                                      final: { (result) in
                switch result {
                case .error(let error):
                      log.error(error)
                      promise.reject(DownLoadSpeedTestError())
                  case .value(let speed):
                      log.info("Success \(speed)")
                      promise.resolve("\(speed)")
                  }
            })
        }
        AsyncFunction("uploadSpeedTest") { (promise: Promise) in
            self.uploadService.test(URL(string: "http://speedtest.fpt.vn.prod.hosts.ooklaserver.net:8080/speedtest/upload")!,
            fileSize: self.fileSize,
            timeout: self.standartTimeout,
            current: { (speed, average) in
                log.info("Speed: \(speed), average: \(average)")
            },
            final: { result in 
                switch result {
                  case .error(let error):
                      log.error(error)
                      promise.reject(UpLoadSpeedTestError())
                  case .value(let speed):
                      log.info("Success \(speed)")
                      promise.resolve("\(speed)")
                  }
            })
        }
    }
}
