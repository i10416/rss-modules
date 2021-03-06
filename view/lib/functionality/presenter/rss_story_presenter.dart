import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RSSStoryPresenter extends StatefulWidget {
  const RSSStoryPresenter(
      {required this.url,
      required this.onLoading,
      this.onNavigateInWebView,
      Key? key})
      : super(key: key);

  final String url;
  final Widget onLoading;
  final void Function(String)? onNavigateInWebView;

  @override
  _RSSStoryPresenterState createState() => _RSSStoryPresenterState();
}

class _RSSStoryPresenterState extends State<RSSStoryPresenter> {
  int progress = 0;
  late Curtain _curtain;
  bool _showCurtain = true;

  @override
  void initState() {
    super.initState();
    _curtain = Curtain(
      child: widget.onLoading,
      builder: (ctx, child, animationController) => Opacity(
          child: child,
          opacity:
              animationController.drive(Tween<double>(begin: 1, end: 0)).value),
      disappearingAnimationDuration: const Duration(milliseconds: 700),
      onAnimationFinished: (_) => removeCurtain(),
    );
  }

  void removeCurtain() {
    setState(() {
      _showCurtain = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          WebView(
            navigationDelegate: (request) async {
              widget.onNavigateInWebView?.call(request.url);
              return NavigationDecision.navigate;
            },
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (_) {
              _curtain.state?.fireAnimation();
            },
          ),
          if (_showCurtain) _curtain
        ],
      );
}

class Curtain extends StatefulWidget {
  Curtain(
      {required this.disappearingAnimationDuration,
      required this.onAnimationFinished,
      required this.builder,
      required this.child,
      Key? key})
      : super(key: key);

  final Duration disappearingAnimationDuration;
  final void Function(AnimationController) onAnimationFinished;
  final Widget Function(BuildContext, Widget?, AnimationController) builder;
  final Widget child;

  late final _CurtainState? state;

  @override
  _CurtainState createState() => _CurtainState();
}

class _CurtainState extends State<Curtain> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    widget.state = this;
    controller = AnimationController(
        duration: widget.disappearingAnimationDuration, vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationFinished(controller);
        }
      });
  }

  void fireAnimation() {
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: controller,
        builder: (ctx, child) => widget.builder(ctx, child, controller),
        child: widget.child,
      );
}
