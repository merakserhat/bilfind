import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/report_model.dart';
import 'package:bilfind_app/models/search_filter_model.dart';
import 'package:bilfind_app/screens/reported_posts/widgets/reported_post_item.dart';
import 'package:bilfind_app/screens/search/widgets/search_loading_shimmer.dart';
import 'package:bilfind_app/services/report_service.dart';
import 'package:bilfind_app/widgets/app_bar/authenticated_app_bar.dart';
import 'package:bilfind_app/widgets/custom_wrap.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:bilfind_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class UserReportedPostsScreen extends StatefulWidget {
  const UserReportedPostsScreen({super.key});

  @override
  State<UserReportedPostsScreen> createState() =>
      _UserReportedPostsScreenState();
}

class _UserReportedPostsScreenState extends State<UserReportedPostsScreen> {
  final TextEditingController textEditingController = TextEditingController();
  List<ReportModel>? reportedPosts;
  bool postsAreLoading = true;
  bool userRetrieved = false;

  @override
  void initState() {
    super.initState();
    if (Program().userModel != null) {
      userRetrieved = true;
      getData();
    } else {
      Program().retrieveUser().then((retrieved) {
        if (retrieved) {
          setState(() {
            userRetrieved = true;
          });
        } else {
          context.go("/auth");
        }
      }).then((value) => getData());
    }
  }

  getData() async {
    reportedPosts = await ReportService.getUserReports();
    setState(() {
      postsAreLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: ((Theme.of(context).brightness == Brightness.dark)
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            .copyWith(
          statusBarColor: Theme.of(context).colorScheme.background,
        ),
        child: !userRetrieved
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mutedWhite,
                ),
              )
            : Column(children: [
                const AuthenticatedAppBar(
                  
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  margin: const EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    "Reported Posts",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: AppColors.mutedWhite),
                  ),
                ),
                Expanded(child: Builder(builder: (context) {
                  return Responsive(
                    mobile: _getMobileLayout(context),
                    tablet: _getDesktopLayout(),
                    desktop: _getDesktopLayout(),
                  );
                })),
              ]),
      ),
    );
  }

  Widget _getMobileLayout(BuildContext context) {
    return postsAreLoading
        ? Expanded(child: SearchLoadingShimmer())
        : Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CustomWrap(
                widgets: reportedPosts!
                    .map(
                      (e) => ReportedPostItem(
                        reportModel: e,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
  }

  Widget _getDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        postsAreLoading
            ? Expanded(child: SearchLoadingShimmer())
            : Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomWrap(
                      contentPadding: EdgeInsets.all(10),
                      widgets: reportedPosts!
                          .map(
                            (e) => ReportedPostItem(
                              reportModel: e,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
