// lib/services/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'http://192.168.100.10/egov_back';
  static const String nationalIdEndpoint = '/national_id';
  static const String passportEndpoint = '/passport_id';
  static const String birthCertificateEndpoint = '/birth_certificate';
  static const String businessCertificateEndpoint = '/business_certificate';
  static const String driverLicenseEndpoint = '/driver_license';
  static const String customerServiceEndpoint = '/getCustomerService'; // For checking service status

  static String getCustomerServiceUrl() => '$baseUrl$customerServiceEndpoint';
  static String getNationalIdUrl(int citizenId) => '$baseUrl$nationalIdEndpoint/$citizenId';
  static String getPassportUrl(int citizenId) => '$baseUrl$passportEndpoint/$citizenId';
  static String getBirthCertificateUrl(int citizenId) => '$baseUrl$birthCertificateEndpoint/$citizenId';
  static String getBusinessCertificateUrl(int citizenId) => '$baseUrl$businessCertificateEndpoint/$citizenId';
  static String getDriverLicenseUrl(int citizenId) => '$baseUrl$driverLicenseEndpoint/$citizenId';

  // For image base URL if not included in the image path from API
  static String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return '$baseUrl/$imagePath';
  }
}