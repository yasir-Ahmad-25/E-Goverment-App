// lib/services/api_constants.dart
class ApiConstants {
  //static const String baseUrl = 'http:// 10.203.28.39/Som-Gov';
  static const String baseUrl = 'http://192.168.100.10/Som-Gov';
  // static const String baseUrl = 'http://192.168.202.39/Som-Gov';
  static const String nationalIdEndpoint = '/national_id';
  static const String passportEndpoint = '/passport_id';
  static const String birthCertificateEndpoint = '/birth_certificate';
  static const String businessCertificateEndpoint = '/business_certificate';
  static const String driverLicenseEndpoint = '/driver_license';
  static const String customerServiceEndpoint =
      '/getCustomerService'; // For checking service status

  // Endpoints for different services
  static String getCustomerServiceUrl() => '$baseUrl$customerServiceEndpoint';
  static String getNationalIdUrl(int citizenId) =>
      '$baseUrl$nationalIdEndpoint/$citizenId';
  static String getPassportUrl(int citizenId) =>
      '$baseUrl$passportEndpoint/$citizenId';
  static String getBirthCertificateUrl(int citizenId) =>
      '$baseUrl$birthCertificateEndpoint/$citizenId';
  static String getBusinessCertificateUrl(int citizenId) =>
      '$baseUrl$businessCertificateEndpoint/$citizenId';
  static String getDriverLicenseUrl(int citizenId) =>
      '$baseUrl$driverLicenseEndpoint/$citizenId';

  // For user registration and login
  static String getSignUpUrl() => '$baseUrl/signup';
  static String getCitizenData(int citizenId) => '$baseUrl/citizen/$citizenId';

  static String getLoginUrl() => '$baseUrl/login';
  static String getLogoutUrl() => '$baseUrl/logout';

  // For fetching States
  static String getStatesUrl() => '$baseUrl/states';

  // fetch Document Types Except The Current Ordering One
  static String getDocumentTypesUrl() => '$baseUrl/documentTypes';
  static String getDocumentTypes2() => '$baseUrl/documentTypes/2';
  static String getDocumentTypes4() => '$baseUrl/documentTypes/4';

  // For image base URL if not included in the image path from API
  static String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return '$baseUrl/$imagePath';
  }

  // For Saving The Services
  static String saveNationalIdCardUrl() => '$baseUrl/national_id_card';

  static String saveDriverLicense() => '$baseUrl/request_driverLicense';

  static String saveBusinessLicense() => '$baseUrl/request_business';

  static String saveBirthCertificate() => '$baseUrl/request_birth_certificate';

  static String savePassportUrl() => '$baseUrl/request_passport';


  static String saveTaxPayment() => '$baseUrl/saveTaxPayment';
  static String saveBusinessTaxPayment() => '$baseUrl/saveBusinessTaxPayment';
  static String saveHouseTaxPayment() => '$baseUrl/saveHouseTaxPayment';


  static String fetch_driver_tax(int citizenId) => '$baseUrl/driver_tax/$citizenId';

  static String fetch_businessTax(int citizenId) => '$baseUrl/business_tax/$citizenId';

  static String fetchPaymentMethods() => '$baseUrl/payment_methods';

  static String getBusinessTypes() => '$baseUrl/business_types';

  static String getCarTypes() => '$baseUrl/car_types';

  static String getServices() => '$baseUrl/services';

  static String getTaxes() => '$baseUrl/taxes';



}
