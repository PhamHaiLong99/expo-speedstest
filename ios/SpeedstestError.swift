import ExpoModulesCore

internal class InternetError: Exception {
  override var reason: String {
    "The Internet is not available"
  }
}

internal class DownLoadSpeedTestError: Exception {
  override var reason: String {
    "DownLoad Speed Test Error"
  }
}

internal class UpLoadSpeedTestError: Exception {
    override var reason: String {
        "Upload Speed Test Error"
    }
}
