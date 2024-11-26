import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final sourceName = article['source']?['name'] ?? "Unknown Source";

    final bool isTruncated =
        content.contains('… [+') && content.contains('chars]');

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
              if (imageUrl != null)
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
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
              Text(
                "Source: $sourceName",
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
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
