import 'package:final_project_sanbercode/blocs/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:final_project_sanbercode/screen/order_list_screen.dart';
import 'package:final_project_sanbercode/screen/product/index.dart';
import 'package:final_project_sanbercode/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomBarCubit, BottomBarState>(
        builder: (context, state) {
          switch (state.index) {
            case 0:
              return const ProductIndexScreen();
            case 1:
              return const OrderListScreen();
            case 2:
              return const ProfileScreen();
            default:
              return const ProductIndexScreen();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<BottomBarCubit>().state.index,
        onTap: (value) {
          context.read<BottomBarCubit>().navigateTo(index: value);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "List Order"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
