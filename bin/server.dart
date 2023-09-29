import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as cors;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

import 'addcollections.dart' as addCol;
import 'model/addadmin_model.dart';

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';

void main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');

  var result = parser.parse(args);
  print(result['port']);

  // For Google Cloud Run, we respect the PORT environment variable
  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '8080';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  // var db = await Db.create('mongodb+srv://boopathi7448:wkeN28syli1bRsiU@cluster0.ehudlxo.mongodb.net/sample_adding');
  // //
  // await db.open(secure: true);
  // var collection=db.collection('sample_added_data');
  // collection.insertOne({
  //   "name": 'John Doe',
  //   "age": 30,
  //   "email": 'boo@gmail.com',
  // });
  // await db.drop();
  // print("databSe lll ${db.isConnected}");
  // var handler = const shelf.Pipeline()
  //     .addMiddleware(shelf.logRequests())
  //     .addHandler(_echoRequest);
  var app = Router();

  app.get('/hello', (shelf.Request request) {
    return shelf.Response.ok('hello-world');
  });


  app.post('/accounts', (shelf.Request request,) async{
    final body = await request.readAsString();
    var decodeData=jsonDecode(body);
    print("Getted Body $body --- ${decodeData}");
    final String _host = "DATABASE SERVER";
    final String _port = "27017";
    final String _dbName = "DATABASE NAME";
    // Db _db=Db('mongodb://localhost:8080');
    try{
      // await db.open(secure: true);
    }catch(e){
      print("error :: $e");
    }

    // print(_db.state);
    // print(_db.isConnected);

    List gg= [
      {
        "name": "Molecule Man",
        "age": 29,
        "secretIdentity": "Dan Jukes",
        "powers": [
          "Radiation resistance",
          "Turning tiny",
          "Radiation blast"
        ]
      },
      {
        "name": "Madame Uppercut",
        "age": 39,
        "secretIdentity": "Jane Wilson",
        "powers": [
          "Million tonne punch",
          "Damage resistance",
          "Superhuman reflexes"
        ]
      },
      {
        "name": "Eternal Flame",
        "age": 1000000,
        "secretIdentity": "Unknown",
        "powers": [
          "Immortality",
          "Heat Immunity",
          "Inferno",
          "Teleportation",
          "Interdimensional travel"
        ]
      }
    ];



    // usersData.insertMany([
    //   {
    //     "name": "Molecule Man",
    //     "age": 29,
    //     "secretIdentity": "Dan Jukes",
    //     "powers": [
    //       "Radiation resistance",
    //       "Turning tiny",
    //       "Radiation blast"
    //     ]
    //   },
    //   {
    //     "name": "Madame Uppercut",
    //     "age": 39,
    //     "secretIdentity": "Jane Wilson",
    //     "powers": [
    //       "Million tonne punch",
    //       "Damage resistance",
    //       "Superhuman reflexes"
    //     ]
    //   },
    //   {
    //     "name": "Eternal Flame",
    //     "age": 1000000,
    //     "secretIdentity": "Unknown",
    //     "powers": [
    //       "Immortality",
    //       "Heat Immunity",
    //       "Inferno",
    //       "Teleportation",
    //       "Interdimensional travel"
    //     ]
    //   }
    // ]);
    print(decodeData['name'].runtimeType);

    List filterList=[];
    gg.forEach((element) {

      if(decodeData['name']!=""&&element['name'].toString().toLowerCase().contains(decodeData['name'].toString().toLowerCase())){
        print("name");
        filterList.add(element);
        return;
      }else if(element['age'].toString().contains(decodeData['age'].toString())){
        print("age");
        filterList.add(element);
        return;
      }
    });
    if(filterList.isNotEmpty){
      return shelf.Response.ok('Request for "${filterList}"');
    }else{
      return shelf.Response.ok('No data found');
    }
    return shelf.Response.ok(body);
  });

  app.post('/addCollection', (shelf.Request request,) async{
    try{
      final body = await request.readAsString();
      Map<String ,dynamic> decodeData=jsonDecode(body);
      print("Getted Body $body --- ${decodeData}");
      AddAdmineData admindata =AddAdmineData.fromJson(decodeData);
      if(admindata.name=='Boopa' && admindata.password=='1234'){
        return addCol.addDataCollection(admindata.datas??[]);
      }else{
        return shelf.Response.ok('Kindly Check Your Credentials');
      }
    }catch (e){
      return shelf.Response.ok('Something went Wrong Please ty Again');
    }


  });
  /*final overrideHeaders = {
    ACCESS_CONTROL_ALLOW_ORIGIN: 'https://flutter-ninjaz.web.app',
    'Content-Type': 'application/json;charset=utf-8'
  };
  final handler = const Pipeline()
      .addMiddleware(corsHeaders(headers: overrideHeaders))
      .addHandler(app);*/
  var server = await io.serve(app, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
}