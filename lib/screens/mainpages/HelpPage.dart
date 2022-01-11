import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  List<PanelContent> panels = [
    PanelContent(false, 'FAQ 1',
      RichText(
        text: TextSpan(
        style: TextStyle(color: Colors.black),
          children: <TextSpan>[
            TextSpan(text: 'Content 1')
          ]
        ),
      )
    ),
    PanelContent(false, 'FAQ 2',
        RichText(
          text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(text: 'Content 2')
              ]
          ),
        )
    ),
    PanelContent(false, 'FAQ 3',
        RichText(
          text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(text: 'Content 3')
              ]
          ),
        )
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Help Page'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
        ),
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: ExpansionPanelList(
            children: panels.map((panel) => ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (context, isOpen) => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Text(panel.title, style: theme.textTheme.headline5),
                ],
              ),
              body: panel.content,
              isExpanded: panel.status
            )).toList(),
            expansionCallback: (i, isOpen) => setState(() => panels[i].status = !isOpen),
          ),
        ),
      ),
    );
  }
}

class PanelContent {
  String title;
  Widget content;
  bool status;

  PanelContent(this.status, this.title, this.content);
}
