// lib/models/service_specific_data.dart
// This file will hold various data models returned by your API for each service.

// Example for National ID Data
class NationalIdData {
  final String cardNumber;
  final String fullName;
  final String birthDate;
  final String gender;
  final String issueDate;
  final String expiryDate;
  final String maritalStatus;
  final String citizenImagePath;
  final bool isExpired;
  final String requestStatus; // "Approved", "Pending", "New", "Declined"

  NationalIdData({
    required this.cardNumber,
    required this.fullName,
    required this.birthDate,
    required this.gender,
    required this.issueDate,
    required this.expiryDate,
    required this.maritalStatus,
    required this.citizenImagePath,
    required this.isExpired,
    required this.requestStatus,
  });

  factory NationalIdData.fromJson(Map<String, dynamic> json, String requestStatus, bool isExpired) {
    return NationalIdData(
      cardNumber: json['national_id_number'] ?? 'N/A',
      fullName: json['fullname'] ?? 'N/A',
      birthDate: json['birthdate'] ?? 'N/A',
      gender: json['gender'] ?? 'N/A',
      issueDate: json['issued_date'] ?? 'N/A',
      expiryDate: json['Expire_Date'] ?? 'N/A',
      maritalStatus: json['martial_status'] ?? 'N/A',
      citizenImagePath: json['citizen_image'] ?? '',
      isExpired: isExpired,
      requestStatus: requestStatus,
    );
  }
}

// Example for Passport Data
class PassportData {
  final String fullName;
  final String gender;
  final String birthState;
  final String birthDate;
  final String passportNumber;
  final String issuedAt;
  final String expireAt;
  final String citizenImagePath;
  final bool isExpired;
  final String requestStatus;

  PassportData({
    required this.fullName,
    required this.gender,
    required this.birthState,
    required this.birthDate,
    required this.passportNumber,
    required this.issuedAt,
    required this.expireAt,
    required this.citizenImagePath,
    required this.isExpired,
    required this.requestStatus,
  });

 factory PassportData.fromJson(Map<String, dynamic> json, String requestStatus, bool isExpired) {
    return PassportData(
      fullName: json['fullname'] ?? 'N/A',
      gender: json['gender'] ?? 'N/A',
      birthState: json['birthState'] ?? 'N/A',
      birthDate: json['birthdate'] ?? 'N/A',
      passportNumber: json['passport_number'] ?? 'N/A',
      issuedAt: json['issued_At'] ?? 'N/A',
      expireAt: json['Expire_At'] ?? 'N/A',
      citizenImagePath: json['citizen_image'] ?? '',
      isExpired: isExpired,
      requestStatus: requestStatus,
    );
  }
}

// Example for Birth Certificate Data
class BirthCertificateData {
  final String fullName;
  final String gender;
  final String birthState;
  final String profession;
  final String scannedCertificatePath;
  final bool isExpired;
  final String requestStatus;

  BirthCertificateData({
    required this.fullName,
    required this.gender,
    required this.birthState,
    required this.profession,
    required this.scannedCertificatePath,
    required this.isExpired,
    required this.requestStatus,
  });

  factory BirthCertificateData.fromJson(Map<String, dynamic> json, String requestStatus, bool isExpired) {
    return BirthCertificateData(
      fullName: json['fullname'] ?? 'N/A',
      gender: json['gender'] ?? 'N/A',
      birthState: json['birthState'] ?? 'N/A',
      profession: json['Proffession'] ?? 'N/A',
      scannedCertificatePath: json['scanned_birth_certificate'] ?? '',
      isExpired: isExpired,
      requestStatus: requestStatus,
    );
  }
}

// Example for Business Certificate Data
class BusinessCertificateData {
  final String fullName;
  final String businessName;
  final String businessAddress;
  final String businessType;
  final String startDate;
  final String scannedCertificatePath; // Assuming this exists based on your logic
  final bool isExpired;
  final String requestStatus;

  BusinessCertificateData({
    required this.fullName,
    required this.businessName,
    required this.businessAddress,
    required this.businessType,
    required this.startDate,
    required this.scannedCertificatePath,
    required this.isExpired,
    required this.requestStatus,
  });

  factory BusinessCertificateData.fromJson(Map<String, dynamic> json, String requestStatus, bool isExpired) {
    return BusinessCertificateData(
      fullName: json['fullname'] ?? 'N/A',
      businessName: json['business_name'] ?? 'N/A',
      businessAddress: json['business_Address'] ?? 'N/A',
      businessType: json['business_type'] ?? 'N/A',
      startDate: json['Start_Date'] ?? 'N/A',
      scannedCertificatePath: json['scanned_business_certificate'] ?? '',
      isExpired: isExpired, // Assuming 'business_status' can indicate expiry
      requestStatus: requestStatus,
    );
  }
}

// Example for Driver License Data
class DriverLicenseData {
  final String plateNumber;
  final String issuedAt;
  final String expireAt;
  final String citizenImagePath;
  // Add other fields like fullname, gender, etc., if they come from this specific endpoint
  // For now, assuming they might be part of a general citizen profile loaded separately
  // or you might need to adjust the API or fetch them from national ID data.
  final String fullName; // Assuming you might get this from national id or another source
  final String gender;
  final String birthDate;
  final bool isExpired; // You'll need to determine this, maybe from 'license_status' or dates
  final String requestStatus;


  DriverLicenseData({
    required this.plateNumber,
    required this.issuedAt,
    required this.expireAt,
    required this.citizenImagePath,
    required this.fullName,
    required this.gender,
    required this.birthDate,
    required this.isExpired,
    required this.requestStatus,
  });

  factory DriverLicenseData.fromJson(Map<String, dynamic> json, String requestStatus, bool isExpired, Map<String,dynamic> nationalIdProfile) {
     return DriverLicenseData(
      plateNumber: json['plate_number'] ?? 'N/A',
      issuedAt: json['issued_At'] ?? 'N/A',
      expireAt: json['Expire_At'] ?? 'N/A',
      citizenImagePath: json['citizen_image'] ?? '',
      fullName: nationalIdProfile['fullname'] ?? 'N/A', // Example: reusing national ID data
      gender: nationalIdProfile['gender'] ?? 'N/A',
      birthDate: nationalIdProfile['birthdate'] ?? 'N/A',
      isExpired: isExpired, // You need logic to determine this
      requestStatus: requestStatus,
    );
  }
}

// Generic Service Status
class ServiceStatus {
  final String requestStatus; // e.g. "NEW", "Approved", "Requested", "Declined"
  final bool hasDocument; // True if document/service exists for user

  ServiceStatus({required this.requestStatus, required this.hasDocument});

  factory ServiceStatus.fromJson(Map<String, dynamic> json) {
    return ServiceStatus(
      requestStatus: json['data'] != null && json['data'].isNotEmpty ? json['data'][0]['Request_Status'] : "NEW",
      hasDocument: json['status'] == 'success',
    );
  }
   factory ServiceStatus.empty() {
    return ServiceStatus(
      requestStatus: "NEW",
      hasDocument: false,
    );
  }
}