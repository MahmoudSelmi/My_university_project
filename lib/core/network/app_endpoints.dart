class ApiEndpoints {
  static const String baseUrl = "http://98.80.71.205:3000/api/v1";

  static const String login = "$baseUrl/auth/login";
  static const String verifyEmail = "$baseUrl/auth/verify-email";
  static const String forgetPassword = "$baseUrl/auth/forget-password";
  static const String resetPassword = "$baseUrl/auth/reset-password";
  static const String register = "$baseUrl/auth/sign-up";

  static const String getUniversities = "$baseUrl/universities";
  static const String getDepartments = "$baseUrl/departments";
  static const String refreshToken = "$baseUrl/auth/refresh-token";

  static const String myProject = "$baseUrl/projects/my-project";
  static const String allProjects = "$baseUrl/projects/all";
}
