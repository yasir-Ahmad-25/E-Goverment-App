import 'dart:convert';

import 'package:e_govermenet/components/models/service_specific_data.dart';
import 'package:e_govermenet/components/services/api_constants.dart';
import 'package:e_govermenet/components/utils/validators.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<int?> _getCitizenId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  // Generic method to fetch data
  Future<Map<String, dynamic>> _fetchData(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data;
        } else {
          throw Exception(
            data['message'] ?? 'API returned success false, but no message.',
          );
        }
      } else {
        throw Exception(
          'Failed to load data (Status code: ${response.statusCode})',
        );
      }
    } catch (e) {
      print("Error fetching data from $url: $e");
      rethrow; // Rethrow to be caught by the caller
    }
  }

  Future<ServiceStatus> getServiceStatus(int serviceId) async {
    final citizenId = await _getCitizenId();
    if (citizenId == null) throw Exception("Citizen ID not found");

    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.getCustomerServiceUrl()),
        body: {
          'citizen_id': citizenId.toString(),
          'service_id': serviceId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ServiceStatus.fromJson(data);
      } else {
        print(
          "Failed to get service status for service ID $serviceId. Status Code: ${response.statusCode}",
        );
        return ServiceStatus.empty(); // Return a default "NEW" status on failure
      }
    } catch (e) {
      print("Error getting service status for service ID $serviceId: $e");
      return ServiceStatus.empty(); // Return a default "NEW" status on error
    }
  }

  Future<NationalIdData?> fetchNationalIdData() async {
    final citizenId = await _getCitizenId();
    if (citizenId == null) throw Exception("Citizen ID not found");

    final serviceStatus = await getServiceStatus(
      1,
    ); // Assuming National ID is service_id 1

    try {
      final data = await _fetchData(ApiConstants.getNationalIdUrl(citizenId));
      if (data['national_id_data'] != null &&
          data['national_id_data'].isNotEmpty) {
        final rawData = data['national_id_data'][0];
        // if (Validators.isValidId(rawData['national_id_number'])) {
          bool isExpired = rawData['national_id_card_status'] == 'Expired';
          return NationalIdData.fromJson(
            rawData,
            serviceStatus.requestStatus,
            isExpired,
          );
        // }
      }
      // If no valid data but service status indicates it should exist, might be an issue
      // For now, return null if data is not valid/present

      return null;
    } catch (e) {
      print("Error in fetchNationalIdData: $e");
      // If service status was "Approved" but fetch failed, this is an issue.
      // Otherwise, it might just mean the user doesn't have one yet.
      // Depending on serviceStatus, you might want to handle this differently.
      // For now, if an error occurs during fetch, we assume no data.
      return null;
    }
  }

  Future<PassportData?> fetchPassportData() async {
    final citizenId = await _getCitizenId();
    if (citizenId == null) throw Exception("Citizen ID not found");

    final serviceStatus = await getServiceStatus(
      2,
    ); // Assuming Passport is service_id 2

    try {
      final data = await _fetchData(ApiConstants.getPassportUrl(citizenId));
      if (data['passport_data'] != null && data['passport_data'].isNotEmpty) {
        final rawData = data['passport_data'][0];
        // if (Validators.isValidId(rawData['passport_number'])) {
          bool isExpired = rawData['passport_status'] == 'Expired';
          return PassportData.fromJson(
            rawData,
            serviceStatus.requestStatus,
            isExpired,
          );
        // }
      }
      return null;
    } catch (e) {
      print("Error in fetchPassportData: $e");
      return null;
    }
  }

  Future<BirthCertificateData?> fetchBirthCertificateData() async {
    final citizenId = await _getCitizenId();
    if (citizenId == null) throw Exception("Citizen ID not found");

    final serviceStatus = await getServiceStatus(
      3,
    ); // Assuming Birth Cert is service_id 3

    try {
      final data = await _fetchData(
        ApiConstants.getBirthCertificateUrl(citizenId),
      );
      if (data['birth_certificate_data'] != null &&
          data['birth_certificate_data'].isNotEmpty) {
        final rawData = data['birth_certificate_data'][0];
        // Assuming 'scanned_birth_certificate' path presence indicates validity for display
        // if (Validators.isValidId(rawData['scanned_birth_certificate'])) {
        bool isExpired = rawData['certificate_status'] == 'Expired';
        return BirthCertificateData.fromJson(
          rawData,
          serviceStatus.requestStatus,
          isExpired,
        );
        // }
      }
      return null;
    } catch (e) {
      print("Error in fetchBirthCertificateData: $e");
      return null;
    }
  }

  Future<BusinessCertificateData?> fetchBusinessCertificateData() async {
    final citizenId = await _getCitizenId();
    if (citizenId == null) throw Exception("Citizen ID not found");

    final serviceStatus = await getServiceStatus(
      4,
    ); // Assuming Business Cert is service_id 4

    try {
      final data = await _fetchData(
        ApiConstants.getBusinessCertificateUrl(citizenId),
      );
      if (data['business_certificate_data'] != null &&
          data['business_certificate_data'].isNotEmpty) {
        final rawData = data['business_certificate_data'][0];
        // if (Validators.isValidId(rawData['scanned_business_certificate'])) {
          // Check a relevant field
          bool isExpired = rawData['business_status'] == 'Expired';
          return BusinessCertificateData.fromJson(
            rawData,
            serviceStatus.requestStatus,
            isExpired,
          );
        // }
      }
      return null;
    } catch (e) {
      print("Error in fetchBusinessCertificateData: $e");
      return null;
    }
  }

  Future<DriverLicenseData?> fetchDriverLicenseData(
    Map<String, dynamic> nationalIdProfile,
  ) async {
    final citizenId = await _getCitizenId();
    if (citizenId == null) throw Exception("Citizen ID not found");

    final serviceStatus = await getServiceStatus(
      5,
    ); // Assuming Driver License is service_id 5

    try {
      final data = await _fetchData(
        ApiConstants.getDriverLicenseUrl(citizenId),
      );
      if (data['driver_License_Data'] != null &&
          data['driver_License_Data'].isNotEmpty) {
        final rawData = data['driver_License_Data'][0];
        if (Validators.isValidId(rawData['plate_number'])) {
          // Expiry for driver's license might need to be calculated or based on 'license_status'
          bool isExpired = rawData['license_status'] == 'Expired';
          return DriverLicenseData.fromJson(
            rawData,
            serviceStatus.requestStatus,
            isExpired,
            nationalIdProfile,
          );
        }
      }
      return null;
    } catch (e) {
      print("Error in fetchDriverLicenseData: $e");
      return null;
    }
  }

  // Placeholder for fetching National ID profile, which might be needed by other services
  // like Driver's License for full name, gender etc.
  Future<Map<String, dynamic>> fetchNationalIdProfileForOtherServices() async {
    final citizenId = await _getCitizenId();
    if (citizenId == null)
      throw Exception("Citizen ID not found for profile fetch");
    try {
      final data = await _fetchData(ApiConstants.getNationalIdUrl(citizenId));
      if (data['national_id_data'] != null &&
          data['national_id_data'].isNotEmpty) {
        return data['national_id_data'][0]; // Return the raw profile data
      }
      return {}; // Return empty map if no profile found
    } catch (e) {
      print("Error fetching national ID profile for other services: $e");
      return {};
    }
  }
}
