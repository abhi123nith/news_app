import 'package:flutter/material.dart';

class BookmarkManager {
  // Static method to add or remove an article from bookmarks
  static void toggleBookmark(
      {required BuildContext context,
      required Map article,
      required List<Map> bookmarks,
      required Function updateBookmarks}) {
    if (!bookmarks.contains(article)) {
      // Add article to bookmarks
      bookmarks.add(article);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article bookmarked!'), backgroundColor: Colors.green),
      );
    } else {
      // Remove article from bookmarks
      bookmarks.remove(article);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article removed from bookmarks!'), backgroundColor: Colors.red),
      );
    }
    // Update the bookmark list after adding/removing
    updateBookmarks();
  }
}
