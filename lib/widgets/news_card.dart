import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final Map article;
  final VoidCallback onTap;
  final VoidCallback onBookmark;
  final bool isBookmarked;

  const NewsCard({
    super.key,
    required this.article,
    required this.onTap,
    required this.onBookmark,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = article['urlToImage'];
    final String title = article['title'] ?? "No Title";
    final String description = article['description'] ?? "No Description";
    final String source = article['source']?['name'] ?? "Unknown Source";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Source: $source",
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_add_outlined,
                    ),
                    onPressed: onBookmark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
