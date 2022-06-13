import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:q4me/utils/flavor_config.dart';
import 'package:q4me/widgets/circle_paint.dart';
import 'package:q4me/widgets/curve_wave.dart';

class RipplesAnimation extends StatefulWidget {
  const RipplesAnimation({
    Key key,
    this.imageName,
    this.size = 70.0,
    this.color = Colors.white12,
    this.onPressed,
    this.status = false,
    @required this.child,
  }) : super(key: key);
  final double size;
  final Color color;
  final Widget child;
  final String imageName;
  final bool status;
  final VoidCallback onPressed;
  @override
  _RipplesAnimationState createState() => _RipplesAnimationState();
}

class _RipplesAnimationState extends State<RipplesAnimation>
    with TickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: widget.status
            ? DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: <Color>[
                      Colors.grey.shade100.withOpacity(0.5),
                      Color.lerp(Colors.white12,
                          Colors.grey.shade100.withOpacity(0.3), .01)
                    ],
                  ),
                ),
                child: ScaleTransition(
                  scale: Tween(begin: 1.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: CurveWave(),
                    ),
                  ),
                  child: Container(
                    height: 155,
                    width: 155,
                    child: Center(
                      child: CachedNetworkImage(
                        height: 110,
                        width: 110,
                        fit: BoxFit.contain,
                        imageUrl: Config.baseUrl + widget.imageName,
                        errorWidget: (context, url, error) => Image(
                          image: AssetImage("assets/images/logo.png"),
                        ),
                      ),
                    ),
                    color: Colors.white,
                  ),
                ))
            : DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: <Color>[
                      Colors.grey.shade100.withOpacity(0.5),
                      Color.lerp(Colors.white12,
                          Colors.grey.shade100.withOpacity(0.3), .01)
                    ],
                  ),
                ),
                child: Container(
                  height: 155,
                  width: 155,
                  child: Center(
                    child: CachedNetworkImage(
                      height: 110,
                      width: 110,
                      fit: BoxFit.contain,
                      imageUrl: Config.baseUrl + widget.imageName,
                      errorWidget: (context, url, error) => Image(
                        image: AssetImage("assets/images/logo.png"),
                      ),
                    ),
                  ),
                  color: Colors.white,
                )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter:
          CirclePainter(_controller, color: Colors.white12.withOpacity(0.1)),
      child: SizedBox(
        width: widget.size * 3.5,
        height: widget.size * 3.5,
        child: _button(),
      ),
    );
  }
}
