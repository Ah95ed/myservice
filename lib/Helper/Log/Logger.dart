import 'dart:developer' as developer;

class Logger {
static void logger(String message) {
  
  developer.log('message logger -> $message');
}
  static void debug(String message) {
    print(message);
    developer.debugger(message: message);
  }

  static void error(String message) {
   developer.log('message error -> $message');
  }
}