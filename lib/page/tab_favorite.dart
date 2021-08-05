import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film/model/bookmark.dart';
import 'package:film/page/details.dart';
import 'package:shimmer/shimmer.dart';

class Favorite extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				elevation: 0,
				title: Text("Favorite", style: TextStyle(fontSize:15)),
			),
			body: Column(
				children: [
					Expanded(
						child: Consumer<BookmarkModel>(
							builder: (context, bookmark, _) {
								List<dynamic> movies = bookmark.bookMark;
								return (movies.length > 0) ?
									ListView.separated(
										separatorBuilder: (context, index) => Divider(),
										padding: EdgeInsets.all(10),
										itemCount: movies.length,
										itemBuilder: (context, index) {
											return InkWell(
												onTap: () => Navigator.push(context, MaterialPageRoute(
													builder: (context) => Details(tmdbId: movies[index]["id"].toString(), watchId: movies[index]["watch_id"].toString())
												)),
												child: Row(
													crossAxisAlignment: CrossAxisAlignment.start,
													children: [
														FadeInImage(image: movies[index]['poster_path'] == null ? AssetImage('assets/images/poster_loading.png') : NetworkImage("https://image.tmdb.org/t/p/w370_and_h556_bestv2" + movies[index]['poster_path']), placeholder: AssetImage('assets/images/poster_loading.png'), width: 120),
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
									);
							}
						)
					)
				]
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