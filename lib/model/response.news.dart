class ResponseNews {
  String? status;
  int? totalResults;
  List<Article>? articles;

  ResponseNews({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory ResponseNews.fromJson(json) {
    var list = json['articles'] as List;
    List<Article> articlesList = list.map((i) => Article.fromJson(i)).toList();

    return ResponseNews(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: articlesList,
    );
  }
}


class Source {
  String? id;
  String? name;

  Source({this.id, this.name});

  factory Source.fromJson(json) {
    return Source(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Article {
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Article.fromJson(json) {
    return Article(
      source: Source.fromJson(json['source']),
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }
}