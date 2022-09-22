import 'package:js/js.dart';

/// Use native JSON.stringify to convert an object in a JSON
@JS('JSON.stringify')
external String stringify(Object obj);

@JS()
abstract class Promise<T> {
  external factory Promise(
      void executor(void resolve(T result), Function reject));
  external Promise then(void onFulfilled(T result), [Function onRejected]);
}
