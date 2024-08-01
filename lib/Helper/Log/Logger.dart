
import 'dart:developer' as developer;

class Logger {
static void logger(String message) {
  
  developer.log('message -> $message');
}


  static void debug(String message) {
    print(message);
    developer.debugger(message: message);
  }

  static void error(String message) {
    print(message);   
  }


  static void log(String message) {
    print(message);
  }
}