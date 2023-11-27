import 'package:flutter/material.dart';
import 'package:refashion/src/ui/gallery/stats_screen.dart';
import 'package:refashion/src/utils/nav_utils.dart';
import 'package:refashion/src/ui/home_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/warmspace.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Column(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'refashion',
                        style: TextStyle(
                          fontFamily: 'Chopper',
                          fontSize: 55,
                          color: Color.fromARGB(255, 236, 236, 236),
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 2.0,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              /*decoration: BoxDecoration(
                  color:  Theme.of(context).primaryColor,
                  ),*/
              child: CustomPaint(
                painter: ForegroundPainter(),
              ),
            ),
            Container(child: addButton()),
          ],
        ),
      ),
    );
  }

 Widget addButton() {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            FadeTransitionTo(screen: const StatsScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: const BorderSide(
              width: 0.5, color: Color.fromARGB(255, 236, 236, 236)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'continue',
          style: TextStyle(
              fontFamily: 'Ubuntu Mono',
              fontSize: 16,
              color: Color.fromARGB(255, 236, 236, 236)),
        ),
      ),
    ),
  );
}
}

class ForegroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 236, 236, 236)
      ..strokeWidth = 0.9;
    final paintS = Paint()
      ..color = Color.fromARGB(150, 0, 0, 0)
      ..strokeWidth = 4;
    //Points
    const p1 = Offset(20, 40);
    const p2 = Offset(36, 40);
    const p3 = Offset(44, 40);
    const p4 = Offset(120, 40);
    const p5 = Offset(28, 48);
    const p6 = Offset(100, 48);
    const p7 = Offset(20, 56);
    const p8 = Offset(44, 56);
    const p9 = Offset(20, 64);
    const p10 = Offset(36, 64);
    const p11 = Offset(28, 120);
    const p12 = Offset(20, 140);

    const p13 = Offset(370, 765);
    const p14 = Offset(354, 765);
    const p15 = Offset(346, 765);
    const p16 = Offset(270, 765);
    const p17 = Offset(362, 757);
    const p18 = Offset(290, 757);
    const p19 = Offset(370, 749);
    const p20 = Offset(346, 749);
    const p21 = Offset(370, 741);
    const p22 = Offset(354, 741);
    const p23 = Offset(362, 692);
    const p24 = Offset(370, 665);

    //Top left corner
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p3, p4, paint);
    canvas.drawLine(p5, p6, paint);
    canvas.drawLine(p7, p8, paint);
    canvas.drawLine(p9, p10, paint);
    canvas.drawLine(p1, p7, paint);
    canvas.drawLine(p2, p10, paint);
    canvas.drawLine(p3, p8, paint);
    canvas.drawLine(p5, p11, paint);
    canvas.drawLine(p9, p12, paint);

    //Bottom right corner
    canvas.drawLine(p13, p14, paint);
    canvas.drawLine(p15, p16, paint);
    canvas.drawLine(p17, p18, paint);
    canvas.drawLine(p19, p20, paint);
    canvas.drawLine(p21, p22, paint);
    canvas.drawLine(p13, p19, paint);
    canvas.drawLine(p14, p22, paint);
    canvas.drawLine(p15, p20, paint);
    canvas.drawLine(p17, p23, paint);
    canvas.drawLine(p21, p24, paint);

    //Hanger logo
    const h1 = Offset(150, 480); const h2 = Offset(240, 480);
    const h3 = Offset(200, 448); const h4 = Offset(150, 473);
    const h5 = Offset(220, 473); const h6 = Offset(220, 445);
    const h7 = Offset(195, 425); const h8 = Offset(175, 435);
    const h9 = Offset(180, 440);
    canvas.drawLine(h1.translate(2,2), h2.translate(2,2), paintS); canvas.drawLine(h3.translate(2,2), h2.translate(2,2), paintS);
    canvas.drawLine(h4.translate(2,2), h3.translate(2,2), paintS); canvas.drawLine(h4.translate(2,2), h5.translate(2,2), paintS);
    canvas.drawLine(h1.translate(2,2), h6.translate(2,2), paintS); canvas.drawLine(h6.translate(2,2), h7.translate(2,2), paintS);
    canvas.drawLine(h7.translate(2,2), h8.translate(2,2), paintS); canvas.drawLine(h8.translate(2,2), h9.translate(2,2), paintS);
    canvas.drawLine(h9.translate(2,2), h7.translate(2,2), paintS);

    canvas.drawLine(h1, h2, paint); canvas.drawLine(h3, h2, paint);
    canvas.drawLine(h4, h3, paint); canvas.drawLine(h4, h5, paint);
    canvas.drawLine(h1, h6, paint); canvas.drawLine(h6, h7, paint);
    canvas.drawLine(h7, h8, paint); canvas.drawLine(h8, h9, paint);
    canvas.drawLine(h9, h7, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
