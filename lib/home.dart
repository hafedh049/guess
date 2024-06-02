import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guess/shared.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _guessController = TextEditingController();
  final GlobalKey<State<StatefulWidget>> _guessKey = GlobalKey<State<StatefulWidget>>();

  @override
  void initState() {
    _newGame();
    super.initState();
  }

  void _newGame() {
    attempts.clear();
    hidden = Random().nextInt(101);
  }

  void _guess() {
    if (_guessController.text.isEmpty) {
      showToast(context, "Enter a valid number between 0 and 100", red);
    } else if (int.parse(_guessController.text) < hidden) {
      attempts.add(int.parse(_guessController.text));
      _guessKey.currentState!.setState(() {});
      showToast(context, "Too small", green);
    } else if (int.parse(_guessController.text) > hidden) {
      attempts.add(int.parse(_guessController.text));
      _guessKey.currentState!.setState(() {});
      showToast(context, "Too big", blue);
    } else {
      attempts.add(int.parse(_guessController.text));
      _guessKey.currentState!.setState(() {});
      showModalBottomSheet(
        context: context,
        backgroundColor: white,
        elevation: 8,
        enableDrag: false,
        showDragHandle: true,
        builder: (BuildContext context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Congratulations", style: TextStyle(fontSize: 20, color: dark, fontWeight: FontWeight.w500)),
            Expanded(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) => Card(
                  color: white,
                  elevation: 8,
                  shadowColor: dark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: "${attempts[index]}", style: const TextStyle(fontSize: 16, color: pink, fontWeight: FontWeight.w500)),
                          const TextSpan(text: " is ", style: TextStyle(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                          TextSpan(text: attempts[index] < hidden ? "less than" : "bigger than", style: TextStyle(fontSize: 16, color: attempts[index] < hidden ? red : green, fontWeight: FontWeight.w500)),
                          TextSpan(text: " $hidden", style: const TextStyle(fontSize: 16, color: blue, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                itemCount: attempts.length,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(blue)),
                  onPressed: () {
                    _newGame();
                    _guessKey.currentState!.setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text("New Game", style: TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 8,
        shadowColor: dark,
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15)),
        centerTitle: true,
        title: const Text("Devinette", style: TextStyle(fontSize: 22, color: dark, fontWeight: FontWeight.w500)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Card(
            color: white,
            elevation: 8,
            shadowColor: dark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text("You need to predict the value of an integer from 0 to 100", style: TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
                  if (attempts.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 20),
                    StatefulBuilder(
                      key: _guessKey,
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return Text("You've made ${attempts.length} attempt${attempts.length == 1 ? 's' : ''}", style: const TextStyle(fontSize: 22, color: dark, fontWeight: FontWeight.w500));
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                  Card(
                    color: white,
                    elevation: 8,
                    shadowColor: dark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _guessController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: "Guess",
                          hintText: "Guess",
                          alignLabelWithHint: true,
                        ),
                        onSubmitted: (String value) => _guess,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    hoverColor: transparent,
                    splashColor: transparent,
                    highlightColor: transparent,
                    onTap: _guess,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      alignment: Alignment.center,
                      child: const Text("Make a Guess", style: TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
