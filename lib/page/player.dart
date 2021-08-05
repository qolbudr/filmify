import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

class Player extends StatefulWidget {
	Player({this.url});
	final String url;

	@override
	_PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
	bool isLoading = true;

	@override
	void initState() {
		super.initState();
	}

	@override
	void dispose() {
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
			  child: Column(
			    children: [
			      RotatedBox(
			      	quarterTurns: 1,
			        child: Container(
			        	height: MediaQuery.of(context).size.width,
			        	width: MediaQuery.of(context).size.height - 28,
			        	child: Stack(
			        		children: [
			        			WebView(
			        				initialUrl: widget.url,
			        				javascriptMode: JavascriptMode.unrestricted,
			        				onPageFinished: (url) {
			        					setState(() {
			        						isLoading = false;
			        					});
			        				},
			        			),
			        			if(isLoading)
			  	    			Container(
			  	    				width: double.infinity,
			  	    				height: double.infinity,
			  	    				color: Theme.of(context).scaffoldBackgroundColor,
			  	    			),
			        			if(isLoading)
			  	    			Center(
			  	    				child: CircularProgressIndicator()
			  	    			)
			        		],
			        	)
			        ),
			      ),
			    ],
			  ),
			)
		);
	}
}
