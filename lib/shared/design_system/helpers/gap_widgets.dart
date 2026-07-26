import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  final double size;

  const Gap(this.size, {super.key});

  const Gap.s4({super.key}) : size = 4.0;
  const Gap.s8({super.key}) : size = 8.0;
  const Gap.s12({super.key}) : size = 12.0;
  const Gap.s16({super.key}) : size = 16.0;
  const Gap.s24({super.key}) : size = 24.0;
  const Gap.s32({super.key}) : size = 32.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size);
  }
}
