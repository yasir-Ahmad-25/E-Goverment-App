class ServiceRequest {
  final String userId;
  final String serviceName;
  final Map<String, dynamic> formData; // all request data

  ServiceRequest({required this.userId, required this.serviceName, required this.formData});

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'serviceName': serviceName,
    'formData': formData,
  };
}
