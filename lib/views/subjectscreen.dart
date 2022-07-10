import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../models/cart.dart';
import '../models/subjects.dart';
import '../models/user.dart';

class subjectscreen extends StatefulWidget {
  final User user;
  const subjectscreen({Key? key, required this.user}) : super(key: key);

  @override
  State<subjectscreen> createState() => _subjectscreenState();
}

class _subjectscreenState extends State<subjectscreen> {
  List<Subject>? subList = <Subject>[];
  String titlecenter = "loading...";
  late double screenHeight, screenWidth, resWidth;

  TextEditingController searchController = TextEditingController();
  String search = "";
  String dropdownvalue = 'Programming 101';
  var types = [
    'All',
    'Programming 101',
    'Programming 201',
    'Introduction to Web programming ',
    'Web programming advanced',
    'Python for Everybody',
    'Introduction to Computer Science',
    'Code Yourself! An Introduction to Programming',
    'IBM Full Stack Software Developer Professional Certificate',
    'Graphic Design Specialization',
    'Fundamentals of Graphic Design',
    'Fundamentals of Graphic Design',
    'Full-Stack Web Development with React',
    'Software Design and Architecture',
    'Software Testing and Automation',
    'Introduction to Cyber Security',
  ];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount =2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount =2;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text(widget.user.name.toString()),
                accountEmail: Text(widget.user.email.toString()),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://yt3.ggpht.com/a/AATXAJyAi_BhKSr-j8Od_1jghYmAERow_f3lBy-gMA=s900-c-k-c0xffffffff-no-rj-mo"),
                )),
            _createDrawerItem(
              icon: Icons.book,
              text: 'My subjects',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.schedule,
              text: 'Schedule',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () {},
            ),
          ],
        ),
      ),
      body: subList!.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("Subject Available",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(subList!.length, (index) {
                          return Card(
                              child: Column(children: [
                            Flexible(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Column(children: [
                                        Text("RM " +
                                            double.parse(subList![index]
                                                    .subjectPrice
                                                    .toString())
                                                .toStringAsFixed(2)),
                                        Text(subList![index]
                                            .subjectName
                                            .toString())
                                      ]),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: IconButton(
                                            onPressed: () {
                                              _insertDialog();
                                            },
                                            icon: const Icon(
                                                Icons.shopping_cart))),
                                  ],
                                ))
                          ]));
                        })))
              ],
            ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  void _loadSubjects() {
    http.post(Uri.parse("http://192.168.43.47/mytutor2/php/loadsubject.php"),
        body: {}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {}
      var extractdata = jsondata['data'];
      subList = <Subject>[];
      extractdata['subject'].forEach((v) {
        subList!.add(Subject.fromJson(v));
      });
      titlecenter = subList!.length.toString() + "Product available";
      setState(() {});
    }); //do something
  }

  /*


  void _loadSearchDialog() {
        context: context,
        builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                "Search ",
              ),
              content: SizedBox(
                //height: screenHeight / 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          labelText: 'Search',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 60,
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0))),
                      child: DropdownButton(
                        value: dropdownvalue,
                        underline: const SizedBox(),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: types.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                      });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    search = searchController.text;
                    Navigator.of(context).pop();
                  },
                  child: const Text("Search"),
                )
              ],
            );
          },
        );
      };
    }
  }
*/
  void _insertDialog() {
    Widget build(BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text(
          "Add this detail",
          style: TextStyle(),
        ),
        content: const Text("Are you sure?", style: TextStyle()),
        actions: <Widget>[
          TextButton(
            child: const Text(
              "Yes",
              style: TextStyle(),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              _addtoCart();
            },
          ),
          TextButton(
            child: const Text(
              "No",
              style: TextStyle(),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }

    ;
  }

  void _addtoCart() {
    var widget;
    var subList;
    var index;
    http.post(Uri.parse("http://192.168.43.47/mytutor2/php/insert_cart.php"),
        body: {
          "email": widget.user.email.toString(),
          "subid": subList[index].subId.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _updateCart(int index, String s) {
    var cartList;
    if (s == "-") {
      if (int.parse(cartList[index].cartqty.toString()) == 1) {
        _deleteItem(index);
      }
    }

    http.post(Uri.parse("http://192.168.43.47/mytutor2/php/update_cart.php"),
        body: {'cartid': cartList[index].cartid, 'operation': s}).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _deleteItem(int index) {
    var cartList;
    var widget;
    http.post(Uri.parse("http://192.168.43.47/mytutor2/php/delete_cart.php"),
        body: {
          'user_email': widget.user.email,
          'cartid': cartList[index].cartid
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _loadCart() {
    var widget;
    http.post(Uri.parse("http://192.168.43.47/mytutor2/php/load_cart.php"),
        body: {
          'user_email': widget.user.email,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        var titlecenter = "Timeout Please retry again later";
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['cart'] != null) {
          var cartList = <Cart>[];
          extractdata['cart'].forEach((v) {
            cartList.add(Cart.fromJson(v));
          });
          int qty = 0;
          var totalpayable = 0.00;
          for (var element in cartList) {
            qty = qty + int.parse(element.cartqty.toString());
            totalpayable =
                totalpayable + double.parse(element.pricetotal.toString());
          }
          var titlecenter = qty.toString() + " Products in your cart";
          setState(() {});
        }
      } else {
        var titlecenter = "Your Cart is Empty ";
        var cartList;
        cartList.clear();
        setState(() {});
      }
    });
  }
}
