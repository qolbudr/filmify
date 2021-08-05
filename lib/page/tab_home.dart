import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:film/server.dart';
import 'package:film/page/player.dart';
import 'package:film/page/details.dart';
import 'dart:convert';
import 'package:film/page/genre.dart';
import 'package:http/http.dart' as http;

class TabHome extends StatefulWidget {
	@override
	_TabHomeState createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
	bool isLoading = true;
	List<dynamic> movie;
	Map<String, dynamic> firstMovie;

	List<String> genres = [
		"Action",
		"Animation",
		"Biography",
		"Crime",
		"Drama",
		"Fantasy",
		"Horror",
	];

	@override
	void initState() {
		super.initState();
		fetchMovies();
	}

	void fetchMovies() async {
		final result = await http.get(Uri.parse(server + '/get-newest.php'));
		List<dynamic> data = jsonDecode(result.body);
		setState(() {
			movie = data;
		});
		getDetails(movie[0]);
	}

	void getDetails(data) async {
		Map<String, dynamic> movie = data;
		final result = await http.get(Uri.parse(server + '/get-details.php?movie_id=' + movie['tmdb_id'].toString() + '&watch_id=' + movie['watch_id'].toString()));
		Map<String, dynamic> fetchedData = jsonDecode(result.body);
		setState(() {
			firstMovie = fetchedData;
			isLoading = false;
		});
	}

	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				Expanded(
				  child: SingleChildScrollView(
				    child: Column(
				    	crossAxisAlignment: CrossAxisAlignment.start,
				      children: [
				        Container(
				        	width: double.infinity,
				        	height: 330,
				          child: Stack(
				            children: [
				              isLoading ? ShimmerLoading(width: double.infinity, height: 330, color: Theme.of(context).cardColor) :
				             	FadeInImage(image: firstMovie['backdrop_path'] == null ? AssetImage('assets/images/backdrop_loading.png') : NetworkImage("https://image.tmdb.org/t/p/original" + firstMovie['backdrop_path'].toString()), placeholder: AssetImage('assets/images/backdrop_loading.png'), height: 330, width: double.infinity, fit: BoxFit.cover),
				              if(!isLoading)
				              	Positioned(
				              		left: 0,
				              		top: 140,
				              		child: Container(
				              			width: 500,
				              			height: 200,
				              			decoration: BoxDecoration(
				              				gradient: LinearGradient(
				              					begin: Alignment.bottomCenter,
				              					end: Alignment.topCenter,
				              					colors: [
				              						Colors.black,
				              						Colors.black.withOpacity(0)
				              					],
				              					stops: [
				              						0.1,
				              						0.9
				              					],
				              				)
				              			),
				              		)
				              	),
				              if(!isLoading)
				              	Positioned(
				              		left: 0,
				              		top: 220,
				              		child: Padding(
				              		  padding: EdgeInsets.all(10),
				              		  child: Column(
				              		  	crossAxisAlignment: CrossAxisAlignment.start,
				              		  	children: [
				              		  		Text(firstMovie['original_title'], style: TextStyle(fontWeight:FontWeight.bold, fontSize: 23)),
				              		  		Row(
				              		  		  children: [
				              		  		    RatingStar(count: (firstMovie['vote_average'] / 2).toInt()),
				              		  		    SizedBox(width: 10),
				              		  		    Text(firstMovie['vote_count'].toString() + " Reviews", style: TextStyle(fontSize: 13)),
				              		  		  ],
				              		  		),
				              		  		SizedBox(height: 10),
		              		  		    Row(
		              		  		    	children: [
		              		  		    		Text(firstMovie['release_date'].toString().substring(0, 4), style: TextStyle(fontSize: 13)),
		              		  		    		SizedBox(width: 10),
		              		  		    		Text(firstMovie['runtime'].toString() + " Min", style: TextStyle(fontSize: 13)),
		              		  		    		SizedBox(width: 10),
		              		  		    		Text(firstMovie['status'], style: TextStyle(fontSize: 13)),
		              		  		    	],
		              		  		    )
				              		  	]
				              		  ),
				              		)
				              	),
				              if(!isLoading)
				              	if(firstMovie['player'].length > 0)
						              Column(
						                children: [
						                  Expanded(
						                  	child: Center(
						                  	  child: MaterialButton(
						                  	  	color: Theme.of(context).accentColor.withOpacity(0.4),
						                  	  	onPressed: () => Navigator.push(context, MaterialPageRoute(
						                  	  		builder: (context) {
						                  	  			return Player(url: firstMovie['player'][0]);
						                  	  		}
						                  	  	)),
						                  	  	shape: CircleBorder(),
						                  	  	child: Padding(
						                  	  	  padding: EdgeInsets.all(5),
						                  	  	  child: Icon(Icons.play_arrow, size: 40, color: Theme.of(context).accentColor),
						                  	  	)
						                  	  ),
						                  	),
						                  ),
						                ],
						              )
				            ],
				          ),
				        ),
				        SizedBox(height: 10),
				        Padding(
				          padding: EdgeInsets.all(10),
				          child: Column(
				          	crossAxisAlignment: CrossAxisAlignment.start,
				            children: [
				            	Text("Genre"),
		        		    		SizedBox(height: 10),
		        		    		Container(
		        		    			height: 50,
		        		    		  child: ListView.builder(
		        		    		  	itemCount: genres.length,
		        		    		  	scrollDirection: Axis.horizontal,
		        		    		  	shrinkWrap: true,
		        		    		  	itemBuilder: (context, index) => !isLoading ? Card(
	        		    					color: Theme.of(context).accentColor.withOpacity(0.2),
	        		    					child: InkWell(
	        		    						onTap: () => Navigator.push(context, MaterialPageRoute(
	        		    							builder: (context) => Genre(genre: genres[index])
	        		    						)),
	        		    						child: Padding(
	        		    						  padding: const EdgeInsets.all(8.0),
	        		    						  child: Center(
	        		    						  	child: Text(genres[index])
	        		    						  ),
	        		    						)
	        		    					)
	        		    				) : ShimmerLoading(color: Theme.of(context).cardColor, width: 80, height: 30)
	        		    			),
		        		    	),
		        		    	SizedBox(height: 20),
				              Text("Recently Added"),
				              isLoading ? GridView.count(
				              	shrinkWrap: true,
				              	crossAxisCount: 3,
				              	childAspectRatio: 370 / 556,
				              	mainAxisSpacing: 5,
				              	crossAxisSpacing: 5,
				              	physics: NeverScrollableScrollPhysics(),
				              	children: [
				              		ShimmerLoading(width: double.infinity, height: 300, color: Theme.of(context).cardColor),
				              		ShimmerLoading(width: double.infinity, height: 300, color: Theme.of(context).cardColor),
				              		ShimmerLoading(width: double.infinity, height: 300, color: Theme.of(context).cardColor),
				              		ShimmerLoading(width: double.infinity, height: 300, color: Theme.of(context).cardColor),
				              		ShimmerLoading(width: double.infinity, height: 300, color: Theme.of(context).cardColor),
				              		ShimmerLoading(width: double.infinity, height: 300, color: Theme.of(context).cardColor),
				              		ShimmerLoading(width: double.infinity, height: 300, color: Theme.of(context).cardColor),
				              		ShimmerLoading(width: double.infinity, height: 300, color: Theme.of(context).cardColor),
				              		ShimmerLoading(width: double.infinity, height: 300, color: Theme.of(context).cardColor),
				              	],
				              ) : GridView.builder(
				              	gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
					                maxCrossAxisExtent: (MediaQuery.of(context).size.width / 3) - 5,
					                childAspectRatio: 370 / 556,
					                crossAxisSpacing: 5,
					                mainAxisSpacing: 5
					              ),
					              shrinkWrap: true,
					              physics: NeverScrollableScrollPhysics(),
					              itemCount: movie.length - 1,
					              itemBuilder: (context, index) {
					              	return InkWell(
					              		onTap: () => Navigator.push(context, MaterialPageRoute(
					              			builder: (context) {
					              				return Details(tmdbId: movie[index]['tmdb_id'].toString(), watchId: movie[index]['watch_id'].toString());
					              			}
					              		)),
					              		child: 
					              		FadeInImage(image: movie[index]['poster'] == null ? AssetImage('assets/images/poster_loading.png') : NetworkImage("https://image.tmdb.org/t/p/w370_and_h556_bestv2" + movie[index]['poster']), placeholder: AssetImage('assets/images/poster_loading.png')),
					              	);
					              },
				             	)
				            ],
				          ),
				        )
				      ],
				    ),
				  ),
				),
			],
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