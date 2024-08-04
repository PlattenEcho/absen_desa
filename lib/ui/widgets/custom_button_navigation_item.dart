import 'package:absen_desa/cubit/cubit.dart';
import 'package:absen_desa/ui/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomButtonNavigationItem extends StatelessWidget {
  final int index;
  final IconData iconData;

  const CustomButtonNavigationItem({
    Key? key,
    required this.iconData,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PageCubit>().setPage(index);
      },
      child: Container(
          width: MediaQuery.of(context).size.width / 6,
          decoration: BoxDecoration(
            color: (context.read<PageCubit>().state == index)
                ? kPrimaryLightColor
                : Colors.transparent,
          ),
          child: Center(
            child: Icon(
              iconData,
              size: 24,
              color: kPrimary2Color,
            ),
          )),
    );
  }
}
