import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';

Color customColor1 = const Color(0XFF002038);
Color customColor2 = const Color(0XFF003154);

class Calc1 extends StatefulWidget {
  const Calc1({super.key});

  @override
  State<Calc1> createState() => _Calc1();
}

class _Calc1 extends State<Calc1> {
  String input = '';
  String output = '';
  bool fullView = true;
  bool isRadians = false;

  void fullViewToggle() {
    setState(() {
      fullView = !fullView;
    });
  }

  double degreesToRadians(double degrees) {
  return degrees * (pi / 180);
  }

  double radiansToDegrees(double radians) {
  return radians * (180 / pi);
  }

  void buttonPressed (String btn){
    setState(() {
      if(btn == "deg"){
        isRadians = false;
        return;
      }else if(btn == "rad"){
        isRadians = true;
        return;
      }

      if (
        btn == "+" ||
        btn == "-" ||
        btn == "*" ||
        btn == "/" ||
        btn == "%" ||
        btn == "."){
          if (input.endsWith("+") ||
            input.endsWith("-") ||
            input.endsWith("*") ||
            input.endsWith("/") ||
            input.endsWith("%") ||
            input.endsWith(".")){
            return;
          }else{
            input +=btn;
          }    
      }else if(btn == "="){
        if(input.contains("/0")){
          output = "Cannot divide by 0";
        }else if(input.contains("sin(")){
          final sinBtn = input.replaceAll("sin(", "").replaceAll(")", "");
          if (sinBtn.isNotEmpty){
            double angle = double.parse(sinBtn);
            double angleInRadians = isRadians ? angle : degreesToRadians(angle);
            double sinValue = sin(angleInRadians);
            output = sinValue.toStringAsFixed(5);
          }
        }else if (input.contains("cos(")){
          final cosBtn = input.replaceAll("cos(", "").replaceAll(")", "");
          if (cosBtn.isNotEmpty) {
            double angle = double.parse(cosBtn);
            double angleInRadians = isRadians ? angle : degreesToRadians(angle);
            double cosValue = cos(angleInRadians);
            output = cosValue.toStringAsFixed(5);
          }
        }else if (input.contains("tan(")){
          final tanBtn = input.replaceAll("tan(", "").replaceAll(")", "");
          if (tanBtn.isNotEmpty) {
            double angle = double.parse(tanBtn);
            double angleInRadians = isRadians ? angle : degreesToRadians(angle);
            if ((angle % 180 == 90) || (angle % 180 == 270)) {
              output = "Undefined";
            }else{
              double tanValue = tan(angleInRadians);
              output = tanValue.toStringAsFixed(5);
            }
          }
        }else if (input.contains("log(")){
          final logBtn = input.replaceAll("log(", "").replaceAll(")", "");
          if(logBtn.isNotEmpty){
            double angle = double.parse(logBtn);
            double angleResult = log(angle) / ln10;
            output = angleResult.toString();
          }          
        }else if (input.contains("ln(")){
          final lnBtn = input.replaceAll("ln()", "").replaceAll(")", "");
          if(lnBtn.isNotEmpty){
            double angle = double.parse(lnBtn);
            double angleResult =  log(angle);
            output = angleResult.toString();
          }
        }else if (input.contains("^")){
          List<String> parts = input.split("^");
          double base = double.parse(parts[0]);
          double exponent = double.parse(parts[1]);
          double powerResult = pow(base, exponent).toDouble();
          if (powerResult == powerResult.toInt()){
            output = powerResult.toInt().toString();
          }else{
            output = powerResult.toString();
          }
        }else if (input.contains("√")){
          final rootBtn = input.replaceAll("√","");
          double rootNum = double.parse(rootBtn);
          if(rootBtn.isNotEmpty){
            if(rootNum >=0){
              double rootResult = sqrt(rootNum);
              output = (
                rootResult == rootResult.roundToDouble()) ? 
                rootResult.toStringAsFixed(0) : 
                rootResult.toStringAsFixed(5);
            }else{
              output = "Error";
            }
          }
        }else if (input.contains("π")){
        String expression = input.replaceAll('π', '3.14159');
        try{
         Expression exp = Parser().parse(expression);
         double result = exp.evaluate(EvaluationType.REAL, ContextModel());
         output = (result == result.roundToDouble()) ? result.toStringAsFixed(0) : result.toString();
        }catch (e){
          output = "Error";
        }
      }else if(input.contains("e")){
        String expression = input.replaceAll('e', '2.71828');
        try {
          Expression exp = Parser().parse(expression);
          double result = exp.evaluate(EvaluationType.REAL, ContextModel());
          output = (result == result.roundToDouble()) ? result.toStringAsFixed(0) : result.toString();
        } catch (e) {
          output = "Error";
        }
      }else if (input.contains("%")) {
        output = percentageBt(input);
    }else if (input.contains("!")||input.contains("inv")){
        output = "Error";
      }else {
        try{
          Expression exp = Parser().parse(input);
          double result = exp.evaluate(EvaluationType.REAL, ContextModel());
          output = (result == result.roundToDouble()) ? result.toStringAsFixed(0) : result.toString();
        }catch (e){
          output = "Error";
        }
      }
      }else if (btn == "AC"){
        input = '';
        output = '';
      }else if (btn == "⌫"){
        output = "";
        input = input.substring(0, input.length - 1);
      }else {
        input +=btn;
      }
    });
  }
  //Not Completed
  String percentageBt(String input) {
  final parts = RegExp(r'(\d+(\.\d+)?)%(\d+(\.\d+)?)?');

  input = input.replaceAllMapped(parts, (match) {
    double partOne = double.parse(match.group(1)!);
    String? partTwo = match.group(3); 

    if (partTwo != null) {
      double secondNumber = double.parse(partTwo);
      return ((partOne / 100) * secondNumber).toString();
    } else {
      return (partOne / 100).toString();
    }
  });

  return input;
}
  @override
  
   Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: customColor1,
        actions: [
          IconButton(
            onPressed: fullViewToggle,
            icon: Icon(
              fullView ? Icons.apps_sharp : Icons.calculate_outlined,
              size: 30,
              color: Colors.white,
            )
            )
        ],
      ),
      body: Container(
        color: customColor1,
        padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(input, style: const TextStyle(fontSize: 35, color: Colors.white),),
                    Text(output, style: const TextStyle(fontSize: 35, color: Colors.white),)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (fullView) ...[
                    viewone()
                  ]else ... [
                    viewtwo()
                  ]
                ],
              ), 
            )
          ],
        ),
      ),
    );
   }

   Widget mainButton(String buttontext){
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextButton(
        onPressed: () => buttonPressed(buttontext),
        style: TextButton.styleFrom(
          backgroundColor: customColor2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
        ),
        child: Text(
          buttontext,
          style: const TextStyle(fontSize: 35, color: Colors.white),
        )
        ),
    );
   }

   Widget addedButton(String buttontext){
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextButton(
        onPressed:  () => buttonPressed(buttontext),
        style: TextButton.styleFrom(
          backgroundColor: customColor2,
          shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
        ),
        child: Text(buttontext,style: const TextStyle(fontSize: 25, color: Colors.white),)
      ),
    );
   }

    Widget specialbuttons(String buttontext, bool isActive){
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: TextButton(
          onPressed:() => buttonPressed(buttontext),
          style: TextButton.styleFrom(
            backgroundColor: isActive ? Colors.green : customColor2,
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20))
          ),
          child: Text(buttontext, style: const TextStyle(fontSize: 25, color: Colors.white),)
          ),
      );
    }

    Widget viewone(){
      return Column(
        children: [
          Row(
            mainAxisAlignment:  MainAxisAlignment.spaceAround,
            children: [
              mainButton("AC"),
              mainButton("%"),
              mainButton("⌫"),
              mainButton("/"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               mainButton("7"),
               mainButton("8"),
               mainButton("9"),
               mainButton("*"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              mainButton("4"),
              mainButton("5"),
              mainButton("6"),
              mainButton("-"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               mainButton("1"),
               mainButton("2"),
               mainButton("3"),
               mainButton("+"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              mainButton("00"),
              mainButton("0"),
              mainButton("."),
              mainButton("="),
            ],
          )
        ],
      );
    }

   Widget viewtwo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           addedButton("sin("),
           addedButton("cos("),
           addedButton("tan("),
           specialbuttons("rad", isRadians),
           specialbuttons("deg", !isRadians),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            addedButton("log("),
            addedButton("ln("),
            addedButton("("),
            addedButton(")"),
            addedButton("inv"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            addedButton("!"),
            addedButton("AC"),
            addedButton("%"),
            addedButton("⌫"),
            addedButton("/"),
          ],
        ),
        Row(
          mainAxisAlignment:  MainAxisAlignment.spaceBetween,
          children: [
            addedButton("^"),
            addedButton("7"),
            addedButton("8"),
            addedButton("9"),
            addedButton("*"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            addedButton("√"),
            addedButton("4"),
            addedButton("5"),
            addedButton("6"),
            addedButton("-"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            addedButton("π"),
            addedButton("1"),
            addedButton("2"),
            addedButton("3"),
            addedButton("+"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           addedButton("e"),
           addedButton("00"),
           addedButton("0"),
           addedButton("."),
           addedButton("="),
          ],
        )
      ],
    );
   } 
}