import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:guess/shared.dart';
import 'package:toastification/toastification.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _guessController = TextEditingController();
  final GlobalKey<State<StatefulWidget>> _guessKey = GlobalKey<State<StatefulWidget>>();

  int _hidden = 0;
  final List<int> _attempts = <int>[];

  @override
  void initState() {
    _newGame();
    super.initState();
  }

  void _showToast(String message, Color color) {
    toastification.show(autoCloseDuration: 2.5.seconds, description: Text(message, style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500)));
  }

  void _newGame() {
    _attempts.clear();
    _hidden = Random().nextInt(101);
  }

  void _guess() {
    if (_guessController.text.isEmpty) {
      _showToast("Enter a valid number between 0 and 100", red);
    } else if (int.parse(_guessController.text) < _hidden) {
      _attempts.add(int.parse(_guessController.text));
      _guessKey.currentState!.setState(() {});
      _showToast("Too small", green);
    } else if (int.parse(_guessController.text) > _hidden) {
      _attempts.add(int.parse(_guessController.text));
      _guessKey.currentState!.setState(() {});
      _showToast("Too big", blue);
    } else {
      _attempts.add(int.parse(_guessController.text));
      _guessKey.currentState!.setState(() {});
      showModalBottomSheet(
        context: context,
        backgroundColor: white,
        elevation: 8,
        enableDrag: false,
        showDragHandle: true,
        builder: (BuildContext context) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
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
                            TextSpan(text: "${_attempts[index]}", style: const TextStyle(fontSize: 16, color: pink, fontWeight: FontWeight.w500)),
                            const TextSpan(text: " is ", style: TextStyle(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                            TextSpan(
                                text: _attempts[index] == _hidden
                                    ? "equal to"
                                    : _attempts[index] < _hidden
                                        ? "less than"
                                        : "bigger than",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: _attempts[index] == _hidden
                                        ? gold
                                        : _attempts[index] < _hidden
                                            ? red
                                            : green,
                                    fontWeight: FontWeight.w500)),
                            TextSpan(text: " $_hidden", style: const TextStyle(fontSize: 16, color: blue, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                  itemCount: _attempts.length,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(blue)),
                      onPressed: () {
                        _newGame();
                        _guessKey.currentState!.setState(() {});
                        _guessController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text("New Game", style: TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                  StatefulBuilder(
                    key: _guessKey,
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return _attempts.isEmpty
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const SizedBox(height: 20),
                                Text("You've made ${_attempts.length} attempt${_attempts.length == 1 ? 's' : ''}", style: const TextStyle(fontSize: 22, color: dark, fontWeight: FontWeight.w500)),
                              ],
                            );
                    },
                  ),
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
                        onEditingComplete: _guess,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
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
