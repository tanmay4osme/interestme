import 'dart:async';

import 'dart:ui';
import 'package:flutter/services.dart';

typedef void AvailabilityHandler(bool result);
typedef void StringResultHandler(String text);

/// the channel to control the speech recognition
class SpeechRecognition {
  static const MethodChannel _channel =
      const MethodChannel('edu.jcu.mySocialApp/recognizer');

  static final SpeechRecognition _speech = new SpeechRecognition._internal();

  factory SpeechRecognition() => _speech;

  SpeechRecognition._internal() {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  AvailabilityHandler availabilityHandler;

  StringResultHandler currentLocaleHandler;
  StringResultHandler recognitionResultHandler;
  StringResultHandler keyboardResultHandler;

  VoidCallback recognitionStartedHandler;

  VoidCallback recognitionCompleteHandler;

  /// ask for speech  recognizer permission
  Future activate() => _channel.invokeMethod("activate");

  /// start listening
  Future listen({String locale}) =>
      _channel.invokeMethod("start", locale);

      
  Future getKeyboard({String text}) =>
      _channel.invokeMethod('showKeyboard',text);

  Future showVideo({String text}) =>
      _channel.invokeMethod('showVideo',text);


  Future cancel() => _channel.invokeMethod("cancel");

  Future stop() => _channel.invokeMethod("stop");

  Future _platformCallHandler(MethodCall call) async {
    print("_platformCallHandler call ${call.method} ${call.arguments}");
    switch (call.method) {
      case "onSpeechAvailability":
        availabilityHandler(call.arguments);
        break;
      case "onCurrentLocale":
        currentLocaleHandler(call.arguments);
        break;
      case "onSpeech":
        recognitionResultHandler(call.arguments);
        break;
      case "onRecognitionStarted":
        recognitionStartedHandler();
        break;
      case "onRecognitionComplete":
        recognitionCompleteHandler();
        break;
       case "onKeyboard":
        keyboardResultHandler(call.arguments);
        break;
      
      default:
        print('Unknowm method ${call.method} ');
    }
  }

  // define a method to handle availability / permission result
  void setAvailabilityHandler(AvailabilityHandler handler) =>
      availabilityHandler = handler;

  // define a method to handle recognition result
  void setRecognitionResultHandler(StringResultHandler handler) =>
      recognitionResultHandler = handler;
  
  // define a method to handle recognition result
  void setKeyboardResultHandler(StringResultHandler handler) =>
      keyboardResultHandler = handler;

  // define a method to handle native call
  void setRecognitionStartedHandler(VoidCallback handler) =>
      recognitionStartedHandler = handler;

  // define a method to handle native call
  void setRecognitionCompleteHandler(VoidCallback handler) =>
      recognitionCompleteHandler = handler;

  void setCurrentLocaleHandler(StringResultHandler handler) =>
      currentLocaleHandler = handler;
}