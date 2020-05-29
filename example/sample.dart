import 'dart:io';

import 'package:dialoguewise/dialoguewise.dart';

void main() async{
  var request = new DialogueWiseRequest();
  request.dialogueName = 'hero-section';
  request.isPilot = false;
  request.apiKey = 'b1266377591c4f2a9494c3abdd2cac5381D6Z825D26CEBAE8B6rn';
  request.emailHash='/kgmM46s1xC56BOFWRZp4j+0bdU19URpXdNT9liAX50=';
  request.variableList = new Map<String,int>();
  request.variableList['@wheel'] = 2;

  var k = new DialogueWiseService(new HttpClient()); 
  Map res = await k.getDialogue(request);
  print(res);

}