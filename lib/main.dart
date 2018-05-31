import 'package:flutter/material.dart';
import 'dots.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue
      ),
      home: new MyHomePage(title: 'Flutter + Flare'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	DotState _dotState;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
		backgroundColor: Colors.grey,
		appBar: new AppBar(
			title: new Text(widget.title)
		),
		body: new Stack(
			children: <Widget>[
			  	new Positioned.fill(
					child: new Dots(state:_dotState),
				),
				new Positioned.fill(
					bottom: 50.0,
					child: new Wrap(
						runAlignment: WrapAlignment.end,
						crossAxisAlignment: WrapCrossAlignment.center,
						alignment: WrapAlignment.center,
						//crossAxisAlignment: CrossAxisAlignment.end,
						//mainAxisAlignment: MainAxisAlignment.center,
						children: <Widget>[
							new Container(
								margin: const EdgeInsets.all(5.0), 
								child: new FlatButton(
									child: new Text("Listen"), 
									textColor: Colors.white, 
									color: Colors.blue, 
									onPressed:() 
									{
										setState(() 
										{
											_dotState = DotState.Listening;									  
										});
									}
								)
							),
						  new Container(
								margin: const EdgeInsets.all(5.0), 
								child: new FlatButton(
									child: new Text("Speak"), 
									textColor: Colors.white, 
									color: Colors.blue, 
									onPressed:() 
									{
										setState(() 
										{
											_dotState = DotState.UserSpeaking;									  
										});
									}
								)
							),
							new Container(
								margin: const EdgeInsets.all(5.0), 
								child: new FlatButton(
									child: new Text("Thinking"), 
									textColor: Colors.white, 
									color: Colors.blue, 
									onPressed:() 
									{
										setState(() 
										{
											_dotState = DotState.Thinking;									  
										});
									}
								)
							),
							new Container(
								margin: const EdgeInsets.all(5.0), 
								child: new FlatButton(
									child: new Text("Replying"), 
									textColor: Colors.white, 
									color: Colors.blue, 
									onPressed:() 
									{
										setState(() 
										{
											_dotState = DotState.Replying;									  
										});
									}
								)
							),
				  		],
					)
				)
		  ]
      )
    );
  }
}