import 'package:bilfind_app/constants/app_constants.dart';
import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/screens/add_profile_photo/widgets/profile_photo_editor.dart';
import 'package:bilfind_app/screens/create_post/widgets/post_image_creator.dart';
import 'package:bilfind_app/services/user_service.dart';
import 'package:bilfind_app/widgets/app_bar/basic_app_bar.dart';
import 'package:bilfind_app/widgets/app_button.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';

class AddProfilePhotoScreen extends StatefulWidget {
  const AddProfilePhotoScreen({super.key});

  //final UserModel userModel;

  @override
  State<AddProfilePhotoScreen> createState() => _AddProfilePhotoScreenState();
}

class _AddProfilePhotoScreenState extends State<AddProfilePhotoScreen> {
  SelectedImage? selectedImage;
  bool isPhotoAdded = false;
  bool profilePageLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: ((Theme.of(context).brightness == Brightness.dark)
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            .copyWith(
          statusBarColor: Theme.of(context).colorScheme.background,
        ),
        child: Responsive(
          mobile: getMobileLayout(),
          tablet: getMobileLayout(),
          desktop: getDesktopLayout(),
        ),
      ),
    );
  }

  Widget getMobileLayout() {
    return Column(
      children: [
        const BasicAppBar(),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 32, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    // color: Color.fromARGB(234, 243, 251, 255),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add a Profile Photo",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 40),
                        Container(
                          height: 200,
                          child: ProfilePhotoEditor(
                            isPhotoAdded: isPhotoAdded,
                            isOwnUser: true,
                            isLoading: profilePageLoading,
                            imageUrl: AppConstants.defaultProfilePhoto,
                            onSaveClicked: onSaveProfilePhotoClicked,
                            selectedImage: selectedImage,
                            onEditClicked: onEditImageClicked,
                            onCancelClicked: onCancelProfilePhotoClicked,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: 200,
                          child: AppButton(
                            label: !isPhotoAdded ? "Skip" : "Done",
                            onPressed: () {
                              context.go("/search");
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getDesktopLayout() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      const BasicAppBar(),
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 32, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        // color: Color.fromARGB(234, 243, 251, 255),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add a Profile Photo",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 40),
                            Container(
                              height: 200,
                              child: ProfilePhotoEditor(
                                isPhotoAdded: isPhotoAdded,
                                isOwnUser: true,
                                isLoading: profilePageLoading,
                                imageUrl: AppConstants.defaultProfilePhoto,
                                onSaveClicked: onSaveProfilePhotoClicked,
                                selectedImage: selectedImage,
                                onEditClicked: onEditImageClicked,
                                onCancelClicked: onCancelProfilePhotoClicked,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: 200,
                              child: AppButton(
                                label: !isPhotoAdded ? "Skip" : "Done",
                                onPressed: () {
                                  context.go("/search");
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Image.asset(
                "assets/images/auth_image.png",
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  void onEditImageClicked() async {
    try {
      if (kIsWeb) {
        final ImagePickerPlugin _picker = ImagePickerPlugin();
        PickedFile image = await _picker.pickImage(source: ImageSource.gallery);
        Uint8List webImage = await image.readAsBytes();

        setState(() {
          isPhotoAdded = false;
          selectedImage = SelectedImage(imageToUse: webImage, path: image.path);
        });
      }
    } catch (e) {
      print("Something went wrong");
      print(e.toString());
    }
  }

  void onSaveProfilePhotoClicked() async {
    setState(() {
      profilePageLoading = true;
      isPhotoAdded = true;
    });
    if (selectedImage == null) {
      return;
    }
    await UserService.changeProfilePhoto(selectedImage!);
    //widget.userModel.profilePhoto = Program().userModel?.profilePhoto;
    setState(() {
      profilePageLoading = false;
      //selectedImage = null;
    });
  }

  void onCancelProfilePhotoClicked() async {
    setState(() {
      selectedImage = null;
      isPhotoAdded = false;
    });
  }
}
