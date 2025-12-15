import 'package:flutter_bloc/flutter_bloc.dart';

/// Exposes the API base URL through bloc so it can be injected where needed.
class ApiConfigState {
  const ApiConfigState({required this.baseUri});

  final Uri baseUri;

  String get baseUrl => baseUri.toString();
}

class ApiConfigCubit extends Cubit<ApiConfigState> {
  ApiConfigCubit({Uri? baseUri})
      : super(ApiConfigState(
          baseUri: baseUri ?? Uri.parse(_defaultBaseUrl),
        ));

  static const String _defaultBaseUrl = 'https://uatai.hoxinfotech.com';

  void setBaseUrl(String url) {
    emit(ApiConfigState(baseUri: _normalize(url)));
  }

  static Uri _normalize(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return Uri.parse(_defaultBaseUrl);
    final candidate = trimmed.startsWith('http') ? trimmed : 'https://$trimmed';
    final uri = Uri.tryParse(candidate);
    if (uri != null && uri.hasAuthority) return uri;
    return Uri.parse(_defaultBaseUrl);
  }
}
