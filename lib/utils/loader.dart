import 'package:flutter/material.dart';

class TripleDotLoader extends StatefulWidget {
  const TripleDotLoader({super.key});

  @override
  _TripleDotLoaderState createState() => _TripleDotLoaderState();
}

class _TripleDotLoaderState extends State<TripleDotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      reverseDuration: const Duration(milliseconds: 1500),
      animationBehavior: AnimationBehavior.normal,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "Generating image",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 4),
                ...List.generate(4, (index) {
                  return Transform.translate(
                    offset: Offset(
                        0,
                        -15 *
                            (1 -
                                (_animationController.value - index / 3)
                                    .abs()
                                    .clamp(0.0, 0.5))),
                    //   offset: Offset(0, -10 * (1 - (CurvedAnimation(
                    //   parent: _animationController,
                    //   curve: Interval(index * 0.2, 1.0, curve: Curves.easeInOut),
                    // ).value)).abs()),
                    child: const Dot(),
                  );
                }),
              ]);
        },
      ),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.0,
      height: 5.0,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 200, 8, 149),
        shape: BoxShape.circle,
      ),
    );
  }
}
