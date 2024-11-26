import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/widgets/bookmark.dart';
import 'package:news_app/pages/bookmark_page.dart';
import 'package:news_app/pages/details_page.dart';
import 'package:news_app/widgets/constants/api_key.dart';
import 'package:news_app/widgets/news_card.dart';

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  List articles = [];
  List<Map> bookmarks = [];
  bool isLoading = true;
  String query = "tesla";


  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=$query&from=2024-10-26&sortBy=publishedAt&apiKey=$API_KEY');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          articles = json.decode(response.body)['articles'];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load news");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching news: $e");
    }
  }

  void updateBookmarks() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookmarksPage(bookmarks: bookmarks),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search News",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onSubmitted: (value) {
                setState(() {
                  query = value;
                  isLoading = true;
                });
                fetchNews();
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: fetchNews,
                    child: ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return NewsCard(
                          article: article,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewsDetailPage(article: article),
                              ),
                            );
                          },
                          onBookmark: () {
                            BookmarkManager.toggleBookmark(
                              context: context,
                              article: article,
                              bookmarks: bookmarks,
                              updateBookmarks: updateBookmarks,
                            );
                          },
                          isBookmarked: bookmarks.contains(article),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
