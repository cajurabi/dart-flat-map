library flat_map;

import 'dart:async';
import 'package:composite_subscription/composite_subscription.dart';

class FlatMap<S, T> extends StreamEventTransformer {

  final Function _flatMapper;

  const FlatMap(this._flatMapper);

  Stream<T> bind(Stream<S> stream) {
    var result        = new StreamController();
    var subscriptions = new CompositeSubscription();
    var isComplete    = false;
    var subscription  = stream.listen(
      (S data) {
        var subscription = null;
        subscription = this._flatMapper(data).listen(
          (T data) {
            result.add(data);
          },
          onError: (error) {
            result.addError(error);
            subscriptions.cancel();
          },
          onDone: () {
            subscriptions.remove(subscription);
            if (isComplete && subscriptions.toList().length == 1) {
              result.close();
            }
          }
        );
        subscriptions.add(subscription);
      },
      onError: (error) {
        result.addError(error);
        subscriptions.cancel();
      },
      onDone: () {
        if (subscriptions.toList().length == 1) {
          result.close();
          subscription.cancel();
        } else {
          isCompleted = true;
        }
      }
    );
    subscriptions.add(subscription);
    return result.stream;
  }

}