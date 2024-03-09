import 'package:bilfind_app/constants/app_constants.dart';
import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/screens/create_post/widgets/post_image_creator.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/material.dart';

class ProfilePhotoSection extends StatelessWidget {
  const ProfilePhotoSection({
    Key? key,
    required this.isLoading,
    required this.imageUrl,
    required this.onEditClicked,
    this.selectedImage,
    required this.onSaveClicked,
    required this.onCancelClicked,
    required this.isOwnUser,
  }) : super(key: key);

  final bool isLoading;
  final String? imageUrl;
  final VoidCallback onEditClicked;
  final VoidCallback onCancelClicked;
  final VoidCallback onSaveClicked;
  final SelectedImage? selectedImage;

  final bool isOwnUser;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: selectedImage == null
                  ? Image.network(
                      imageUrl ?? AppConstants.defaultProfilePhoto,
                      fit: BoxFit.cover,
                    )
                  : Image.memory(
                      selectedImage!.imageToUse,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: isLoading
                ? Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(4),
                    margin:
                        EdgeInsets.all(Responsive.isMobile(context) ? 4 : 16),
                    child: const CircularProgressIndicator(
                      color: AppColors.mutedWhite,
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      selectedImage != null
                          ? InkWell(
                              onTap: onCancelClicked,
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.symmetric(
                                  vertical:
                                      Responsive.isMobile(context) ? 4 : 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: AppColors.black4,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.close_outlined,
                                    color: AppColors.mutedWhite,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      isOwnUser
                          ? InkWell(
                              onTap: selectedImage == null
                                  ? onEditClicked
                                  : onSaveClicked,
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.all(
                                    Responsive.isMobile(context) ? 4 : 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: selectedImage == null
                                      ? AppColors.black4
                                      : AppColors.bilkentBlue,
                                ),
                                child: Center(
                                  child: Icon(
                                    selectedImage == null
                                        ? Icons.edit
                                        : Icons.check,
                                    color: AppColors.mutedWhite,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
