import 'dart:async';
import 'package:flat_map/flat_map.dart';

main() {
  var controller = new StreamController();
  var flattend   = controller.stream
                             .transform(new FlatMap((data) {
                                 return new Stream.fromIterable([data, data]);
                             })).listen(print);

  for (var i = 0; i < 10; i++) {
    controller.add(i);
  }
}