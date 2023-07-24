import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class Log {
  late final Logger _logger;
  static final Log _singleton = Log._internal();

  factory Log() {
    return _singleton;
  }

  Log._internal() {
    _logger = Get.put<Logger>(
        Logger(
          output: MultiOutput([
            ConsoleOutput(),
            ElkOutput(),
          ]),
        ),
        permanent: true);
  }

  void i(String message, [String tenant = "default"]) {
    _logger.i("[$tenant] $message");
  }

  void d(String message, [String tenant = "default"]) {
    _logger.d("[$tenant] $message");
  }

  void e(String message, [dynamic error, StackTrace? stackTrace, String tenant = "default"]) {
    _logger.e("[$tenant] $message", [error, stackTrace]);
  }
}

class ElkOutput extends LogOutput {
  //TODO Send to ELK.
  @override
  void output(OutputEvent event) {
    // Send logs to your server
    var log = event.lines.join("\n");
    // http.post(Uri.parse('http://your-elk-server/logs'), body: {'log': log});
  }
}
