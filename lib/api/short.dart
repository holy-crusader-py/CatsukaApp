import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;

Future<BreveObject> fetchBreve(String link) async {
  var client = Client();
  Response response = await client.get(Uri.parse(link));

  if (response.statusCode != 200) {
    return BreveObject.empty();
  }

  var document = parse(response.body);

  dom.Element content = document.querySelectorAll('div.zoneintro').last;
  String title = content
      .querySelector('div.cadremenudroitgrisclair > div > a > b')!
      .text;
  String imageUrl =
      "https://www.catsuka.com/${content.querySelectorAll('div.cadremenudroitgrisclair > img[width="250"]')[0].attributes['src']!}";

  dom.Element newsContainer =
      content.getElementsByClassName("txtnoir14").first;
  
  return BreveObject(
    title: title,
    imageUrl: imageUrl,
    content: newsContainer.innerHtml.split('<br>'),
  );
}

class BreveObject {
  final String title;
  final String imageUrl;
  final List content;

  BreveObject({
    required this.title,
    required this.imageUrl,
    required this.content,
  });

  static BreveObject empty() {
    return BreveObject(title: "", imageUrl: "", content: []);
  }
}