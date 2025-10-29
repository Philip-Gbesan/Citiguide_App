import 'package:citiguide_app/overview/components/reusable_card.dart';
import 'package:flutter/material.dart';

class CityOverview extends StatelessWidget {
  const CityOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(
          Icons.arrow_back,
          size: 20,
          weight: 13,
          color: Colors.white,
        ),
        title: Text(
          "Tokyo,Japan",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableCard(
                    width: 500,
                    height: 200,
                    padding: const EdgeInsets.fromLTRB(10, 170, 90, 15),
                    imageUrl: "images/hermes.jpeg",
                    cardText: "View Mount Fuji on a clear day"),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Tokyo is a beautiful and vibrant city",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Attractions",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 15,
                            color: Colors.blue,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableCard(
                              width: 100,
                              height: 100,
                              padding: const EdgeInsets.fromLTRB(7, 80, 27, 5),
                              imageUrl: "images/hermes.jpeg",
                              cardText: "Shibuya "),
                          ReusableCard(
                              width: 100,
                              height: 100,
                              padding: const EdgeInsets.fromLTRB(7, 80, 27, 5),
                              imageUrl: "images/hermes.jpeg",
                              cardText: "Shinjuku"),
                          ReusableCard(
                              width: 100,
                              height: 100,
                              padding: const EdgeInsets.fromLTRB(7, 80, 27, 5),
                              imageUrl: "images/hermes.jpeg",
                              cardText: "Harajuku"),
                          ReusableCard(
                              width: 100,
                              height: 100,
                              padding: const EdgeInsets.fromLTRB(7, 80, 27, 5),
                              imageUrl: "images/hermes.jpeg",
                              cardText: "Asakusa Shrine")
                        ],
                      ),
                    ]),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Events",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                Container(
                  padding: const EdgeInsets.all(90),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black),
                  child: Center(
                    child: Text(
                      "No upcoming events",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Restaurants",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          size: 15,
                          color: Colors.blue,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableCard(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.fromLTRB(7, 80, 27, 5),
                            imageUrl: "images/hermes.jpeg",
                            cardText: "Shibuya"),
                        ReusableCard(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.fromLTRB(7, 80, 27, 5),
                            imageUrl: "images/hermes.jpeg",
                            cardText: "Shinjuku"),
                        ReusableCard(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.fromLTRB(7, 80, 27, 5),
                            imageUrl: "images/hermes.jpeg",
                            cardText: "Harajuku"),
                      ],
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
