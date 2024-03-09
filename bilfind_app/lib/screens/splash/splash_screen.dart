import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/services/app_client.dart';
import 'package:bilfind_app/services/auth_service.dart';
import 'package:bilfind_app/services/local_service.dart';
import 'package:bilfind_app/utils/routing/custom_route.dart';
import 'package:bilfind_app/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //means at least show this screen 2 seconds when app is opening
  late bool tokenValidated = false;
  bool minDurationPassed = false;

  // TODO remove
  String page = "Splash";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => initializeAuthentication());
    Future.delayed(Duration(seconds: 1), () {
      if (tokenValidated) {
        context.go("/search");
        setState(() {
          page = "Home";
        });
        return;
      }

      minDurationPassed = true;
    });
  }

  void initializeAuthentication() {
    LocalService().getToken().then((token) {
      Program().token = token;
      if (token == null || token.isEmpty) {
        context.go("/auth");
        return;
      }

      AuthService.validateToken().then(
        (validated) {
          print(validated);

          if (validated) {
            AppClient().token = token;
            if (minDurationPassed) {
              context.go("/search");
              setState(() {
                page = "Home";
              });
              return;
            }

            setState(() {
              tokenValidated = true;
            });
          } else {
            context.go("/auth");
          }
        },
      ).catchError((error) {});
    }).catchError(
      (error) {
        return;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(page),
              const Text(
                "This page is initially left blank for now. \n Creating a home page for unatuhanticated users to see what we are doing and some images etc",
                softWrap: true,
              ),
              AppButton(
                  label: "Login",
                  onPressed: () {
                    context.go("/auth");
                  })
            ],
          ),
        ),
      ),
    );
  }
}
