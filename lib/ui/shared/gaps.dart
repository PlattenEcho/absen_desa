import 'package:flutter/material.dart';

SizedBox gapW(double n) => SizedBox(width: n);
SizedBox gapH(double n) => SizedBox(height: n);

const gapW4 = SizedBox(width: 4);
const gapW8 = SizedBox(width: 8);
const gapW12 = SizedBox(width: 12);
const gapW24 = SizedBox(width: 24);
const gapW32 = SizedBox(width: 32);
const gapW64 = SizedBox(width: 64);

const gapH4 = SizedBox(height: 4);
const gapH8 = SizedBox(height: 8);
const gapH12 = SizedBox(height: 12);
const gapH24 = SizedBox(height: 24);
const gapH32 = SizedBox(height: 32);
const gapH64 = SizedBox(height: 64);

double parentW(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double parentH(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
