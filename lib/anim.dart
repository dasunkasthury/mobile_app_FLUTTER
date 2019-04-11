import 'package:flutter/material.dart';

class DeleteCheck extends StatefulWidget{

  final deviceName;
  final double widthSlide;

  DeleteCheck({
    Key key, 
    this.deviceName, 
    this.widthSlide
  }): super(key: key);

  @override 
  State<StatefulWidget> createState() {
    return new _MyDeleteCheck();
  }
}

class _MyDeleteCheck extends State<DeleteCheck> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat; 

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      animationBehavior: AnimationBehavior.normal
    );

    _offsetFloat = Tween<Offset>(begin: Offset(0,1), end: Offset.zero)
        .animate(_controller);

    _offsetFloat.addListener((){
      setState((){});
    });

    _controller.forward();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height100 = MediaQuery.of(context).size.height;
    double width100 = MediaQuery.of(context).size.width;
    return new SlideTransition(
      position: _offsetFloat,
      child:  AlertDialog(
                      title: Text('No devices found'),
                      content: Text(
                          widget.deviceName +' device Can not be found in this floor !'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
    );
  }
}