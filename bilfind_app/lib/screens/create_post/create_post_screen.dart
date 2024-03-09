import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/post_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/response/get_post_detail_response.dart';
import 'package:bilfind_app/screens/auth/auth_screen.dart';
import 'package:bilfind_app/screens/create_post/parts/create_post_form_part.dart';
import 'package:bilfind_app/screens/create_post/parts/type_selection_part.dart';
import 'package:bilfind_app/screens/not_found/not_found_page.dart';
import 'package:bilfind_app/services/post_service.dart';
import 'package:bilfind_app/utils/routing/custom_route.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:bilfind_app/widgets/app_bar/go_back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key, this.postId});
  final String? postId;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String? selectedType;
  PostModel? postModel;

  bool dataLoading = true;
  bool getDataRan = false;
  bool postRetrieveError = false;

  getData() async {
    getDataRan = true;

    bool userRetrieved = await Program().retrieveUser();

    // go to auth if not authorised
    if (!userRetrieved) {
      return context.go(RouteGenerator().authRoute);
    }

    if (widget.postId == null) {
      setState(() {
        dataLoading = false;
      });
      return;
    }

    String postId = widget.postId!;
    print(postId);

    GetPostDetailResponse? getPostDetailResponse =
        await PostService.getPostDetail(postId);
    if (getPostDetailResponse == null) {
      setState(() {
        dataLoading = false;
        postRetrieveError = true;
      });
      return;
    }

    if (getPostDetailResponse!.postModel.ownerEmail !=
        Program().userModel!.email) {
      print("This post is not belong to this user.");
      setState(() {
        dataLoading = false;
        postRetrieveError = true;
      });
      return;
    }

    // we retrieved post
    setState(() {
      postModel = getPostDetailResponse.postModel;
      selectedType = postModel!.type;
      dataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!getDataRan) {
        getData();
      }
    });
    return Scaffold(
      backgroundColor: Color(0xff18191A),
      body: Column(
        children: [
          GoBackAppBar(onPop: onPop),
          dataLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mutedWhite,
                  ),
                )
              : postRetrieveError
                  ? _getPostRetrieveError()
                  : selectedType != null
                      ? Expanded(
                          child: CreatePostFormPart(
                            type: selectedType!,
                            postModel: postModel,
                          ),
                        )
                      : Expanded(
                          child: TypeSelectionPart(onSelected: onSelected))
        ],
      ),
    );
  }

  _getPostRetrieveError() {
    return const Center(
      child: Text("Post not found with given id"),
    );
  }

  onSelected(String type) {
    setState(() {
      selectedType = type;
    });
  }

  onPop() {
    if (widget.postId == null) {
      if (selectedType == null) {
        context.go(RouteGenerator().searchRoute);
      } else {
        context.go(RouteGenerator().createRoute);
      }
      setState(() {
        selectedType = null;
      });
    }
  }
}
