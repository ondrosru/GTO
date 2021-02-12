import 'package:gtoserviceapp/services/storage/keys.dart';
import 'package:gtoserviceapp/services/storage/storage.dart';

Map<String, String> _buildContentHeaders() {
  return {
    "Content-Type": "application/json;charset=UTF-8",
  };
}

Map<String, String> _buildAuthHeaders() {
  return {
    "Authorization": Storage.I.read(Keys.accessToken),
  };
}

Map<String, String> _buildRefreshHeaders() {
  return {
    "Authorization": Storage.I.read(Keys.refreshToken),
  };
}

Map<String, String> buildHeaders({
  bool auth = false,
  bool refresh = false,
  bool content = false,
}) {
  Map<String, String> headers = {};

  if (auth) {
    headers.addAll(_buildAuthHeaders());
  }

  if (refresh) {
    headers.addAll(_buildRefreshHeaders());
  }

  if (content) {
    headers.addAll(_buildContentHeaders());
  }

  return headers;
}
