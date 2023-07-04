import 'package:flutter/material.dart';

import '../../../../core/views/app_view_builder.dart';
import '../../../../utilities/mixins/validator_mixin.dart';
import '../../../shared/components/app_button_widget.dart';
import '../../../shared/components/app_text_field.dart';
import '../../domain/view_models/forgot_password_view_model.dart';
import '../widgets/white_title_bar.dart';

class ForgotPasswordSetNewView extends StatelessWidget with ValidatorMixin {
  const ForgotPasswordSetNewView(this.vm, {super.key});

  final ForgotPasswordViewModel vm;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, kToolbarHeight * 1.5, 16, 16),
        child: Column(
          children: [
            const WhiteTitleBar(
              heading: 'Create New Password',
              subHeading: 'Please enter a new password.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 12),
                child: AppViewBuilder<ForgotPasswordViewModel>(
                  model: vm,
                  builder: (forgotPasswordVm, _) => Form(
                    key: vm.formKeys[2],
                    child: Column(
                      children: [
                        AppTextField.secret(
                          controller: forgotPasswordVm.newPasswordField,
                          label: 'New Password',
                          hint: 'At least 8 characters',
                          isRequired: true,
                          validator: validatePassword,
                          validatorMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 16),
                        AppTextField.secret(
                          controller: forgotPasswordVm.confirmPasswordField,
                          label: 'Confirm Password',
                          hint: 'At least 8 characters',
                          isRequired: true,
                          validator: (cf) => validateConfirmPassword(
                            cf,
                            forgotPasswordVm.newPasswordField.text,
                          ),
                        ),
                        const SizedBox(height: 32),
                        AppButton(
                          label: 'Submit',
                          busy: forgotPasswordVm.isBusy,
                          onPressed: forgotPasswordVm.resetPassword,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
