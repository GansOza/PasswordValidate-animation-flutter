import 'package:first_app/validatationField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';


void main() {

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: AppBar(
          title: Text('Enter the password'),
        ),
        backgroundColor: Colors.white,
        body: new MyReviewPage(),
      ),
    );
  }
}

class MyReviewPage extends StatefulWidget {
  MyReviewPage({Key key}) : super(key: key);

  @override
  _MyReviewPageState createState() => new _MyReviewPageState();
}



class _MyReviewPageState extends State<MyReviewPage>
    with TickerProviderStateMixin {
  TextEditingController textController = TextEditingController();
  AnimationController _controller;
  Animation<double> _fabScale;

  var eightChar = false,
      oneSpecialChar=false,
      requiredAt=false  ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textController.addListener(() {
      setState(() {
        eightChar = textController.text.length > 8;
        oneSpecialChar=textController.text.isNotEmpty &&
            !textController.text.contains(RegExp(r'^[\w&.-]+$'), 0);
        requiredAt=textController.text.contains(RegExp(r'\d'), 0);
      });
    });

    _controller = new AnimationController(
        vsync: this, duration: const Duration(microseconds: 500));

    _fabScale = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _fabScale.addListener(() {
      setState(() {});
    });
    if (_allValid()) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  bool _allValid() {
    return eightChar;

  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight=MediaQuery.of(context).size.height;
    // TODO: implement build
    return Container(

      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: SingleChildScrollView(
        child:ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: deviceHeight,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 50,
            ),
            Container(
                child: renderValidation()),
            Container(
              height: 50,width: 100,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: textController,
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 1),
                      decoration: InputDecoration(

                          hintText: 'Enter the password',
                          filled: true,
                          border: InputBorder.none,
                          fillColor: Colors.indigoAccent,
                       ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      )
    );
  }

  Widget _renderLine() {
    return Container(
      height: 1,
      decoration: BoxDecoration(color: Colors.grey),
    );
  }

  renderValidation() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
              elevation: 0,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ValidationItem("1 special character", oneSpecialChar),
                      _renderLine(),
                      ValidationItem("1 numeric", requiredAt),
                      _renderLine(),
                      ValidationItem("8 character", eightChar),
                    ],
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
