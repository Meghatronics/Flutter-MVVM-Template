import 'package:flutter/material.dart';
import '../../../../common/presentation/presentation.dart';
import '../widgets/countdown_timer_display_widget.dart';

import '../../domain/view_models/forgot_password_view_model.dart';
import '../widgets/otp_text_field.dart';
import '../widgets/white_title_bar.dart';

class ForgotPasswordOtpView extends StatelessWidget {
  const ForgotPasswordOtpView(this.vm, {super.key});

  final ForgotPasswordViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, kToolbarHeight * 1.5, 16, 16),
        child: AppViewBuilder<ForgotPasswordViewModel>(
          model: vm,
          builder: (forgotPasswordVm, _) => Column(
            children: [
              WhiteTitleBar(
                heading: 'Enter the ${forgotPasswordVm.codeLength}-digit Code',
                subHeading: 'Please enter the verification code '
                    'you received at ${forgotPasswordVm.credString}',
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.only(top: 12),
                child: Form(
                  key: forgotPasswordVm.formKeys[1],
                  child: Column(
                    children: [
                      OtpTextField(
                        length: forgotPasswordVm.codeLength,
                        controller: forgotPasswordVm.otpField,
                        onCompleted: (_) => forgotPasswordVm.verifyOtp(),
                        validator: (otp) {
                          if (otp.isEmpty) {
                            return 'Verification code cannot be empty';
                          }
                          if (otp.length < forgotPasswordVm.codeLength) {
                            return 'Cannot be less than ${forgotPasswordVm.codeLength} digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      if (forgotPasswordVm.isBusy)
                        const SizedBox(height: 16)
                      else
                        CountdownTimerDisplayWidget.fromDateTime(
                          forgotPasswordVm.resendCodeAvailableAt,
                          format: 'mm:ss',
                          style: AppStyles.of(context).textStyle.copyWith(
                                color: AppColors.of(context).bodyText,
                              ),
                          prefix: Text(
                            'Resend Code in ',
                            style: AppStyles.of(context).textStyle.copyWith(
                                  color: AppColors.of(context).bodyText,
                                ),
                          ),
                          expiredWidget: InkResponse(
                            onTap: forgotPasswordVm.resendResetOtp,
                            child: Text(
                              'Resend Code',
                              style: AppStyles.of(context).textStyle.copyWith(
                                    color: AppColors.of(context).bodyText,
                                  ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      AppButton(
                        label: 'Submit',
                        busy: forgotPasswordVm.isBusy,
                        onPressed: forgotPasswordVm.verifyOtp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
