import 'package:flutter/material.dart';
import 'package:flare/flare.dart';
import 'flare_actor.dart';

void main() => runApp(new MyApp());

enum DotState
{
	Listening,
	Thinking,
	UserSpeaking,
	Replying
}

class DotsAnimationInstance extends ActorAnimationInstance
{
	double _mix = 0.0;
	double mixSpeed = 0.0;

	DotsAnimationInstance(FlutterActor actor, ActorAnimation animation) : super(actor, animation);

	List<AnimationEventArgs> advance(double seconds)
	{
		_mix = (_mix + mixSpeed * seconds).clamp(0.0, 1.0);

		List<AnimationEventArgs> events = super.advance(seconds);
		if(_mix > 0.0)
		{
			apply(_mix);
		}
		else
		{
			time = 0.0;
		}
		return events;
	}
}

class DotsController implements FlareController
{
	DotState _state;

	DotsAnimationInstance _listening;
	DotsAnimationInstance _userSpeaks;
	DotsAnimationInstance _spin;
	DotsAnimationInstance _replyingNoSpin;
	DotsAnimationInstance _thinkingNoSpin;
	List<DotsAnimationInstance> _all = new List<DotsAnimationInstance>();

	static const double MixSpeed = 3.0;

	set(DotState state)
	{
		if(state == _state)
		{
			return;
		}
		_state = state;

		for(DotsAnimationInstance instance in _all)
		{
			instance.mixSpeed = -MixSpeed;
		}
		switch(_state)
		{
			case DotState.Listening:
				_listening.mixSpeed = MixSpeed;
				break;
			case DotState.Thinking:
				_spin.mixSpeed = MixSpeed;
				_thinkingNoSpin.mixSpeed = MixSpeed;
				break;
			case DotState.UserSpeaking:
				_listening.mixSpeed = MixSpeed;
				_userSpeaks.mixSpeed = MixSpeed;
				break;
			case DotState.Replying:
				_spin.mixSpeed = MixSpeed;
				_replyingNoSpin.mixSpeed = MixSpeed;
				break;
		}
	}

	DotsAnimationInstance instanceAnimation(FlutterActor actor, String name)
	{
		ActorAnimation animation = actor.getAnimation(name);
		if(animation == null)
		{
			return null;
		}
		DotsAnimationInstance inst = new DotsAnimationInstance(actor, animation); 
		_all.add(inst);
		return inst;
	}
	void initialize(FlutterActor actor)
	{
		_listening = instanceAnimation(actor, "Listening");
		_userSpeaks = instanceAnimation(actor, "User Speaks");
		_spin = instanceAnimation(actor, "Spin");
		_replyingNoSpin = instanceAnimation(actor, "Replying No Spin");
		_thinkingNoSpin = instanceAnimation(actor, "Thinking No Spin");
		set(DotState.Listening);
	}

	void advance(FlutterActor actor, double elapsed)
	{
		for(DotsAnimationInstance instance in _all)
		{
			instance.advance(elapsed);
		}
	}
}

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
	DotsController _controller = new DotsController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
		backgroundColor: Colors.white,
		appBar: new AppBar(
			title: new Text(widget.title)
		),
		body: new Stack(
			children: <Widget>[
			  	new Positioned.fill(
					child: FlareActor("assets/Dots", alignment:Alignment.center, fit:BoxFit.contain, controller: _controller)
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
										_controller.set(DotState.Listening);
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
										_controller.set(DotState.UserSpeaking);
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
										_controller.set(DotState.Thinking);
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
										_controller.set(DotState.Replying);
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