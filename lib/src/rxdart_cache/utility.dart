import 'dart:async';


StreamSubscription<T> catchStream<T>(StreamController<T> controller, Stream<T> stream) {
  return stream.listen(controller.add, onError: controller.addError);
}