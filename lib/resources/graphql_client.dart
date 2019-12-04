import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink httpLink = HttpLink(
  uri: 'https://rashedapi.consoleit.io/',
);

final AuthLink authLink = AuthLink(
  getToken: () async =>
  "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJDb25zb2xlSVQiLCJ1c2VyVHlwZSI6IkFkbWluIiwiaWQiOiI1ZGRiZDgzNDBkN2IzODNmM2NmNjQxMDkiLCJpYXQiOjE1NzQ3NjUwMTc4NjYsImV4cCI6MTU3NDg1MTQxNzg2Nn0.nnn9zZVulgyNWkuWpXp-EypTxAwLPpcFV-oGMIl2DZw",
);

final Link link = authLink.concat(httpLink);

final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    link: link,
    cache: InMemoryCache(),
  ),
);