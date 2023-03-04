import 'dart:async';

import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  return Response(body: 'Hello World');
}
