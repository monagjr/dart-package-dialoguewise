import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';


class DialogueWiseService {
  HttpClient httpClient;
  String apiBaseUrl = 'https://api.dialoguewise.com/api/';
  
  DialogueWiseService(HttpClient httpClient) { 
     this.httpClient = httpClient; 
   } 
  
  getDialogue(DialogueWiseRequest request) async {
    var currentUtc = new DateFormat('dd/MM/y hh:mm:ss a').format(new DateTime.now().toUtc());
    var isPilotFlag = request.isPilot?'&isPilotVersion=true' : '';
    var apiUrl = this.apiBaseUrl + 'dialogue/getdialogue?dialogueName=' + request.dialogueName + isPilotFlag;
    var message = '/api/dialogue/getdialogue:' + currentUtc;
    // hash message
    var key = utf8.encode(request.apiKey);
    var bytes = utf8.encode(message);
    var hmacSha256 = new Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);    
    String hashMessage = base64.encode(digest.bytes);
    Map<String,dynamic> data = request.variableList;

    var authentication = request.emailHash + ':' + hashMessage;
   
    HttpClientRequest clientRequest = await this.httpClient.postUrl(Uri.parse(apiUrl));
    clientRequest.headers.add('Access-Control-Allow-origin', '*');
    clientRequest.headers.add('Access-Control-Allow-Methods', '*');
    clientRequest.headers.add('Access-Control-Allow-Headers', 'Content-Type, Timestamp, Authentication');
    clientRequest.headers.add(HttpHeaders.contentTypeHeader,'application/json');
    clientRequest.headers.add('Authentication', authentication);
    clientRequest.headers.add('Timestamp', currentUtc);
    // add data to request
    if (data != null && data.isNotEmpty){
      clientRequest.write(jsonEncode(data));
    }
    HttpClientResponse response = await clientRequest.close();
    String responseBody = await response.transform(utf8.decoder).join();
    Map jsonResponse = jsonDecode(responseBody) as Map;
    this.httpClient.close();
    return jsonResponse;
  }
}

class DialogueWiseRequest{
  String dialogueName;
  bool isPilot;
  String apiKey;
  String emailHash;
  Map<String,dynamic> variableList;
}