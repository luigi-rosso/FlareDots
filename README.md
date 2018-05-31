# Flare Dots

Example use of Flare to clone some interative Google Dots.

## Getting Started

Just insert a Dots widget and pass in the appropriate state.
```
new Dots(state:DotState.Listening)
```

Store the state in a variable and change it to update the active state of the Dots:
```
// In your StatefulWidget's State:
DotState _dotState;

...
// In your build function somewhere :)
new Dots(state:_dotState)
...

// In a button press, for example:
onPressed:() 
{
  setState(() 
  {
    _dotState = DotState.Listening;									  
  });
}
```

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).
