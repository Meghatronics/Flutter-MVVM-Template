import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../presentation.dart';
import 'app_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    final showBackButton = AppNavigator(context).canPop;
    final horizontalPad = showBackButton ? 64.0 : 32.0;
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          if (showBackButton)
            const Positioned(
              left: 12,
              bottom: 24,
              width: 64,
              child: AppBackButton(),
            ),
          Positioned(
            bottom: 24,
            right: horizontalPad,
            left: horizontalPad,
            child: Text(
              title,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.of(context).heading32Bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(88);
}
