class Validators {
  static bool isValidId(String? id) {
    return id != null && id != '0' && id.trim().isNotEmpty;
  }
}