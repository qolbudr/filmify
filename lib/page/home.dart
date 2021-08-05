import 'package:flutter/material.dart';
import 'package:film/page/tab_home.dart';
import 'package:film/page/tab_search.dart';
import 'package:film/page/tab_favorite.dart';


class Home extends StatefulWidget {
	@override
	_HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
	int _currentIndex = 0;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: IndexedStack(
				index: _currentIndex,
				children: [
					TabHome(),
					TabSearch(),
					Favorite(),
				],
			),
			bottomNavigationBar: BottomNavigationBar(
				onTap: (index) {
					setState(() {
						_currentIndex = index;
					});
				},
				currentIndex: _currentIndex,
        elevation: 3,
        items: [
        	BottomNavigationBarItem(
        		icon: Icon(Icons.home_outlined),
        		label: "Home",
        	),
        	BottomNavigationBarItem(
        		icon: Icon(Icons.search_outlined),
        		label: "Search",
        	),
        	BottomNavigationBarItem(
        		icon: Icon(Icons.bookmark_outlined),
        		label: "Favorite",
        	)
       	]
			),
		);
	}
}