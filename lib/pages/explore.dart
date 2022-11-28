import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app/constants/constants.dart';
import 'package:news_app/core/color_extension.dart';
import 'package:news_app/core/context_extension.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/services/app_services.dart';
import 'package:news_app/utils/locale_keys.dart';
import 'package:news_app/widgets/custom_appbar.dart';
import 'package:news_app/widgets/cutom_textfiled.dart';
import 'package:news_app/widgets/search_card.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  TextEditingController searchController = TextEditingController();

  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  //late ScrollController _controller;
  int _page = 1;
  late String searchText;
  bool isSearch = false;
  List<ArticleModelArticles> searchList = [];

  search(value) {
    return FutureBuilder(
      future: AppService.searchArticles(value, _page),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          searchList = snapshot.data!;
          return searchList.isNotEmpty
              ? ListView.builder(
                  //controller: _controller,
                  itemCount: searchList.length,
                  itemBuilder: (context, index) {
                    var currentArticle = searchList[index];
                    return SearchListTitle(articleModel: currentArticle);
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: context.width * 0.4,
                        child: Image.asset(
                          "assets/images/not_found.png",
                          fit: BoxFit.fitWidth,
                        )),
                    context.emptyMediumWidget,
                    Text(
                        "\"$searchText\"    ",
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 14,
                          height: 1.8,
                          fontWeight: FontWeight.w500,
                          color: context.colors.orangeColor,
                        )),
                    context.emptyHighWidget
                  ],
                );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        centerTitle: true,
      ),
      body: Column(
        children: [
          CustomTextfield(
            autoFocus: false,
            keyboardType: TextInputType.text,
            controller: searchController,
            hintText: LocaleKeys.search_hint,
            textAlign: true,
            icon: const Icon(Icons.search),
            onEditingComplete: () {
              searchText = searchController.text;
              setState(() {
                isSearch = true;
              });
            },
          ),

          if (isSearch == false)
            Container(),
          if (isSearch == true)
            Expanded(
              child: search(searchText),
            ),
        ],
      ),
    );
  }
}
