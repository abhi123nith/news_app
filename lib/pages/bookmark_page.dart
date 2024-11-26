import 'package:flutter/material.dart';
import 'package:news_app/widgets/bookmark.dart';
import 'package:news_app/pages/details_page.dart';
import 'package:news_app/widgets/news_card.dart';

class BookmarksPage extends StatelessWidget {
  final List<Map> bookmarks;

  const BookmarksPage({super.key, required this.bookmarks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
      ),
      body: bookmarks.isEmpty
          ? const Center(
              child: Text("No bookmarks yet",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            )
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final article = bookmarks[index];
                return NewsCard(
                  article: article,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailPage(article: article),
                      ),
                    );
                  },
                  onBookmark: () {
                    BookmarkManager.toggleBookmark(
                      context: context,
                      article: article,
                      bookmarks: bookmarks,
                      updateBookmarks: () {},
                    );
                  },
                  isBookmarked: true,
                );
              },
            ),
    );
  }
}
