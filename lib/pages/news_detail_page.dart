import 'dart:io';

import 'package:flutter/material.dart';
import 'package:news_app/core/color_extension.dart';
import 'package:news_app/core/context_extension.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/pages/news_source.dart';
import 'package:news_app/utils/locale_keys.dart';
import 'package:news_app/utils/navigate.dart';
import 'package:news_app/widgets/custom_appbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailPage extends StatefulWidget {
  NewsDetailPage({
    Key? key,
    required this.articleModel,
    this.isSearch = true,
  }) : super(key: key);

  final ArticleModelArticles articleModel;
  bool isSearch;

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  Future<void> _onShare(BuildContext context, String url) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(url,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.whiteColor,
      appBar: CustomAppbar(
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.transparent
            : context.colors.blueColor,
        color: context.colors.textTitleWhite,
        actions: [
          IconButton(
              onPressed: () {
                _onShare(context, widget.articleModel.url.toString());
              },
              icon: const Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.emptyLowMediumWidget,
          Padding(
              padding: context.paddingMedium.copyWith(top: context.lowValue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(widget.articleModel.urlToImage.toString()),
                  context.emptyMediumWidget,
                  Text(
                    widget.articleModel.title.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w500,
                      color: context.colors.blackColor,
                    ),
                  ),
                  context.emptyMediumHighWidget,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.source),
                              Text(widget.articleModel.source!.name.toString()),
                            ],
                          )
                        ],
                      ),
                      context.emptyHighWidgetW,
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_month),
                              Text(widget.articleModel.publishedAt.toString()),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  context.emptyMediumWidget,
                  Text(widget.articleModel.description.toString(),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w500,
                        color: context.colors.blackColor,
                      )),
                  TextButton(
                      onPressed: () {
                        nextScreen(
                            context,
                            NewsSource(
                                url: widget.articleModel.url.toString()));
                      },
                      child: const Text(LocaleKeys.go_to_source))
                ],
              )),
        ],
      ),
    );
  }
}
