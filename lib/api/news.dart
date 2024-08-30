import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;

Future<NewsObject> fetchNews(String link) async {
  var client = Client();
  Response response = await client.get(Uri.parse(link));

  if (response.statusCode != 200) {
    return NewsObject.empty();
  }
  
  var document = parse(response.body);

  dom.Element content = document.querySelectorAll('div.zoneintro').last;
  String title = content.querySelector('div.newsinfos_desktop > a > b')!.text;
  String subtitle =
      content.querySelector('div.newsinfos_desktop > span.txtnoir17')!.text;
  String imageUrl =
      "https://www.catsuka.com/${content.querySelector('div > div.newsheaddroite > img')!.attributes['src']!.replaceAll('vignettes_news/', 'vignettes_news/big/')}";

  dom.Element newsContainer =
      content.getElementsByClassName("txtnoir14").first;
  
  
  return NewsObject(
    title: title,
    subtitle: subtitle,
    imageUrl: imageUrl,
    content: newsContainer.innerHtml.split('<br>'),
  );
}

class NewsObject {
  final String title;
  final String subtitle;
  final String imageUrl;
  final List content;

  NewsObject({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.content,
  });

  static NewsObject empty() {
    return NewsObject(title: "", subtitle: "", imageUrl: "", content: []);
  }
}