import 'package:flutter/material.dart';

class DecoratedContainer extends StatefulWidget {
  const DecoratedContainer({super.key});

  @override
  State<DecoratedContainer> createState() => _DecoratedContainerState();
}

class _DecoratedContainerState extends State<DecoratedContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [ Text("Last Symptoms", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),), Spacer(), Icon(Icons.arrow_forward_ios, size: 15,),],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(children: [Text("Overall Health", style: TextStyle(fontSize: 15,),), Spacer(), Text("Good", style: TextStyle(fontSize: 15,),),],),
            ),
            Padding(
              padding: const EdgeInsets.only( left: 15, right: 15, bottom: 15),
              child: Row(children: [Text("Overall Health", style: TextStyle(fontSize: 15,),), Spacer(), Text("Good", style: TextStyle(fontSize: 15,),),],),
            ),

          ],
        ),
      );
  }
}
