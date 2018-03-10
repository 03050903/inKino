import 'package:flutter/material.dart';
import 'package:inkino/redux/loading_status.dart';
import 'package:meta/meta.dart';

class LoadingView extends StatefulWidget {
  LoadingView({
    @required this.status,
    @required this.loadingContent,
    @required this.errorContent,
    @required this.successContent,
  });

  final LoadingStatus status;
  final Widget loadingContent;
  final Widget errorContent;
  final Widget successContent;

  @override
  _LoadingViewState createState() => new _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with TickerProviderStateMixin {
  AnimationController _loadingController;
  AnimationController _errorController;
  AnimationController _successController;

  Widget firstChild;
  Widget secondChild;

  @override
  void initState() {
    super.initState();
    _loadingController = new AnimationController(
      duration: new Duration(milliseconds: 350),
      vsync: this,
    );

    _errorController = new AnimationController(
      duration: new Duration(milliseconds: 350),
      vsync: this,
    );

    _successController = new AnimationController(
      duration: new Duration(milliseconds: 350),
      vsync: this,
    );

    switch (widget.status) {
      case LoadingStatus.loading:
        _loadingController.value = 1.0;
        break;
      case LoadingStatus.error:
        _errorController.value = 1.0;
        break;
      case LoadingStatus.success:
        _successController.value = 1.0;
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _loadingController.dispose();
    _errorController.dispose();
    _successController.dispose();
  }

  @override
  void didUpdateWidget(LoadingView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.status != widget.status) {
      ValueGetter<TickerFuture> reverseAnimation;

      switch (oldWidget.status) {
        case LoadingStatus.loading:
          reverseAnimation = () => _loadingController.reverse();
          break;
        case LoadingStatus.error:
          reverseAnimation = () => _errorController.reverse();
          break;
        case LoadingStatus.success:
          reverseAnimation = () => _successController.reverse();
          break;
      }

      reverseAnimation().then((_) {
        switch (widget.status) {
          case LoadingStatus.loading:
            _loadingController.forward();
            break;
          case LoadingStatus.error:
            _errorController.forward();
            break;
          case LoadingStatus.success:
            _successController.forward();
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new _TransitionAnimation(
          controller: _loadingController,
          child: widget.loadingContent,
        ),
        new _TransitionAnimation(
          controller: _errorController,
          child: widget.errorContent,
        ),
        new _TransitionAnimation(
          controller: _successController,
          child: widget.successContent,
        ),
      ],
    );
  }
}

class _TransitionAnimation extends StatelessWidget {
  _TransitionAnimation({
    @required this.controller,
    @required this.child,
  })  : _opacity = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.000,
              0.650,
              curve: Curves.ease,
            ),
          ),
        ),
        _yTranslation = new Tween(begin: 250.0, end: 0.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.000,
              0.650,
              curve: Curves.ease,
            ),
          ),
        );

  final AnimationController controller;
  final Widget child;

  final Animation<double> _opacity;
  final Animation<double> _yTranslation;

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, _) {
        return new Transform(
          transform: new Matrix4.translationValues(
            0.0,
            _yTranslation.value,
            0.0,
          ),
          child: new Opacity(
            opacity: _opacity.value,
            child: child,
          ),
        );
      },
    );
  }
}
