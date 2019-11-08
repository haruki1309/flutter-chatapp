import 'package:flutter/material.dart';

class Homepage extends StatefulWidget{
  @override
  HomepageState createState() => HomepageState();
} 

class HomepageState extends State<Homepage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:  AppBar(title: Text("Friend List"),),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index){
                  return Material(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(50),
                            offset: Offset(0, 0) 
                          )
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  minRadius: 26,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Name', style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                                ),)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}