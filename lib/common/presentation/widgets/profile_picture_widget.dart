import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

import '../presentation.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({
    super.key,
    this.image,
    this.size = 48,
  });
  final double size;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.of(context).grey4,
      ),
      clipBehavior: Clip.hardEdge,
      child: image != null
          ? Image(
              image: image!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                Logger(runtimeType.toString()).severe(
                  'Failed to render profile image',
                  error,
                  stackTrace,
                );
                return Icon(
                  CupertinoIcons.person_alt_circle,
                  size: size,
                  color: AppColors.of(context).alternateColor,
                );
              },
            )
          : Icon(
              CupertinoIcons.person_alt_circle,
              size: size,
              color: AppColors.of(context).alternateColor,
            ),
    );
  }
}
