import 'package:flutter/material.dart';
import 'package:film/server.dart';
import 'dart:convert';
import 'package:film/page/details.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class Genre extends StatefulWidget {
	Genre({this.genre});
	final String genre;

	@override
	_GenreState createState() => _GenreState();
}

class _GenreState extends State<Genre> {
	List<dynamic> movies;
	bool isLoading = true;
	bool isLoadingNext = false;
	final _scrollController = ScrollController();
	int i = 1;

	@override
	void initState() {
		super.initState();
		fetchSearch();
		_scrollController.addListener(() {
	    if (_scrollController.position.atEdge && isLoadingNext == false) {
	      if (_scrollController.position.pixels != 0) {
	        if(this.mounted) {
	        	setState(() {
	        		i++;
	        		isLoadingNext = true;
	        	});
	        }
	        fetchNext();
	      }
	    }
	  });
	}

	@override
	void dispose() {
		_scrollController.dispose();
		super.dispose();
	}

	void fetchSearch() async {
		final response = await http.get(Uri.parse(server + '/genre.php?genre=' + widget.genre + "&cursor=" + i.toString()));
		List<dynamic> data = jsonDecode(response.body);
		if(this.mounted) {
			setState(() {
				movies = data;
				isLoading = false;
			});
		}
	}

	void fetchNext() async {
		final response = await http.get(Uri.parse(server + '/genre.php?genre=' + widget.genre + "&cursor=" + i.toString()));
		List<dynamic> data = jsonDecode(response.body);
		if(this.mounted) {
			setState(() {
				isLoadingNext = false;
				movies.addAll(List.generate(data.length, (index) => data[index]));
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Theme.of(context).scaffoldBackgroundColor,
				elevation: 0,
				title: Text(widget.genre, style: TextStyle(fontSize:15)),
			),
			body: Column(
				children: [
					if(isLoadingNext)
						LinearProgressIndicator(minHeight: 2),
					Expanded(
						child: isLoading ? ListView.separated(
							separatorBuilder: (context, index) => Divider(),
							padding: EdgeInsets.all(10),
							itemCount: 5,
							itemBuilder: (context, index) {
								return InkWell(
									onTap:  null,
									child: Row(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											ShimmerLoading(width: 120, height: 180, color: Theme.of(context).cardColor),
											SizedBox(width: 10),
											Expanded(
											  child:
											  Column(
											  	crossAxisAlignment: CrossAxisAlignment.start,
											  	mainAxisAlignment: MainAxisAlignment.start,
											  	children: [
											  		ShimmerLoading(width: 150, height: 16, color: Theme.of(context).cardColor),
											  		SizedBox(height: 5),
											  		ShimmerLoading(width: 50, height: 14, color: Theme.of(context).cardColor),
											  		SizedBox(height: 10),
											  		ShimmerLoading(width: 200, height: 14, color: Theme.of(context).cardColor),
											  		SizedBox(height: 5),
											  		ShimmerLoading(width: 200, height: 14, color: Theme.of(context).cardColor),
											  		SizedBox(height: 5),
											  		ShimmerLoading(width: 200, height: 14, color: Theme.of(context).cardColor),
											  		SizedBox(height: 5),
											  		ShimmerLoading(width: 200, height: 14, color: Theme.of(context).cardColor),
											  		SizedBox(height: 5),
											  		ShimmerLoading(width: 200, height: 14, color: Theme.of(context).cardColor),
											  		SizedBox(height: 5),
											  		ShimmerLoading(width: 200, height: 14, color: Theme.of(context).cardColor),
											  		SizedBox(height: 5),
											  		ShimmerLoading(width: 200, height: 14, color: Theme.of(context).cardColor),
											  	],
											  )
											)
										],
									)
								);
							},
						) : 
						(movies.length > 0) ?
						ListView.separated(
							controller: _scrollController,
							separatorBuilder: (context, index) => Divider(),
							padding: EdgeInsets.all(10),
							itemCount: movies.length,
							itemBuilder: (context, index) {
								return InkWell(
									onTap: () => Navigator.push(context, MaterialPageRoute(
										builder: (context) => Details(tmdbId: movies[index]["tmdb_id"].toString(), watchId: movies[index]["watch_id"].toString())
									)),
									child: Row(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											FadeInImage(image: movies[index]['poster'] == null ? AssetImage('assets/images/poster_loading.png') : NetworkImage("https://image.tmdb.org/t/p/w370_and_h556_bestv2" + movies[index]['poster']), placeholder: AssetImage('assets/images/poster_loading.png'), width: 120),
											SizedBox(width: 10),
											Expanded(
											  child: Column(
											  	crossAxisAlignment: CrossAxisAlignment.start,
											  	mainAxisAlignment: MainAxisAlignment.start,
											  	children: [
											  		Text(movies[index]['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1),
											  		SizedBox(height: 5),
											  		Text(movies[index]['release_date'] == "" ? "-" : movies[index]['release_date'].toString().substring(0, 4)),
											  		SizedBox(height: 5),
											  		RatingStar(count: (movies[index]['vote_average'] / 2).toInt()),
											  		SizedBox(height: 20),
											  		Text(movies[index]['overview'], maxLines: 4, style: TextStyle(fontSize: 12)),
											  	],
											  ),
											)
										],
									)
								);
							},
						) :
						Center(
							child: Text("No Items")
						),
					),
				],
			)
		);
	}
}

class RatingStar extends StatelessWidget {
	RatingStar({this.count});
	final int count;

	Widget buildStar(context, index) {
		if(index >= count) {
			return Icon(Icons.star_border, color: Theme.of(context).accentColor, size: 15);
		} else {
			return Icon(Icons.star, color: Theme.of(context).accentColor, size: 15);
		}
	}

	@override 
	Widget build(BuildContext context) {
		return Row(
			mainAxisAlignment: MainAxisAlignment.start,
			children: List.generate(5, (index) => buildStar(context, index)),
		);
	}
}

class ShimmerLoading extends StatelessWidget {
  ShimmerLoading({this.width, this.height, this.color});
  final double width, height;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height, child: Shimmer.fromColors
        (
          baseColor: color,
          highlightColor: Colors.grey.withOpacity(0.2),
          child: Container(width: 100, height: 17, color: color.withOpacity(0.2)
        )
      )
    );
  }
}