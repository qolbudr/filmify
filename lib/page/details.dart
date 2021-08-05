import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:film/page/player.dart';
import 'package:film/server.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:film/model/bookmark.dart';

class Details extends StatefulWidget {
	Details({this.tmdbId, this.watchId});
	final String tmdbId, watchId;

	@override
	_DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> with SingleTickerProviderStateMixin {
	TabController _controller;
	bool isLoading = true;
	bool isBookmarked = false;
	Map<String, dynamic> movie;

	@override
	void initState() {
		super.initState();
		_controller = new TabController(length: 3, vsync: this);
		fetchMovie();
		SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
	}

	void fetchMovie() async {
		final result = await http.get(Uri.parse(server + '/get-details.php?movie_id=' + widget.tmdbId + '&watch_id=' + widget.watchId));
		Map<String, dynamic> fetchedData = jsonDecode(result.body);
		if(this.mounted) {
			setState(() {			
				movie = fetchedData;
				isLoading = false;			
			});
			context.read<BookmarkModel>().checkBookmark(widget.tmdbId);
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: [
						isLoading ? ShimmerLoading(width: 100, height: 14, color: Theme.of(context).cardColor) : Text(movie['original_title'], style: TextStyle(fontSize: 14)),
						if(!isLoading)
							context.watch<BookmarkModel>().isBookmarked == false ? InkWell(
								onTap: isLoading ? null : () {
									context.read<BookmarkModel>().saveBookmark(movie, widget.watchId);
									ScaffoldMessenger.of(context).showSnackBar(SnackBar(
						        content: Text("Successfully added to favorite list"),
						        action: SnackBarAction(
						          label: 'Okay',
						          onPressed: () {
						          },
						        ),
						      ));
								},
								child: Icon(Icons.bookmark_outline, color: Theme.of(context).accentColor),
							) :
							InkWell(
								onTap:  () {
									context.read<BookmarkModel>().removeBookmark(widget.tmdbId);
									ScaffoldMessenger.of(context).showSnackBar(SnackBar(
						        content: Text("Successfully removed from favorite list"),
						        action: SnackBarAction(
						          label: 'Okay',
						          onPressed: () {
						          },
						        ),
						      ));
								},
								child: Icon(Icons.bookmark, color: Theme.of(context).accentColor),
							)
					]
				)
			),
			body: Column(
				children: [
					Expanded(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Container(
				        	width: double.infinity,
				        	height: 330,
				          child: Stack(
				            children: [
				              isLoading ? ShimmerLoading(width: double.infinity, height: 330, color: Theme.of(context).cardColor) :
				             	FadeInImage(image: movie['backdrop_path'] == null ? AssetImage('assets/images/backdrop_loading.png') : NetworkImage("https://image.tmdb.org/t/p/original" + movie['backdrop_path'].toString()), placeholder: AssetImage('assets/images/backdrop_loading.png'), height: 330, width: double.infinity, fit: BoxFit.cover),
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
				              		  		Text(movie['original_title'], style: TextStyle(fontWeight:FontWeight.bold, fontSize: 23)),
				              		  		Row(
				              		  		  children: [
				              		  		    RatingStar(count: (movie['vote_average'] / 2).toInt()),
				              		  		    SizedBox(width: 10),
				              		  		    Text(movie['vote_count'].toString() + " Reviews", style: TextStyle(fontSize: 13)),
				              		  		  ],
				              		  		),
				              		  		SizedBox(height: 10),
		              		  		    Row(
		              		  		    	children: [
		              		  		    		Text(movie['release_date'] == "" ? "-" : movie['release_date'].toString().substring(0, 4), style: TextStyle(fontSize: 13)),
		              		  		    		SizedBox(width: 10),
		              		  		    		Text(movie['runtime'].toString() + " Min", style: TextStyle(fontSize: 13)),
		              		  		    		SizedBox(width: 10),
		              		  		    		Text(movie['status'], style: TextStyle(fontSize: 13)),
		              		  		    	],
		              		  		    )
				              		  	]
				              		  ),
				              		)
				              	),
				              if(!isLoading)
				              	if(movie['player'].length > 0)
						              Column(
						                children: [
						                  Expanded(
						                  	child: Center(
						                  	  child: MaterialButton(
						                  	  	color: Theme.of(context).accentColor.withOpacity(0.4),
						                  	  	onPressed: () => Navigator.push(context, MaterialPageRoute(
						                  	  		builder: (context) {
						                  	  			return Player(url: movie['player'][0]);
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
					        Container(
					          color: Theme.of(context).appBarTheme.backgroundColor,
					          child: TabBar(
					          controller: _controller,
					          tabs: [
					             Tab(child: Text("Overview")),
					             Tab(child: Text("Videos")),
					             Tab(child: Text("Photos")),
					            ],
					          ),
					        ),
					        if(isLoading)
					        	Expanded(
					        	  child: SingleChildScrollView(
					        	    child: Padding(
					        	      padding: const EdgeInsets.all(15),
					        	      child: Column(
					        	      	crossAxisAlignment: CrossAxisAlignment.start,
					        	      	children: [
					        	      		ShimmerLoading(width: 100, height: 16, color:Theme.of(context).cardColor),
					        	      		SizedBox(height: 20),
					        	      		ShimmerLoading(width: double.infinity, height: 14, color:Theme.of(context).cardColor),
					        	      		SizedBox(height: 10),
					        	      		ShimmerLoading(width: double.infinity, height: 14, color:Theme.of(context).cardColor),
					        	      		SizedBox(height: 10),
					        	      		ShimmerLoading(width: double.infinity, height: 14, color:Theme.of(context).cardColor),
					        	      		SizedBox(height: 10),
					        	      		ShimmerLoading(width: double.infinity, height: 14, color:Theme.of(context).cardColor),
					        	      		SizedBox(height: 10),
					        	      		ShimmerLoading(width: double.infinity, height: 14, color:Theme.of(context).cardColor),
					        	      		SizedBox(height: 10),
					        	      		ShimmerLoading(width: double.infinity, height: 14, color:Theme.of(context).cardColor),
					        	      		SizedBox(height: 10),
					        	      		ShimmerLoading(width: double.infinity, height: 14, color:Theme.of(context).cardColor),
					        	      		SizedBox(height: 10),
					        	      		ShimmerLoading(width: double.infinity, height: 14, color:Theme.of(context).cardColor),
					        	      		SizedBox(height: 10),
					        	      	],
					        	      ),
					        	    ),
					        	  ),
					        	),
					        if(!isLoading)
							      Expanded(
							        child: TabBarView(
							        	controller: _controller,
							        	children: [
							        		SingleChildScrollView(
							        		  child: Padding(
							        		    padding: EdgeInsets.all(15),
							        		    child: Column(
							        		    	crossAxisAlignment: CrossAxisAlignment.start,
							        		    	children: [
							        		    		Text("Stream", style: TextStyle(fontSize: 16)),
							        		    		SizedBox(height: 10),
							        		    		Container(
							        		    			height: 50,
							        		    		  child: ListView.builder(
							        		    		  	itemCount: movie["player"].length,
							        		    		  	scrollDirection: Axis.horizontal,
							        		    		  	shrinkWrap: true,
							        		    		  	itemBuilder: (context, index) => Card(
						        		    					color: Theme.of(context).accentColor.withOpacity(0.2),
						        		    					child: InkWell(
						        		    						onTap: () => Navigator.push(context, MaterialPageRoute(
						        		    							builder: (context) => Player(url: movie['player'][index])
						        		    						)),
						        		    						child: Padding(
						        		    						  padding: const EdgeInsets.all(8.0),
						        		    						  child: Center(
						        		    						  	child: Text("Server ${index+1}")
						        		    						  ),
						        		    						)
						        		    					)
						        		    				)
						        		    			),
							        		    		),
							        		    		SizedBox(height: 10),
							        		    		Text("Storyline", style: TextStyle(fontSize: 16)),
							        		    		SizedBox(height: 10),
							        		    		Text(movie['overview'] == null ? "-" : movie['overview'], style: TextStyle(fontSize: 14), textAlign: TextAlign.justify),
							        		    		SizedBox(height: 20),
							        		    		Table(
							        		    			columnWidths: {
							        		    				0: FlexColumnWidth(0.4),
							        		    				2: FlexColumnWidth(0.4),
							        		    			},
							        		    			children: [
							        		    				TableRow(
							        		    					children: [
							        		    						TableCell(
							        		    							child: Text("Released")
							        		    						),
							        		    						TableCell(
							        		    							child: Text(movie['release_date'])
							        		    						),
							        		    					]
							        		    				),
							        		    				TableRow(
							        		    					children: [
							        		    						TableCell(
							        		    							child: Text("Runtime")
							        		    						),
							        		    						TableCell(
							        		    							child: Text(movie['runtime'].toString() + " Min")
							        		    						),
							        		    					]
							        		    				),
							        		    				TableRow(
							        		    					children: [
							        		    						TableCell(
							        		    							child: Text("Genre")
							        		    						),
							        		    						TableCell(
							        		    							child: (movie['genres'].length != 0) ? RichText(
							        		    								text: TextSpan(
							        		    									text: "",
							        		    									children: List.generate(movie['genres'].length, (index) => 
							        		    								  TextSpan(
							        		    								    text: movie['genres'][index]['name'].toString(),
							        		    								    style: TextStyle(fontSize: 15, color: Theme.of(context).accentColor),
							        		    								  	children: [
							        		    								  		if(index != movie['genres'].length - 1)
							        		    								  			TextSpan(text: ", ", style: TextStyle(fontSize: 15, color: Colors.white))
							        		    								  	]
							        		    								  ),
							        		    								)
						          		  								)
						          		  							) : Text("-")),
							        		    					]
							        		    				),
							        		    				TableRow(
							        		    					children: [
							        		    						TableCell(
							        		    							child: Text("Status")
							        		    						),
							        		    						TableCell(
							        		    							child: Text(movie['status'])
							        		    						),
							        		    					]
							        		    				),
							        		    				TableRow(
							        		    					children: [
							        		    						TableCell(
							        		    							child: Text("Languages")
							        		    						),
							        		    						TableCell(
							        		    							child: (movie['spoken_languages'].length != 0) ? RichText(
							        		    								text: TextSpan(
								          		  								text: "",
								          		  								children: List.generate(movie['spoken_languages'].length, (index) => TextSpan(
								          		  									text: movie['spoken_languages'][index]['english_name'].toString(),
								          		  									style: TextStyle(fontSize: 15),
								          		  									children: [
								          		  										if(index != movie['spoken_languages'].length - 1)
									          		  										TextSpan(
									          		  											text: ", "
									          		  										)
								          		  									]
								          		  								))
								          		  							)
							        		    							) : Text("-")
							        		    						),
							        		    					]
							        		    				),
							        		    				TableRow(
							        		    					children: [
							        		    						TableCell(
							        		    							child: Text("Productions")
							        		    						),
							        		    						TableCell(
							        		    							child: (movie['production_companies'].length != 0) ? RichText(
							        		    								text: TextSpan(
								          		  								text: "",
								          		  								children: List.generate(movie['production_companies'].length, (index) => TextSpan(
								          		  									text: movie['production_companies'][index]['name'].toString(),
								          		  									style: TextStyle(fontSize: 15),
								          		  									children: [
								          		  										if(index != movie['production_companies'].length - 1)
									          		  										TextSpan(
									          		  											text: ", "
									          		  										)
								          		  									]
								          		  								))
								          		  							)
							        		    							) : Text("-")
							        		    						),
							        		    					]
							        		    				),
							        		    			],
							        		    		),
																	SizedBox(height: 20),
																	if(movie['credits']['cast'].length != 0)
																		Text("Cast", style: TextStyle(fontSize: 16)),
																	if(movie['credits']['cast'].length != 0)
							        		    			SizedBox(height: 10),
							        		    		if(movie['credits']['cast'].length != 0)
																		Container(
																			width: double.infinity,
																			height: 200,
																		  child: ListView.separated(
																		  	separatorBuilder: (context, index) => SizedBox(width: 10),
																		  	shrinkWrap: true,
																		  	itemCount: movie['credits']['cast'].length,
																		  	scrollDirection: Axis.horizontal,
																		  	itemBuilder: (context, index) {
																		  		return Container(
																		  			width: 100,
																		  		  child: Column(
																		  		  	crossAxisAlignment: CrossAxisAlignment.start,
																		  		  	children: [
																		  		  		FadeInImage(image: movie['credits']['cast'][index]['profile_path'] == null ? AssetImage('assets/images/poster_loading.png') : NetworkImage("https://image.tmdb.org/t/p/w370_and_h556_bestv2" + movie['credits']['cast'][index]['profile_path'].toString()), placeholder: AssetImage('assets/images/poster_loading.png'), height: 150),
																		  		  		SizedBox(height: 10),
																		  		  		Text(movie['credits']['cast'][index]['name'], maxLines: 1, style: TextStyle(fontSize: 14)),
																		  		  		Text(movie['credits']['cast'][index]['character'], maxLines: 1, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5)))
																		  		  	],
																		  		  ),
																		  		);
																		  	}
																		  ),
																		)
							        		    	],
							        		    ),
							        		  ),
							        		),
							        		SingleChildScrollView(
							        			child: Padding(
							        			  padding: EdgeInsets.all(15),
							        			  child: (movie['videos']['results'].length != 0) ? Column(
							        			  	children: List.generate(movie['videos']['results'].length, (index) => 
							        			  		Column(
							        			  			crossAxisAlignment: CrossAxisAlignment.start,
							        			  		  children: [
							        			  		    Stack(
							        			  		      children: [
							        			  		        FadeInImage(image: movie['videos']['results'][index]['key'] == null ? AssetImage('assets/images/backdrop_loading.png') : NetworkImage('https://img.youtube.com/vi/' +  movie['videos']['results'][index]['key'].toString() + '/mqdefault.jpg'), placeholder: AssetImage('assets/images/backdrop_loading.png'), width: double.infinity, fit: BoxFit.cover),
							        			  		        Positioned(
							        			  		        	top: 70,
							        			  		        	left: 120,
							        			  		          child: MaterialButton(
											                  	  	color: Theme.of(context).accentColor.withOpacity(0.4),
											                  	  	onPressed: () {},
											                  	  	shape: CircleBorder(),
											                  	  	child: Padding(
											                  	  	  padding: EdgeInsets.all(5),
											                  	  	  child: Icon(Icons.play_arrow, size: 40, color: Theme.of(context).accentColor),
											                  	  	)
											                  	  ),
							        			  		        )
							        			  		      ],
							        			  		    ),
							        			  		    SizedBox(height: 10),
							        			  		    Text(movie['videos']['results'][index]['name']),
							        			  		    Text(movie['videos']['results'][index]['type'], style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5))),
							        			  		    SizedBox(height: 20),
							        			  		  ],
							        			  		),
							        			  	),
							        			  ) : Center(
							        			  	child: Text("No Videos")
							        			 	),
							        			)
							        		),
							        		SingleChildScrollView(
							        			child: Padding(
							        			  padding: EdgeInsets.all(15),
							        			  child: Column(
							        			  	crossAxisAlignment: CrossAxisAlignment.start,
							        			  	children: [
							        			  		if(movie['images']['backdrops'].length != 0)
								        			  		Column(
								        			  			crossAxisAlignment: CrossAxisAlignment.start,
								        			  			children: [
								        			  				Text("Backdrops"),
								        			  				SizedBox(height: 10),
								        			  				GridView.count(
								        			  					shrinkWrap: true,
								        			  					physics: NeverScrollableScrollPhysics(),
								        			  					crossAxisCount: 2,
								        			  					childAspectRatio: 533 / 300,
								        			  					mainAxisSpacing: 5,
								        			  					crossAxisSpacing: 5,
								        			  					children: List.generate(movie['images']['backdrops'].length, (index) => 
								        			  						FadeInImage(image: movie['images']['backdrops'][index]['file_path'] == null ? AssetImage('assets/images/backdrop_loading.png') : NetworkImage('https://image.tmdb.org/t/p/w533_and_h300_bestv2' +  movie['images']['backdrops'][index]['file_path'].toString()), placeholder: AssetImage('assets/images/backdrop_loading.png'), width: double.infinity, fit: BoxFit.cover),
								        			  					),
								        			  				)
								        			  			],
								        			  		),
								        			  	if(movie['images']['backdrops'].length != 0)
							        			  			SizedBox(height: 20),
							        			  		if(movie['images']['posters'].length != 0)
								        			  		Column(
								        			  			crossAxisAlignment: CrossAxisAlignment.start,
								        			  			children: [
								        			  				Text("Posters"),
								        			  				SizedBox(height: 10),
								        			  				GridView.count(
								        			  					shrinkWrap: true,
								        			  					physics: NeverScrollableScrollPhysics(),
								        			  					crossAxisCount: 3,
								        			  					childAspectRatio: 370 / 556,
								        			  					mainAxisSpacing: 5,
								        			  					crossAxisSpacing: 5,
								        			  					children: List.generate(movie['images']['posters'].length, (index) => 
								        			  						FadeInImage(image: movie['images']['posters'][index]['file_path'] == null ? AssetImage('assets/images/poster_loading.png') : NetworkImage('https://image.tmdb.org/t/p/w370_and_h556_bestv2' +  movie['images']['posters'][index]['file_path'].toString()), placeholder: AssetImage('assets/images/poster_loading.png'), width: double.infinity, fit: BoxFit.cover),
								        			  					),
								        			  				)
								        			  			],
								        			  		),
								        			  	if(movie['images']['backdrops'].length == 0 && movie['images']['posters'].length == 0)
								        			  		Center(
								        			  			child: Text("No Images")
								        			  		)
							        			  	],
							        			  ),
							        			)
							        		),
							        	],
							        ),
							      ),
							],
						),
					)
				],
			)
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