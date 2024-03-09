import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/constants/enums.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/user_model.dart';
import 'package:bilfind_app/screens/create_post/widgets/post_image_creator.dart';
import 'package:bilfind_app/screens/profile_page/widgets/profile_photo_section.dart';
import 'package:bilfind_app/screens/profile_page/widgets/user_info_dropdown_item.dart';
import 'package:bilfind_app/screens/profile_page/widgets/user_info_item.dart';
import 'package:bilfind_app/services/admin_service.dart';
import 'package:bilfind_app/services/user_service.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:bilfind_app/widgets/app_button.dart';
import 'package:bilfind_app/widgets/popups/warning_popup.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:intl/intl.dart';

class InformationSection extends StatefulWidget {
  const InformationSection({
    super.key,
    required this.userModel,
    required this.isOwnUser,
  });

  final UserModel userModel;
  final bool isOwnUser;

  @override
  State<InformationSection> createState() => _InformationSectionState();
}

class _InformationSectionState extends State<InformationSection> {
  bool profilePageLoading = false;
  bool isEditing = false;
  SelectedImage? selectedImage;
  Departments? postDepartment;
  late TextEditingController nameController;
  bool editLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: "${widget.userModel.name} ${widget.userModel.familyName}");
    postDepartment = Departments.values.firstWhere(
        (e) => e.toString().split('.')[1] == widget.userModel.departmant);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.primary,
      ),
      child: Responsive(
        mobile: getMobileView(),
        tablet: getMobileView(),
        desktop: getDesktopView(),
      ),
    );
  }

  Widget getMobileView() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 100,
                    child: ProfilePhotoSection(
                      isOwnUser: widget.isOwnUser,
                      isLoading: profilePageLoading,
                      imageUrl: widget.userModel.profilePhoto,
                      onSaveClicked: onSaveProfilePhotoClicked,
                      selectedImage: selectedImage,
                      onEditClicked: onEditImageClicked,
                      onCancelClicked: onCancelProfilePhotoClicked,
                    ),
                  ),
                  SizedBox(height: 24),
                  widget.isOwnUser
                      ? AppButton(
                          label: "Edit",
                          color: AppColors.black4,
                          onPressed: onEditClicked,
                        )
                      : Container(),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    UserInfoItem(
                      label: "Full Name",
                      info:
                          "${widget.userModel.name} ${widget.userModel.familyName}",
                      isEditing: isEditing,
                      textEditingController: nameController,
                    ),
                    UserInfoItem(label: "Email", info: widget.userModel.email),
                    UserInfoDropdownItem(
                      label: "Departments",
                      info: widget.userModel.departmant,
                      isEditing: isEditing,
                      onChanged: (Departments? value) {
                        setState(() {
                          postDepartment = value;
                        });
                      },
                      item: postDepartment,
                    ),
                    UserInfoItem(
                      label: "Registration Date",
                      info: DateFormat('dd/MM/yyyy')
                          .format(widget.userModel.createdAt),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getDesktopView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ProfilePhotoSection(
                isOwnUser: widget.isOwnUser,
                isLoading: profilePageLoading,
                imageUrl: widget.userModel.profilePhoto,
                onSaveClicked: onSaveProfilePhotoClicked,
                selectedImage: selectedImage,
                onEditClicked: onEditImageClicked,
                onCancelClicked: onCancelProfilePhotoClicked,
              ),
              //     const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    UserInfoItem(
                      label: "Full Name",
                      info:
                          "${widget.userModel.name} ${widget.userModel.familyName}",
                      isEditing: isEditing,
                      textEditingController: nameController,
                    ),
                    UserInfoItem(label: "Email", info: widget.userModel.email),
                    UserInfoDropdownItem(
                      label: "Departments",
                      info: widget.userModel.departmant,
                      isEditing: isEditing,
                      onChanged: (Departments? value) {
                        setState(() {
                          postDepartment = value;
                        });
                      },
                      item: postDepartment,
                    ),
                    UserInfoItem(
                        label: "Registration Date",
                        info: DateFormat('dd/MM/yyyy')
                            .format(widget.userModel.createdAt)),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: 500,
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: widget.isOwnUser
                ? editLoading
                    ? CircularProgressIndicator(color: AppColors.mutedWhite)
                    : AppButton(
                        label: isEditing ? "Save" : "Edit",
                        color: AppColors.black4,
                        onPressed: onEditClicked,
                      )
                : Program().userModel!.isAdmin
                    ? SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: widget.userModel.latestStatus == "BANNED"
                              ? "Remove Ban"
                              : "Ban",
                          color: Colors.red,
                          onPressed: () => onBanUserClicked(
                              widget.userModel.latestStatus == "BANNED"
                                  ? "Remove the Ban of User"
                                  : "Ban User",
                              widget.userModel.latestStatus == "BANNED"
                                  ? "Are you sure you want to remove the ban of this account?"
                                  : "Are you sure you want to ban this account?",
                              widget.userModel.latestStatus == "BANNED"
                                  ? "Remove Ban"
                                  : "Ban"),
                        ),
                      )
                    : Container(),
          ),
        ],
      ),
    );
  }

  onBanUserClicked(String title, String content, String approveLabel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WarningPopup(
          title: "Ban Account",
          content: "Are you sure you want to ban this account?",
          approveLabel: "Ban",
          onApproved: () => onBanUserApproved(userId: widget.userModel.id),
          isAsync: true,
        );
      },
    );
    //context.go(location)
  }

  onBanUserApproved({required String userId}) async {
    setState(() {});
    await AdminService.banUser(userId);
    context.go(RouteGenerator().searchRoute);
  }

  void onEditClicked() {
    if (!isEditing) {
      setState(() {
        isEditing = true;
      });
    } else {
      onSaveUser();
    }
  }

  void onSaveUser() async {
    await UserService.editUser(nameController.text, postDepartment!.name);
    context.go("/user/${Program().userModel!.id}");
  }

  void onEditImageClicked() async {
    try {
      if (kIsWeb) {
        final ImagePickerPlugin _picker = ImagePickerPlugin();
        PickedFile image = await _picker.pickImage(source: ImageSource.gallery);
        Uint8List webImage = await image.readAsBytes();

        setState(() {
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
    });
    if (selectedImage == null) {
      return;
    }
    await UserService.changeProfilePhoto(selectedImage!);
    widget.userModel.profilePhoto = Program().userModel?.profilePhoto;
    setState(() {
      selectedImage = null;
      profilePageLoading = false;
    });
  }

  void onCancelProfilePhotoClicked() async {
    setState(() {
      selectedImage = null;
    });
  }
}
