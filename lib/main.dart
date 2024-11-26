import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
    final String? imageUrl = article['urlToImage'];
    final String title = article['title'] ?? "No Title";
    final String content = article['content'] ?? "No Content Available";
    final String description = article['description'] ?? "No Description";
    final String? publishedAt = article['publishedAt'];

    final bool isTruncated = content.contains('… [+') && content.contains('chars]');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details Page"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image (if available)
              if (imageUrl != null)
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              const SizedBox(height: 16),

              //  title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              //description
              Text(
                description,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),

              //content
              Text(
                isTruncated
                    ? "$content\n\nRead the full article below:"
                    : content,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              if (isTruncated && article['url'] != null)
                TextButton(
                  onPressed: () {
                    final String url = article['url']!;
                    launchUrl(Uri.parse(url));
                  },
                  child: const Text(
                    "Read Full Article",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

              // Display the published date if available
              if (publishedAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Published on: ${DateTime.parse(publishedAt).toLocal()}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
      ),
      body: bookmarks.isEmpty
          ? const Center(
              child: Text("No bookmarks yet"),
            )
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final article = bookmarks[index];
                return ListTile(
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
                        builder: (context) => NewsDetailPage(article: article),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
