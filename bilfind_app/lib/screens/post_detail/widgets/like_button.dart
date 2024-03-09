import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/post_model.dart';
import 'package:bilfind_app/services/user_service.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    Key? key,
    required this.favStateChanged,
    required this.isFav,
    required this.favCount,
  }) : super(key: key);

  final Function(bool) favStateChanged;
  final bool isFav;
  final int favCount;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);

  late int favCount;

  @override
  void initState() {
    super.initState();
    favCount = widget.favCount;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        favCount != 0
            ? Text(
                favCount.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: AppColors.mutedWhite),
              )
            : Container(),
        InkWell(
          onTap: () {
            setState(() {
              if (widget.isFav) {
                setState(() {
                  favCount--;
                });
              } else {
                setState(() {
                  favCount++;
                });
              }
              widget.favStateChanged(!widget.isFav);
            });
            _controller.reverse().then((value) => _controller.forward());
          },
          child: ScaleTransition(
            scale: Tween(begin: 0.7, end: 1.0).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
            child: widget.isFav
                ? const Icon(
                    Icons.favorite,
                    size: 30,
                    color: AppColors.mutedWhite,
                  )
                : const Icon(
                    Icons.favorite_border,
                    size: 30,
                    color: AppColors.mutedWhite,
                  ),
          ),
        ),
      ],
    );
  }
}
