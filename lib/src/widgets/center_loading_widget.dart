import 'package:flutter/material.dart';

/// A simple centered circular progress indicator.
class CenterLoadingWidget extends StatelessWidget {
  const CenterLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
