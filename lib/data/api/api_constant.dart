class ApiConstant {
  static const baseUrl = "http://10.0.2.2:3000/api";

  static const header = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  static const headerForm = {
    "Content-Type": "application/x-www-form-urlencoded",
    "Accept": "application/json",
  };
  static const headerMultipart = {
    "Content-Type": "multipart/form-data",
    "Accept": "application/json",
  };
}
