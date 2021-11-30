import 'package:flutter/material.dart';
import 'package:learning/clothes_answer.dart';
import 'clothes_question.dart';

//void main() => runApp(HelloWorld());
void main() {
  runApp(HelloWorld());
}

class HelloWorld extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<HelloWorld> {
  void _iWasTapped() {
    setState(() {
      questionIndex += 1;
    });
  }

  var questions = [
    {
      'question': "What is your favorite kind of shoes?",
      'answer': [
        'Sandals',
        'Heels',
        'Sneakers',
        'Ballerinas',
      ],
    },
    {
      'question':
          "Which pattern or design do you prefer to have in your clothes?",
      'answer': [
        'Large flowers, wide stripes, polka dots.',
        'I like single-colored T-shirts with colorful prints.',
      ],
    },
    {
      'question': "Which of the following describes you the best?",
      'answer': [
        'Creative and unfettered.',
        'Cheerful and athletic.',
        'Dreamy and cute.',
      ],
    },
    {
      'question': "What accessories do you wear with dresses?",
      'answer': [
        'Only clutch.',
        'I do not like dresses',
        'Bracelets and hats.',
        'Necklace and earrings.',
      ],
    },
  ];
  var questionIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Clothes quiz",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Clothes quiz- Dushko Manev 196063"),
        ),
        body: Column(
          children: [
            ClothesQuestion(questions[questionIndex]['question'].toString()),
            ...(questions[questionIndex]['answer'] as List<String>)
                .map((answer) {
              return ClothesAnswer(_iWasTapped, answer);
            }),
          ],
        ),
      ),
    );
  }
}
