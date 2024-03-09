import 'package:bilfind_app/models/post_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/search_filter_model.dart';
import 'package:bilfind_app/screens/auth/auth_screen.dart';
import 'package:bilfind_app/screens/post_detail/widgets/post_item.dart';
import 'package:bilfind_app/services/auth_service.dart';
import 'package:bilfind_app/screens/search/widgets/search_loading_shimmer.dart';
import 'package:bilfind_app/services/post_service.dart';
import 'package:bilfind_app/utils/routing/custom_route.dart';
import 'package:bilfind_app/widgets/app_bar/authenticated_app_bar.dart';
import 'package:bilfind_app/widgets/custom_wrap.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:bilfind_app/widgets/search_bar.dart';
import 'package:bilfind_app/widgets/side_bar/filter_side_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static CustomRoute customRoute = CustomRoute(route: "/search");

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController textEditingController = TextEditingController();
  List<PostModel>? posts;
  bool postsAreLoading = true;
  bool filterOpen = false;
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
    posts = await PostService.getPostList();
    if (mounted) {
      setState(() {
        postsAreLoading = false;
      });
    }
  }

  onFilterApplied(SearchFilterModel searchFilterModel) async {
    setState(() {
      postsAreLoading = true;
    });
    posts = await PostService.getPostList(
        searchFilter: searchFilterModel.generateQueryParameters());
    setState(() {
      postsAreLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: FilterSideBar(
        onFilterApplied: onFilterApplied,
        searchBarController: textEditingController,
      ),
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
            : Column(
                children: [
                  AuthenticatedAppBar(
                    searchBar: CustomSearchBar(
                      hint: "Search content or user @username",
                      callbackFunction: (value) {},
                      controller: textEditingController,
                      onSearched: onSearched,
                    ),
                  ),
                  Expanded(
                    child: Builder(builder: (context) {
                      return Responsive(
                        mobile: _getMobileLayout(context),
                        tablet: _getDesktopLayout(),
                        desktop: _getDesktopLayout(),
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }

  onSearched(String key) async {
    if (key.isEmpty) {
      return;
    }
    setState(() {
      postsAreLoading = true;
    });
    SearchFilterModel searchFilterModel = SearchFilterModel();
    searchFilterModel.key = key;
    posts = await PostService.getPostList(
        searchFilter: searchFilterModel.generateQueryParameters());
    setState(() {
      postsAreLoading = false;
    });
  }

  Widget _getMobileLayout(BuildContext context) {
    return postsAreLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.mutedWhite,
            ),
          )
        : Column(
            children: [
              Container(
                width: double.infinity,
                height: 32,
                color: AppColors.primary,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "Add Filter",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: AppColors.mutedWhite),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: CustomWrap(
                      widgets: posts!
                          .map(
                            (e) => PostItem(
                              postModel: e,
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

  Widget _getDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSideBar(
          onFilterApplied: onFilterApplied,
          searchBarController: textEditingController,
        ),
        postsAreLoading
            ? Expanded(child: SearchLoadingShimmer())
            : Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomWrap(
                      contentPadding: EdgeInsets.all(16),
                      widgets: posts!
                          .map(
                            (e) => PostItem(
                              postModel: e,
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
