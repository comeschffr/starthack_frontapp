import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starthack_frontapp/service/http_service.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter/cupertino.dart';

import 'detailpage.dart';
import 'package:http/http.dart' as http;

class Content {
  final String? text;

  Content({this.text});
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = true;
  late List usersData;
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Future getData() async {
    //String response = await HttpService().getnextcard();
    //print(jsonDecode(response)['results']);
    List<dynamic> data = [
      {
        "movie_id": 603,
        "title": "The Matrix 1",
        "release_date": '1999',
        "poster_url":
            "https://m.media-amazon.com/images/M/MV5BNzQzOTk3OTAtNDQ0Zi00ZTVkLWI0MTEtMDllZjNkYzNjNTc4L2ltYWdlXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_FMjpg_UX1000_.jpg",
        "trailer_url": "https://www.youtube.com/watch?v=vKQi3bBA1y8",
      }
    ];
    print(data[0]);
    print("printed data");
    setState(() {
      usersData = data;

      if (usersData.isNotEmpty) {
        for (int i = 0; i < usersData.length; i++) {
          print(usersData[i]);
          _swipeItems.add(SwipeItem(
              // content: Content(text: _names[i], color: _colors[i]),
              content: Content(text: usersData[i]['title']),
              likeAction: () {
                _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text("Liked "),
                  //  content: Text("Liked ${_names[i]}"),
                  duration: Duration(milliseconds: 500),
                ));
              },
              nopeAction: () {
                _scaffoldKey.currentState?.showSnackBar(SnackBar(
                  content: Text("Nope ${usersData[i]['title']}"),
                  duration: const Duration(milliseconds: 500),
                ));
              },
              superlikeAction: () {
                _scaffoldKey.currentState?.showSnackBar(SnackBar(
                  content: Text("Superliked ${usersData[i]['title']}"),
                  duration: const Duration(milliseconds: 500),
                ));
              },
              onSlideUpdate: (SlideRegion? region) async {
                print("Region $region");
              }));
        } //for loop
        _matchEngine = MatchEngine(swipeItems: _swipeItems);
        isLoading = false;
      } //if
    }); // setState
  } // getData

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: Color.fromARGB(255, 26, 0, 70),
      key: _scaffoldKey,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(255, 26, 0, 70)),
        elevation: 0.0,
        backgroundColor: Color.fromARGB(255, 26, 0, 70),
        toolbarHeight: 50.0,
        titleSpacing: 36.0,
        title: const Text(
          'Discover',
          style: TextStyle(
              fontSize: 30.0,
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold),
        ),
        shape: Border(bottom: BorderSide(color: Colors.pink)),
      ),
      body: Container(
        child: isLoading
            ? const CircularProgressIndicator()
            : Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: SwipeCards(
                          matchEngine: _matchEngine!,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Card(
                                  margin: const EdgeInsets.all(16.0),
                                  shadowColor: Colors.deepPurple,
                                  elevation: 12.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24.0),
                                      child: Image.network(
                                          usersData[index]['poster_url']),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 430,
                                  child: Container(
                                    // alignment: Alignment.bottomCenter,
                                    height: 50.0,
                                    width: MediaQuery.of(context).size.width *
                                        0.87,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Color.fromARGB(204, 2, 0, 0)),
                                    margin: const EdgeInsets.fromLTRB(
                                        24.0, 40.0, 24.0, 24.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  ((context) =>
                                                                      DetailsPage(
                                                                        title: usersData[index]
                                                                            [
                                                                            'title'],
                                                                        releasedate:
                                                                            usersData[index]['release_date'],
                                                                        posterurl:
                                                                            usersData[index]['poster_url'],
                                                                      ))));
                                                    },
                                                    icon: Icon(
                                                      CupertinoIcons.info,
                                                      color: Colors.white,
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                    ),
                                                    label: Text(
                                                      usersData[index]
                                                              ["title"] +
                                                          ", " +
                                                          usersData[index]
                                                              ["release_date"],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.87 *
                                                            1.1 /
                                                            usersData[index]
                                                                    ['title']
                                                                .length,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          onStackFinished: () {
                            _scaffoldKey.currentState!
                                .showSnackBar(const SnackBar(
                              content: Text("Stack Finished"),
                              duration: Duration(milliseconds: 500),
                            ));
                          },
                          itemChanged: (SwipeItem item, int index) {
                            print(
                                "item: \\\${item.content.text}, index: \\\$index");
                          },
                          upSwipeAllowed: true,
                          fillSpace: true,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black,
                                      spreadRadius: 2)
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.clear,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _matchEngine!.currentItem?.nope();
                                  },
                                  // child: const Text("Nope"),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black,
                                      spreadRadius: 2)
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 36.0,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 32.0,
                                  backgroundColor: Colors.deepPurple,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 40.0,
                                    ),
                                    onPressed: () {
                                      _matchEngine!.currentItem?.superLike();
                                    },
                                    //child: const Text("Superlike"),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black,
                                      spreadRadius: 2)
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.heart_fill,
                                    color: Colors.lightGreen,
                                  ),
                                  onPressed: () {
                                    _matchEngine!.currentItem?.like();
                                  },
                                  //  child: const Text("Like"),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color.fromARGB(255, 26, 0, 70),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.purple[100],
            unselectedItemColor: Colors.white,
            iconSize: 24.0,
            enableFeedback: true,
            mouseCursor: MouseCursor.uncontrolled,
            elevation: 16.0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search),
                label: 'search',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.play_arrow),
                label: 'shorts',
              ),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.bookmark_fill),
                  label: 'recommendations'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.profile_circled), label: "profile")
            ],
          ),
        ),
      ),
    );
  }
}
