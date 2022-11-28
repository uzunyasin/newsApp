import 'package:flutter/material.dart';
import 'package:news_app/core/color_extension.dart';
import 'package:news_app/core/context_extension.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/services/app_services.dart';
import 'package:news_app/utils/locale_keys.dart';
import 'package:news_app/widgets/custom_appbar.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';

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
                  Text(widget.articleModel.description.toString(),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w500,
                        color: context.colors.blackColor,
                      )),
                  TextButton(onPressed: (){
                    AppService().openLink(
                        context, widget.articleModel.url.toString());
                  }, child: const Text(LocaleKeys.go_to_source))
                ],
              )),
          // Expanded(
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: context.colors.whiteColor,
          //       borderRadius:
          //       BorderRadius.circular(context.mediumHighValue),
          //     ),
          //     padding: context.paddingMedium,
          //     child: SingleChildScrollView(
          //         physics: const BouncingScrollPhysics(),
          //         child: Html(
          //           style: {
          //             "html": Style(
          //               fontSize: const FontSize(16),
          //               textAlign: TextAlign.justify,
          //             ),
          //             "li": Style(
          //               margin: const EdgeInsets.only(top: 20),
          //             )
          //           },
          //           data: """ ${jobDetail["content"]} """,
          //
          //         )),
          //   ),
          // )
        ],
      ),
    );
  }
}
