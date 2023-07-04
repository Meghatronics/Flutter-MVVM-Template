import '../../../../core/view_model/data_response.dart';
import '../../../shared/widgets/app_phone_number_field.dart';
import '../models/login_dto.dart';
import '../models/signup_dto.dart';
import '../models/successful_login_model.dart';
import '../models/user_model.dart';

abstract class AuthenticationRepository {
  Future<DataResponse<SuccessfulLoginModel>> login({
    required LoginDto login,
  });

  Future<DataResponse<SuccessfulLoginModel>> refreshLogin({
    required String refreshToken,
  });

  Future<DataResponse<SuccessfulLoginModel>> signup(
    SignupDto signup,
    UserType type,
  );

  Future<DataResponse<bool>> sendVerificationOtp(
    CountryModel country,
    String phone,
  );

  Future<DataResponse<bool>> confirmVerificationOtp({
    required String otp,
    required CountryModel country,
    required String phone,
  });
}
