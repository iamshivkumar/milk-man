import 'package:flutter/material.dart';
import 'package:milk_man_app/ui/pages/orders/orders_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Milk Man"),
        
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Orders"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>OrdersPage(),),);
            },
          ),
          ListTile(
            title: Text("Subscription delivery scedule"),
          ),
          ListTile(
            title: Text("Subscriptions"),
          )
        ],
      ),
    );
  }
}

