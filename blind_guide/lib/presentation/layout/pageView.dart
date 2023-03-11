
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blind_guide/bloc/appCubit.dart';
import 'package:blind_guide/bloc/appState.dart';


class PageViewScreen extends StatefulWidget {

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {


  // @override
  // void dispose() {
  //   _pageController!.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    return BlocBuilder<AppCubit,AppState>(builder: (context,state)=>Scaffold(
      appBar: AppBar(
        title: Text(cubit.titles[cubit.currentPageIndex]),
      ),
      body: PageView(
        controller: cubit.pageController,
        onPageChanged: (int index)=>cubit.changePageViewIndex(index),
        children: cubit.screensList,)
    ));
  }

  }
