import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final HttpLink httpLink = HttpLink(
//  uri: 'http://192.168.16.107:3003/',
  uri: 'https://rashedapi.consoleit.io/',
  //uri: 'http://27.147.231.42:3003/',
  //uri: 'http://192.168.16.113:3003/',
);

Future<String> getjwt() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  //  await storageUser.ready;
  //  Map<String ,dynamic> user=await storageUser.getItem('userData');
//  if(pr efs.getString('jwt')==null){
//    // get guest user token
//    return "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJDb25zb2xlSVQiLCJ1c2VyVHlwZSI6IkFkbWluIiwiaWQiOiI1ZGY3ZWIwZmQyNDdlMTQzNzQwY2Q2YzIiLCJpYXQiOjE1NzY1Mjg4NTcxNjIsImV4cCI6MTU3NjYxNTI1NzE2Mn0.mXdDLpx-EoNp9VZjDSt7EsePsL1XDj4wwrpUyWWZICY";
//    return "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJDb25zb2xlSVQiLCJ1c2VyVHlwZSI6IkFkbWluIiwiaWQiOiI1ZGY3ZWIwZmQyNDdlMTQzNzQwY2Q2YzIiLCJpYXQiOjE1NzY1Mjg4NTcxNjIsImV4cCI6MTU3NjYxNTI1NzE2Mn0.mXdDLpx-EoNp9VZjDSt7EsePsL1XDj4wwrpUyWWZICY";
//  }
//  else{
//    return "Bearer "+prefs.getString('jwt');
//  }
  if(prefs.getString('jwt')!=null){
    // get guest user token
    return "Bearer "+prefs.getString('jwt');
  }
}

final AuthLink authLink = AuthLink(
    getToken: () async =>
    await getjwt()
);

final Link link = authLink.concat(httpLink);

final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    link: link,
    cache: InMemoryCache(),
  ),
);

GraphQLClient clientToQuery() {
  return GraphQLClient(cache: InMemoryCache(), link: link);
}

//{
//  "Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJDb25zb2xlSVQiLCJ1c2VyVHlwZSI6IkFkbWluIiwiaWQiOiI1ZGRiZDgzNDBkN2IzODNmM2NmNjQxMDkiLCJpYXQiOjE1NzQ3NjUwMTc4NjYsImV4cCI6MTU3NDg1MTQxNzg2Nn0.nnn9zZVulgyNWkuWpXp-EypTxAwLPpcFV-oGMIl2DZw"
//}
