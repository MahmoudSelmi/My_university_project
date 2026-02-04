class TokenStorage {
  static String? accessToken;
  static String? refreshToken;

  static void saveTokens({
    required String access,
    required String refresh,
  }) {
    accessToken = access;
    refreshToken = refresh;
  }

  static void clear() {
    accessToken = null;
    refreshToken = null;
  }
}
