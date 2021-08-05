import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class BookmarkModel extends ChangeNotifier {
	List<dynamic> _bookMark;
	bool _isBookmarked;

	List<dynamic> get bookMark {
		getBookmark();
		return _bookMark;
	}

	bool get isBookmarked => _isBookmarked;

	BookmarkModel() {
    _bookMark = [];
    _isBookmarked = false;
    getBookmark();
  }

	void getBookmark() async {
		final SharedPreferences prefs = await SharedPreferences.getInstance();
		String bookmark = prefs.getString('bookmark') ?? "[]";
		List<dynamic> bookmarks = jsonDecode(bookmark);
		_bookMark = bookmarks;
		notifyListeners();
	}

	void saveBookmark(movie, watchId) async {
		final SharedPreferences prefs = await SharedPreferences.getInstance();
		String bookmark = prefs.getString('bookmark') ?? "[]";
		List<dynamic> bookmarks = jsonDecode(bookmark);
		movie['watch_id'] = watchId;
		bookmarks.add(movie);
		_bookMark.add(movie);
		prefs.setString('bookmark', jsonEncode(bookmarks));
		_isBookmarked = true;
		notifyListeners();
	}	

	void checkBookmark(tmdbId) async {
		_isBookmarked = false;
		final SharedPreferences prefs = await SharedPreferences.getInstance();
		String bookmark = prefs.getString('bookmark') ?? "[]";
		List<dynamic> bookmarks = jsonDecode(bookmark);
		bookmarks.forEach((movie) {
			if(movie['id'].toString() == tmdbId) {
				_isBookmarked = true;
			}
		});
		notifyListeners();
	}

	void removeBookmark(tmdbId) async {
		final SharedPreferences prefs = await SharedPreferences.getInstance();
		String bookmark = prefs.getString('bookmark') ?? "[]";
		List<dynamic> bookmarks = jsonDecode(bookmark);
		int index;
		int i = 0;
		bookmarks.forEach((movie) {
			if(movie['id'].toString() == tmdbId) {
				index = i;
			}

			i++;
		});

		bookmarks.removeAt(index);
		_bookMark.removeAt(index);

		prefs.setString('bookmark', jsonEncode(bookmarks));
		_isBookmarked = false;
		notifyListeners();
	}
}