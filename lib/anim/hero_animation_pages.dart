import 'package:flutter/material.dart';

class HeroAnimationPage1 extends StatelessWidget {
  static const persons = [
    Person(name: 'Panneer', age: 30, emoji: '🤷🏽'),
    Person(name: 'Das', age: 13, emoji: '🦹'),
    Person(name: 'Iy', age: 3, emoji: '🧛🏽'),
  ];

  const HeroAnimationPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Person")),
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final person = persons[index];
          return ListTile(
            leading: Hero(
              tag: person.name,
              flightShuttleBuilder: (
                flightContext,
                animation,
                flightDirection,
                fromHeroContext,
                toHeroContext,
              ) {
                switch (flightDirection) {
                  case HeroFlightDirection.push:
                    return Material(
                      type: MaterialType.transparency,
                      child: ScaleTransition(
                        scale: animation.drive(
                          Tween<double>(begin: 10, end: 1).chain(
                            CurveTween(curve: Curves.decelerate),
                          ),
                        ),
                        child: toHeroContext.widget,
                      ),
                    );

                  case HeroFlightDirection.pop:
                    return Material(
                      type: MaterialType.transparency,
                      child: ScaleTransition(
                        scale: animation.drive(
                          Tween<double>(begin: 1, end: 10).chain(
                            CurveTween(curve: Curves.decelerate),
                          ),
                        ),
                        child: fromHeroContext.widget,
                      ),
                    );
                }
              },
              child: Text(
                person.emoji,
                style: TextStyle(fontSize: 40),
              ),
            ),
            title: Text(person.name),
            subtitle: Text('${person.age} years old'),
            trailing: Icon(Icons.arrow_forward_ios_sharp),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HeroAnimationPage2(
                  person: person,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

@immutable
class Person {
  final String name;
  final int age;
  final String emoji;

  const Person({
    required this.name,
    required this.age,
    required this.emoji,
  });
}

class HeroAnimationPage2 extends StatelessWidget {
  final Person person;

  const HeroAnimationPage2({
    super.key,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: person.name,
          child: Text(
            person.emoji,
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              person.name,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              '${person.age} years old',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
