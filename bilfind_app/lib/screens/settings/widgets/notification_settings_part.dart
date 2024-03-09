import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/screens/settings/widgets/dropdown_setting_item.dart';
import 'package:bilfind_app/screens/settings/widgets/notification_choice_item.dart';
import 'package:bilfind_app/services/user_service.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationSettingsPart extends StatefulWidget {
  const NotificationSettingsPart({super.key});

  @override
  State<NotificationSettingsPart> createState() =>
      _NotificationSettingsPartState();
}

class _NotificationSettingsPartState extends State<NotificationSettingsPart> {
  bool isOpen = false;
  bool isAllPicked = true;
  bool userRetrieved = false;
  bool isNecessaryPicked = false;
  bool isNonePicked = false;
  String choice = "";

  @override
  void initState() {
    super.initState();

    if (Program().userModel != null) {
      userRetrieved = true;
    } else {
      Program().retrieveUser().then((retrieved) {
        if (retrieved) {
          setState(() {
            userRetrieved = true;
          });
          choice = Program().userModel!.mailSubscription ? "All" : "None";
        } else {
          context.go("/auth");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(Program().userModel?.mailSubscription);
    return Row(
      children: [
        !Responsive.isMobile(context)
            ? Flexible(
                flex: 3,
                child: Container(
                  color: AppColors.backgroundColor,
                ))
            : SizedBox(width: 12),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text("Notification Settings",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: AppColors.mutedWhite)),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isOpen ? 200 : 70,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.primary),
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        DropdownSettingItem(
                            settingTitle: "Email",
                            isOpen: isOpen,
                            choice: choice),
                        if (isOpen && userRetrieved)
                          Column(
                            children: [
                              const SizedBox(height: 4),
                              InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    print("annen");

                                    if (!Program()
                                        .userModel!
                                        .mailSubscription) {
                                      choice = "All";
                                      UserService.changeNotificationSettings(
                                          true);
                                      Program().userModel!.mailSubscription =
                                          true;
                                    }
                                    setState(() {});
                                  },
                                  child: NotificationChoiceItem(
                                      choiceTitle: "All",
                                      isPicked: Program()
                                          .userModel!
                                          .mailSubscription)),
                              Container(
                                height: 0.5,
                                color: AppColors.mutedWhite,
                              ),
                              InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    print("baban");
                                    if (Program().userModel!.mailSubscription) {
                                      choice = "None";
                                      UserService.changeNotificationSettings(
                                          false);
                                      Program().userModel!.mailSubscription =
                                          false;
                                    }
                                    setState(() {});
                                  },
                                  child: NotificationChoiceItem(
                                      choiceTitle: "None",
                                      isPicked: !Program()
                                          .userModel!
                                          .mailSubscription)),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        !Responsive.isMobile(context)
            ? Flexible(
                flex: 3,
                child: Container(
                  color: AppColors.backgroundColor,
                ))
            : SizedBox(width: 12),
      ],
    );
  }
}
