import 'package:final_project_sanbercode/blocs/auth_bloc/auth_bloc.dart';
import 'package:final_project_sanbercode/blocs/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:final_project_sanbercode/blocs/count_cart_cubit/count_cart_cubit.dart';
import 'package:final_project_sanbercode/blocs/order_bloc/order_bloc.dart';
import 'package:final_project_sanbercode/blocs/cart_bloc/cart_bloc.dart';
import 'package:final_project_sanbercode/blocs/payment_list_cubit/payment_list_cubit.dart';
import 'package:final_project_sanbercode/blocs/image_cubit/images_cubit.dart';
import 'package:final_project_sanbercode/blocs/product_bloc/product_bloc.dart';
import 'package:final_project_sanbercode/blocs/user_bloc/user_bloc.dart';
import 'package:final_project_sanbercode/const/palllete.dart';
import 'package:final_project_sanbercode/service/product_service.dart';
import 'package:final_project_sanbercode/utils/auth_wrapper.dart';
import 'package:final_project_sanbercode/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(AuthCheckOnboarding()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(productService: ProductService()),
        ),
        BlocProvider(
          create: (context) => CartBloc()..add(LoadCart()),
        ),
        BlocProvider(
          create: (context) => UserBloc()..add(ReadUserData()),
        ),
        BlocProvider(
          create: (context) => OrderBloc()..add(ReadOrderEvent()),
        ),
        BlocProvider(
          create: (context) => PaymentListCubit()..load_payment_list(),
        ),
        BlocProvider(
          create: (context) => ImagesCubit(),
        ),
        BlocProvider(
          create: (context) => BottomBarCubit(),
        ),
        BlocProvider<CountCartCubit>(
          create: (_) => CountCartCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Final Project',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Pallete.secondary),
          scaffoldBackgroundColor: Pallete.whiteColor,
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
