import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeaderWidget extends ConsumerStatefulWidget {
  final List products;
  const HeaderWidget(this.products, {super.key});

  @override
  ConsumerState<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends ConsumerState<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [],
    );
  }
}
