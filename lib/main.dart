import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tesla News App',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const NewsHomePage(),
    );
  }
}

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  List articles = [];
  bool isLoading = true;
  String query = "tesla";

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=$query&from=2024-10-26&sortBy=publishedAt&apiKey=09bb17b3ca6f48a8b35268382f9a00ec');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        articles = json.decode(response.body)['articles'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
        centerTitle: true,
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
                : ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal:  18.0 ,vertical: 10),
                        child: ListTile(
                          leading: article['urlToImage'] != null
                              ? Image.network(
                                  article['urlToImage'],
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                )
                              : null,
                          title: Text(
                            article['title'] ?? "No Title",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            article['description'] ?? "No Description",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewsDetailPage(article: article),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final Map article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['title'] ?? "Article"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              article['urlToImage'] != null
                  ? Image.network(article['urlToImage'])
                  : const SizedBox.shrink(),
              const SizedBox(height: 16),
              Text(
                article['title'] ?? "No Title",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                article['content'] ?? "No Content Available",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}