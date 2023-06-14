// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingManager extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  const LoadingManager({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading
            ? Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.7),
                child: const SpinKitFadingFour(
                  color: Colors.white,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
