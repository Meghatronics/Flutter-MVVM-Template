import '../../../shared/session_manager.dart';
import 'user_model.dart';

class SuccessfulLoginModel {
  final UserModel user;
  final AuthToken tokenData;

  SuccessfulLoginModel({
    required this.user,
    required this.tokenData,
  });

  factory SuccessfulLoginModel.fromMap(Map<String, dynamic> map) {
    return SuccessfulLoginModel(
      user: UserModel.fromMap(map['user']),
      tokenData: AuthToken.fromMap(map),
    );
  }
}
