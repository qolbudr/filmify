import 'package:flutter/material.dart';
import 'package:film/page/search_result.dart';
import 'package:film/page/genre.dart';

class TabSearch extends StatefulWidget {
	@override
	_TabSearchState createState() => _TabSearchState();
}

class _TabSearchState extends State<TabSearch> {
	List<String> genres = [
		"Action",
		"Animation",
		"Biography",
		"Crime",
		"Drama",
		"Fantasy",
		"Horror",
		"Misteri",
		"Music",
		"Romance",
		"Science Fiction",
		"Thriller",
		"Western",
		"Adventure",
		"Barat",
		"Documentary",
		"Family",
		"History",
		"Mandarin",
		"Movie",
		"Mystery",
		"Sci-Fi",
		"Sports",
		"War"
	];

	final _searchController = TextEditingController();

	@override
	void dispose() {
		_searchController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return SafeArea(
		  child: Scaffold(
		  	body: Column(
		  		children: [
		  			Container(
		  				width: double.infinity,
		  				padding: EdgeInsets.all(10),
		  				child: TextField(
		  					cursorWidth: 1,
		  					cursorColor: Theme.of(context).accentColor,
		  					controller: _searchController,
		  					decoration: InputDecoration(
		  						filled: true,
		  						hintText: "Search Movie...",
		  						prefixIcon: Icon(Icons.search_outlined),
		  						fillColor: Theme.of(context).cardColor,
		  						disabledBorder: UnderlineInputBorder(
					          borderSide: BorderSide(color: Colors.transparent)
					        ),
					        enabledBorder: UnderlineInputBorder(
					          borderSide: BorderSide(color: Colors.transparent)
					        ), 
					        focusedBorder: UnderlineInputBorder(
					          borderSide: BorderSide(color: Colors.transparent)
					        ),
					        errorBorder: UnderlineInputBorder(
					          borderSide: BorderSide(color: Colors.transparent)
					        ),
					        focusedErrorBorder: UnderlineInputBorder(
					          borderSide: BorderSide(color: Colors.transparent)
					        )
		  					),
		  					onSubmitted: (value) {
		  						_searchController.text = "";
			  					Navigator.push(context, MaterialPageRoute(
			  						builder: (context) => SearchResult(query: value)
			  					));
			  				}
		  				),
		  			),
		  			SizedBox(height: 10),
		  			Expanded(
		  			  child: GridView.count(
		  			  	padding: EdgeInsets.all(5),
		  			  	shrinkWrap: true,
		  			  	childAspectRatio: 200 / 100,
		  			  	crossAxisCount: 2,
		  			  	mainAxisSpacing: 5,
		  			  	crossAxisSpacing: 5,
		  			  	children: List.generate(genres.length, (index) =>
		  			  		Card(
		  			  			color: Theme.of(context).accentColor.withOpacity(0.2),
		  			  			child: InkWell(
		  			  				onTap: () => Navigator.push(context, MaterialPageRoute(
		  			  					builder: (context) => Genre(genre: genres[index])
		  			  				)),
		  			  			  child: Center(
		  			  			  	child: Text(genres[index], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
		  			  			  ),
		  			  			)
		  			  		)
		  			  	)
		  			  ),
		  			)
		  		],
		  	)
		  ),
		);
	}
}
