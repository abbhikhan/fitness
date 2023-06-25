import 'package:fitness/extensions/shared_extensions.dart';
import 'package:flutter/material.dart';

class ScaffoldWidget extends StatelessWidget {
  const ScaffoldWidget({
    super.key,
    required this.child,
    this.edgeInsets,
    this.useSingleChildScrollView = false,
    this.resizeToAvoidBottomInset = true,
    this.useCustomPadding = false,
  });

  final Widget child;
  final EdgeInsets? edgeInsets;
  final bool useSingleChildScrollView;
  final bool resizeToAvoidBottomInset;
  final bool useCustomPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: useSingleChildScrollView
            ? SingleChildScrollView(
                padding: edgeInsets ??
                    EdgeInsets.symmetric(
                      horizontal: useCustomPadding
                          ? context.width * 0.05
                          : context.width * 0.1,
                    ),
                child: child,
              )
            : Padding(
                padding: edgeInsets ??
                    EdgeInsets.symmetric(
                      horizontal: useCustomPadding
                          ? context.width * 0.05
                          : context.width * 0.054,
                    ),
                child: child,
              ),
      ),
    );
  }
}
