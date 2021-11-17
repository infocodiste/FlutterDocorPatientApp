
import 'NetworkUtil.dart';

class ApiManager {
  static final ApiManager _apiManager = new ApiManager._internal();

  static ApiManager get() {
    return _apiManager;
  }

  ApiManager._internal();

  NetworkUtil _netUtil = new NetworkUtil();

  // // get login in server
  // Future<ParsedResponse<RegisterResponse>> register(
  //     String accountName,
  //     bool isModel,
  //     String email,
  //     String countryCode,
  //     String phone,
  //     String password) async {
  //   Map<String, dynamic> body = {
  //     "account_name": accountName,
  //     "is_model": isModel,
  //     "email": email,
  //     "country_code": countryCode,
  //     "phone": phone,
  //     "password": password,
  //   };
  //   return _netUtil
  //       .post("$API_BASE_URL/register", body: json.encode(body))
  //       .then((response) {
  //     RegisterResponse apiResponse = response.body != null
  //         ? new RegisterResponse.fromJson(response.body)
  //         : null;
  //     return new ParsedResponse(response.statusCode, apiResponse);
  //   });
  // }

  // // register and update profile of user
  // Future<ParsedResponse<RegisterResponse>> registerUser({
  //   bool isRegister,
  //   int userRole,
  //   String profilePic,
  //   String accountCompanyName,
  //   String name,
  //   String surname,
  //   String email,
  //   String countryCode,
  //   String phone,
  //   String password,
  //   String instagram,
  //   String facebook,
  //   String twitter,
  //   String companyRegNo,
  //   String companyAddress,
  //   String dob,
  //   Map modelMap,
  // }) async {
  //   Map<String, dynamic> body = {
  //     "role": userRole,
  //     "image": profilePic,
  //     "name": name,
  //     "surname": surname,
  //     "email": email,
  //     "country_code": countryCode,
  //     "phone": phone,
  //     "password": password
  //   };
  //   // if (isRegister) {
  //   //   body.addAll({"password": password});
  //   // }
  //   if (userRole == USER_TYPE.TALENT.index) {
  //     body.addAll({
  //       "account_name": accountCompanyName,
  //       "dob": dob,
  //       "instagram": instagram,
  //       "facebook": facebook,
  //       "twitter": twitter,
  //     });
  //     body.addAll(modelMap);
  //   } else if (userRole == USER_TYPE.AGENCY.index) {
  //     body.addAll({
  //       "company_name": accountCompanyName,
  //       "company_number": companyRegNo,
  //       "company_address": companyAddress,
  //     });
  //   } else if (userRole == USER_TYPE.CLIENT.index) {
  //     body.addAll({
  //       "company_name": accountCompanyName,
  //       "instagram": instagram,
  //       "facebook": facebook,
  //       "twitter": twitter,
  //     });
  //   }
  //   return _netUtil
  //       .post("$API_BASE_URL/${isRegister ? "register" : "update-profile"}",
  //           body: json.encode(body))
  //       .then((response) {
  //     RegisterResponse apiResponse = response.body != null
  //         ? new RegisterResponse.fromJson(response.body)
  //         : null;
  //     return new ParsedResponse(response.statusCode, apiResponse);
  //   });
  // }

}
