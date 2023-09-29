import 'package:shelf/shelf.dart' as shelf;
import 'package:mongo_dart/mongo_dart.dart';

import 'model/addadmin_model.dart';

Future<shelf.Response> addDataCollection(List<Datas> datatoSave)async{

  if(datatoSave.isNotEmpty){
    try{
      var db = await Db.create('mongodb+srv://boopathi7448:wkeN28syli1bRsiU@cluster0.ehudlxo.mongodb.net/sample_adding');
      // var db = await Db.create('mongodb://localhost:27017');
      //
      await db.open(secure: true);
      var collection=db.collection('admin_List');
      datatoSave.forEach((element) {
        collection.insertMany([element.toJson()]);
      });
      return shelf.Response.ok('Data Added Successfully');
    }catch (e){
      print("Errer __ ${e}");
      return shelf.Response.ok('Unable to connect DataBase');
    }}else{
  return shelf.Response.ok('Your data was Empty');
  }

}