import 'package:flutter/material.dart';
import 'package:flare/flare.dart';
import 'flare_actor.dart';

enum DotState
{
	Listening,
	Thinking,
	UserSpeaking,
	Replying
}

class DotsAnimationInstance extends ActorAnimationInstance
{
	double mix = 0.0;
	double mixSpeed = 0.0;

	DotsAnimationInstance(FlutterActor actor, ActorAnimation animation) : super(actor, animation);

	List<AnimationEventArgs> advance(double seconds)
	{
		mix = (mix + mixSpeed * seconds).clamp(0.0, 1.0);

		List<AnimationEventArgs> events = super.advance(seconds);
		if(mix > 0.0)
		{
			apply(mix);
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

		for(DotsAnimationInstance instance in _all)
		{
			if(instance == _thinkingNoSpin)
			{
				continue;
			}
			instance.mixSpeed = -MixSpeed;
		}
		switch(state)
		{
			case DotState.Listening:
				_listening.mixSpeed = MixSpeed;
				_thinkingNoSpin.loop = true;
				_thinkingNoSpin.mixSpeed = -MixSpeed;
				break;
			case DotState.Thinking:
				_spin.mixSpeed = MixSpeed;
				_thinkingNoSpin.mixSpeed = MixSpeed;
				_thinkingNoSpin.loop = true;
				break;
			case DotState.UserSpeaking:
				_listening.mixSpeed = MixSpeed;
				_userSpeaks.mixSpeed = MixSpeed;
				_thinkingNoSpin.loop = true;
				_thinkingNoSpin.mixSpeed = -MixSpeed;
				break;
			case DotState.Replying:
				_spin.mixSpeed = MixSpeed;
				_replyingNoSpin.mixSpeed = MixSpeed;
				_thinkingNoSpin.loop = false;
				break;
		}
		_state = state;
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
		if(_thinkingNoSpin.isOver && _state != DotState.Thinking)
		{
			_thinkingNoSpin.mix = -MixSpeed;
		}
		for(DotsAnimationInstance instance in _all)
		{
			instance.advance(elapsed);
		}
	}
}

class Dots extends StatefulWidget 
{
	Dots({Key key, this.state}) : super(key: key);
	final DotState state;

	@override
	_DotsState createState() => new _DotsState();
}

class _DotsState extends State<Dots>
{
	DotsController _controller = new DotsController();
	@override
	Widget build(BuildContext context) 
	{
		_controller.set(widget.state);
		return FlareActor("assets/Dots", alignment:Alignment.center, fit:BoxFit.contain, controller: _controller);
	}
}