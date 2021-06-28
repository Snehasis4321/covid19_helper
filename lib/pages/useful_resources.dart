import 'package:covid19_helper/api_methods/api_methods.dart';
import 'package:covid19_helper/api_methods/model.dart';
import 'package:covid19_helper/pages/testings.dart';
import 'package:covid19_helper/webpage/webpage.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class RedirectedPage extends StatelessWidget {
  RedirectedPage({Key? key, required this.name}) : super(key: key);
  final String name;

  void _launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
        Theme.of(context).accentColor == Colors.indigo ? kBlackBack : kPinkCont;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: bgColor,
      ),
      body: FutureBuilder<List<Resources>>(
        future: ResourcesApi.getResources(context, name),
        builder: (context, snapshot) {
          final users = snapshot.data;

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if ((snapshot.hasError)) {
                return Center(
                  child: Text('Something fishy'),
                );
              } else {
                return buildChart(users!);
              }
          }
        },
      ),
    );
  }

  Widget buildChart(List<Resources> users) => ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return ListTile(
            onTap: () {
              print('Being tapped ${user.name}');
              if (name == 'Whatsapp' || name == 'Telegram') {
                print('insid wp or tele');
                _launchURL(user.links);
              } 
              else if(name=='Testings'){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Testings()));
              }
              else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Webpage(pageName: user.name, pageUrl: user.links)));
              }
            },
            title: Text(user.name),
            subtitle: Text('Click here to visit'),
            //leading: Text(index.toString()),
            trailing: TextButton(
              child: Text('Visit'),
              onPressed: () {},
            ));
      });
}