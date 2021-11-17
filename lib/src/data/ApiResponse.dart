import 'BaseResponse.dart';

class ApiResponse extends BaseResponse {
  bool status;
  String message;

  ApiResponse(this.status, this.message);

  ApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }

  @override
  String getMessage() {
    return message;
  }

  @override
  bool isSuccess() {
    return status;
  }
}
