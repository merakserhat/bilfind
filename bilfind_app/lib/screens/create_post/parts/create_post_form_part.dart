import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/post_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/screens/auth/auth_screen.dart';
import 'package:bilfind_app/screens/create_post/widgets/post_form.dart';
import 'package:bilfind_app/screens/post_detail/widgets/post_item.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/material.dart';

class CreatePostFormPart extends StatefulWidget {
  const CreatePostFormPart({super.key, required this.type, this.postModel});

  final String type;
  final PostModel? postModel;

  @override
  State<CreatePostFormPart> createState() => _CreatePostFormPartState();
}

class _CreatePostFormPartState extends State<CreatePostFormPart> {
  late PostModel mockPostModel;
  bool previewActive = false;
  bool userRetrieved = false;
  final Duration animationDuration = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    if (widget.postModel != null) {
      mockPostModel = widget.postModel!;
    } else {
      mockPostModel = PostModel(
        id: "0",
        userId: "",
        title: "",
        content: "",
        images: [],
        createdAt: DateTime.now(),
        type: widget.type,
        isMock: true,
        ownerName: Program().userModel!.name,
        ownerEmail: Program().userModel!.email,
        ownerDepartment: Program().userModel!.departmant,
        ownerPhoto: Program().userModel!.profilePhoto,
        ownerUserId: Program().userModel!.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: _getMobileLayout(),
        tablet: _getDesktopLayout(),
        desktop: _getDesktopLayout());
  }

  _getMobileLayout() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: animationDuration,
            width: previewActive ? 0 : 300,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: PostForm(
                  type: widget.type,
                  postModel: widget.postModel,
                  setMockModel: (postModel) {
                    setState(() {
                      mockPostModel = postModel;
                    });
                  }),
            ),
          ),
          _getOpenButton(),
          Container(
            width: MediaQuery.of(context).size.width - 64,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Preview",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: AppColors.subText),
                ),
                const SizedBox(height: 12),
                AspectRatio(
                  aspectRatio: 0.6,
                  child: Center(
                    child: PostItem(
                      postModel: mockPostModel,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _getDesktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostForm(
            type: widget.type,
            postModel: widget.postModel,
            setMockModel: (postModel) {
              setState(() {
                mockPostModel = postModel;
              });
            }),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(36),
            //color: const Color.fromARGB(255, 255, 68, 1),
            child: Center(
              child: PostItem(
                postModel: mockPostModel,
                isDetail: true,
              ),
            ),
          ),
        )
      ],
    );
  }

  _getOpenButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          previewActive = !previewActive;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColors.mutedWhite,
        ),
        child: Center(
          child: Icon(
            previewActive
                ? Icons.keyboard_arrow_right
                : Icons.keyboard_arrow_left,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
