import 'package:flutter/material.dart';
import 'package:mech_track/shared/FAQs.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  List<PanelContent> panels = faqs.map((faq) {
    return PanelContent(false, faq.title, faq.content);
  }).toList();

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
              headerBuilder: (context, isOpen) => ListTile(
                title: Text(panel.title)
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: RichText(
                  text: TextSpan(
                      children: panel.content.map((content) {
                        return content[0] == '%' ?
                        TextSpan(text: content.substring(1) + '\n', style: theme.textTheme.bodyText1) :
                        TextSpan(text: content + '\n', style: theme.textTheme.bodyText2);
                      }).toList()
                  ),
                ),
              ),
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
  List<String> content;
  bool status;

  PanelContent(this.status, this.title, this.content);
}
