import 'dart:html';

import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/widgets/custom_wrap.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';

class PostImageCreator extends StatelessWidget {
  const PostImageCreator({
    super.key,
    required this.selectedImages,
    required this.onChange,
    required this.previousImages,
    required this.onDeletePrevious,
  });

  final List<SelectedImage> selectedImages;
  final List<String> previousImages;
  final Function(SelectedImage) onChange;
  final Function(String) onDeletePrevious;
  final double height = 200;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.black6, width: 1),
          borderRadius: BorderRadius.circular(5)),
      child: Builder(builder: (context) {
        Widget child = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomWrap(
              cs: getImageCount() == 0
                  ? 1
                  : getImageCount() > 1
                      ? 3
                      : 2,
              widgets: [
                _getUploadImage(context),
                ...previousImages.map((e) => Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            e,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              print("object");
                              print(previousImages.length);
                              onDeletePrevious(e);
                              print(previousImages.length);
                            },
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.secondary,
                              foregroundColor: AppColors.mutedWhite,
                              child: Icon(
                                Icons.close,
                                color: AppColors.mutedWhite,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                ...selectedImages.map((e) => Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Image.memory(
                            e.imageToUse,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              onChange(e);
                            },
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.secondary,
                              foregroundColor: AppColors.mutedWhite,
                              child: Icon(
                                Icons.close,
                                color: AppColors.mutedWhite,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        );

        if (getImageCount() > 1) {
          return SingleChildScrollView(
            child: child,
          );
        }

        return child;
      }),
    );
  }

  Widget _getUploadImage(BuildContext context) {
    Widget child = InkWell(
      onTap: () async {
        try {
          if (kIsWeb) {
            final ImagePickerPlugin _picker = ImagePickerPlugin();
            PickedFile image =
                await _picker.pickImage(source: ImageSource.gallery);
            Uint8List webImage = await image.readAsBytes();

            SelectedImage selectedImage =
                SelectedImage(imageToUse: webImage, path: image.path);
            onChange(selectedImage);
          }
        } catch (e) {
          print("Something went wrong");
          print(e.toString());
        }
      },
      child: Container(
        height: getImageCount() == 0 ? height - 20 : null,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: getImageCount() == 0 ? AppColors.primary : AppColors.black4,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.secondary,
              ),
              child: Center(
                child: Icon(
                  getImageCount() == 0
                      ? Icons.photo_library_outlined
                      : Icons.add,
                  color: AppColors.mutedWhite,
                ),
              ),
            ),
            getImageCount() == 0 ? const SizedBox(height: 8) : Container(),
            getImageCount() == 0
                ? Text(
                    "Add Photos",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.mutedWhite),
                  )
                : Container(),
          ],
        ),
      ),
    );

    if (getImageCount() == 0) {
      return child;
    }

    return AspectRatio(
      aspectRatio: 1,
      child: child,
    );
  }

  int getImageCount() {
    return selectedImages.length + previousImages.length;
  }
}

class SelectedImage extends Equatable {
  final Uint8List imageToUse;
  final String path;

  SelectedImage({required this.imageToUse, required this.path});

  @override
  List<Object?> get props => [path];
}
