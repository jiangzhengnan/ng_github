import 'package:dio/dio.dart';

/// header拦截器
class HeaderInterceptors extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    ///超时
    options.connectTimeout = 15000;
    options.receiveTimeout = 15000;

    return options;
  }
}
