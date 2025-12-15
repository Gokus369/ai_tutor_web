import 'package:dio/dio.dart';

import 'api_config_cubit.dart';

/// Thin wrapper around Dio so it can be provided through DI and stay in sync with ApiConfigCubit.
class ApiClient {
  ApiClient({required ApiConfigState initialConfig})
      : dio = Dio(BaseOptions(baseUrl: initialConfig.baseUrl));

  final Dio dio;

  void updateBaseUrl(ApiConfigState config) {
    dio.options.baseUrl = config.baseUrl;
  }
}
