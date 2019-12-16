import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink httpLink = HttpLink(
  uri: 'http://18.141.25.176:3003/',
);

final AuthLink authLink = AuthLink(
  getToken: () async =>
      "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJDb25zb2xlSVQiLCJ1c2VyVHlwZSI6IlVzZXIiLCJpZCI6IjVkZjc4OWFjM2YxNjNmNWZmOTlhYzU2YyIsImlhdCI6MTU3NjUwMzcyNDg2MywiZXhwIjoxNTc2NTkwMTI0ODYzfQ.EJZ0mjWmbq9F20Lfz2vCi5cTfL6Kojh-EYddcwtDOyw",
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
