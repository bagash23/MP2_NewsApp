import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/model/response.news.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/screen/news_detail.dart';

class NewsHome extends StatefulWidget {
  const NewsHome({super.key});

  @override
  State<NewsHome> createState() => _NewsHomeState();
}

class _NewsHomeState extends State<NewsHome> {
  List<Article> _list = [];
  late ScrollController _scrollController;  
  bool _isLoading = false;
  int _loadedDataCount = 5;

  String? key;
  String? domain;
  String? endpoint;

  getEnv() {
    key = dotenv.env['APP_PUBLIC_KEY'];
    domain = dotenv.env['APP_PUBLIC_API'];
    endpoint = dotenv.env['APP_PUBLIC_TOP'];
  }

  fetchData() async {
    final uri = Uri.parse('$domain$endpoint$key');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonCode = jsonDecode(response.body);
      if (jsonCode['articles'] != null) {
        setState(() {
          _list.clear();
          List<dynamic> articles = jsonCode['articles'];
          articles.forEach((articleJson) {
            _list.add(Article.fromJson(articleJson));
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    getEnv();
    fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isLoading && _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {      
      _loadMoreData();
    }
  }

  void _loadMoreData() async {
    setState(() {
      _isLoading = true;
    });
    
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _loadedDataCount += 5;
      if (_loadedDataCount > _list.length) {
        _loadedDataCount = _list.length;
      }
      _isLoading = false;
    });
  }

Widget _buildNewsList() {
  return ListView.builder(
    controller: _scrollController,
    itemCount: _loadedDataCount + 1,
    itemBuilder: (context, index) {
      if (index == _loadedDataCount) {
        // Widget loading jika sedang memuat data tambahan
        return _isLoading
            ? Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : Container(); // Atau widget lain jika tidak sedang memuat
      } else {
        final article = _list[index];
        return GestureDetector( // Tambahkan GestureDetector untuk menangkap onTap
          onTap: () {
            // Navigasi ke halaman detail dengan artikel yang dipilih
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetail(article: article),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: article.urlToImage != null
                          ? Image.network(
                              article.urlToImage!,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                          : Placeholder(),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          article.title ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          (article.description != null &&
                                  article.description!.length > 100)
                              ? '${article.description!.substring(0, 100)}...'
                              : article.description ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Published At: ${article.publishedAt ?? ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    },
  );
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _list.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _buildNewsList(),
    );
  }
}
