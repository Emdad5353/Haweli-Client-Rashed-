import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final HttpLink httpLink = HttpLink(
  uri: 'http://27.147.231.42:3003/',
);

Future<String> getjwt() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  //  await storageUser.ready;
  //  Map<String ,dynamic> user=await storageUser.getItem('userData');
  if(prefs.getString('jwt')==null){
    // get guest user token
    return "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJDb25zb2xlSVQiLCJ1c2VyVHlwZSI6IlVzZXIiLCJpZCI6IjVkZjc4OWFjM2YxNjNmNWZmOTlhYzU2YyIsImlhdCI6MTU3NjUwMzcyNDg2MywiZXhwIjoxNTc2NTkwMTI0ODYzfQ.EJZ0mjWmbq9F20Lfz2vCi5cTfL6Kojh-EYddcwtDOyw";
  }
  else{
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
