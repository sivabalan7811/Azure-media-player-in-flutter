import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:WebViewTest(),
    ), onWillPop: () async {
      return false;
    },
    );
  }

  backButton(){

    print("hhd");
  }
}
class WebViewTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebViewTestState();
  }
}

class _WebViewTestState extends State<WebViewTest> {
  //
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
  WebViewController _webViewController;
  String filePath = 'assets/test.html';


 @override
  void dispose() {
    // TODO: implement dispose
   SystemChrome.setPreferredOrientations([
     DeviceOrientation.landscapeRight,
     DeviceOrientation.landscapeLeft,
     DeviceOrientation.portraitUp,
     DeviceOrientation.portraitDown,
   ]);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return
      WebView(
        initialUrl: '',
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: Set.from([
          JavascriptChannel(
              name: 'messageHandler',
              onMessageReceived: (JavascriptMessage message) {
                print(message.message);

              })
        ]),
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
          _loadHtmlFromAssets(context);
        },
      );
  }

  String screenWith(String size){




    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Azure Media Player</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width">

    <!--*****START OF Azure Media Player Scripts*****-->
    <!--Note: DO NOT USE the "latest" folder in production. Replace "latest" with a version number like "1.0.0"-->
    <!--EX:<script src="//amp.azure.net/libs/amp/1.0.0/azuremediaplayer.min.js"></script>-->
    <!--Azure Media Player versions can be queried from //amp.azure.net/libs/amp/latest/docs/changelog.html-->
    <script src="https://amp.azure.net/libs/amp/2.3.6//azuremediaplayer.min.js"></script>
    <link href="https://amp.azure.net/libs/amp/2.3.6//skins/amp-default/azuremediaplayer.min.css" rel="stylesheet">
    <!--*****END OF Azure Media Player Scripts*****-->

    <!--Add Plugins-->
     <script src="hotkeys.js"></script> 

</head>
<body>

 <video   id="azuremediaplayer" class="azuremediaplayer amp-default-skin amp-big-play-centered"   tabindex="0"> </video>
<script>



var timestampchangedevent = new Event('timestampchanged');
var touchmoved;
var timeMin;
   
   var init=true;


        var myOptions = {
        "nativeControlsForTouch": false,
            autoplay: true,
            controls:true,
            width: $size,
            height: "400",
          
          poster: "",
              hotkeys: {
                     //optional settings
                     "volumeStep": 0.1,
                     "seekStep": 15,
                     "enableMute": false,
                     "enableFullscreen": true,
                     "enableNumbers": true,
                     "enableJogStyle": false
                 }
        };
        var myPlayer = amp("azuremediaplayer", myOptions);
        
       
    
        myPlayer.src([{ src: "https://amssamples.streaming.mediaservices.windows.net/3b970ae0-39d5-44bd-b3a3-3136143d6435/AzureMediaServicesPromo.ism/manifest", type: "application/vnd.ms-sstr+xml" }, ]);
        console.log('timiming');
   
    
     
    myPlayer .addEventListener('timeupdate', function(e) {
    myPlayer.el_.dispatchEvent(timestampchangedevent);
    
    });
    myPlayer.addEventListener('timestampchanged', function(e)  {
   console.log('timestampchanged');
   //  console.log(e.updatedTimestampIndex);
  //  timeMin=  myPlayer.toTimecode(myPlayer.toPresentationTime(myPlayer.currentTime()));
    touchmoved = myPlayer.currentTime();
    // sendBack();
    
      });
      
       myPlayer.addEventListener('requestFullscreen', function(e)  {
   console.log('fullscreenchange');
   
    
      });
   
  myPlayer.addEventListener("touchend", function () {

            if(touchmoved != true){
                // click action
                console.log('clicked');
                //Here the play/pause action can be triggered
            
             
               
            }


        }).addEventListener("touchmove", function () {
            Log('touchmove');
            touchmoved = true;
            

        }).addEventListener("touchstart", function () {
            Log('touchstart');
            touchmoved = false;

        });
        
        function muteVid() {
        if (!myPlayer.muted()) {
            myPlayer.muted(true);
        } else {
            myPlayer.muted(false);
        }
    }  
    
    
    
    function play1(){
      myPlayer.currentTime(120);
       myPlayer.play();
       
       }
    
    function sendBack() {
  
       if(myPlayer.paused()){
       myPlayer.play();
       } else{
       
       myPlayer.pause();
       }
       
       
                messageHandler.postMessage(touchmoved);
             }
             
             
    </script>


</body>
</html>
''';
  }
  _loadHtmlFromAssets(BuildContext context) async {
    String fileHtmlContents = await rootBundle.loadString(filePath);
    String witdh = (MediaQuery.of(context).size.height.toInt()-20).toString();
  print("witdh");
    print(witdh);
    _webViewController.loadUrl(Uri.dataFromString(screenWith(witdh),
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());


  }
}

