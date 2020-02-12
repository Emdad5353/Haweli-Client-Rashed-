import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/graphQL_resources/graphql_queries.dart';
import 'package:haweli/utils/loader_cubeGrid.dart';

Widget mainDrawer(context) {
  return Drawer(
    child: Query(
      options: QueryOptions(
        document: QueryMutation().drawerQuery(),
      ),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        print(result);
        if (result.errors != null) {
          return Text(result.errors.toString());
        }
        if (result.errors != null) {
          return Text(result.errors.toString());
        }
        if (result.loading) {
          return Center(child: SpinKitPulse(color: Theme.of(context).primaryColor,));
        }
        if (result.data == null) {
          return Text("No Data Found !");
        }
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                manageStatesBloc.changeCurrentMenuGroup(
                    result.data['getAllMenuGroup'][index]['_id']);
                Navigator.pop(context);
              },
              child: drawerCardsWithFoodTypeName(context,
                  result.data['getAllMenuGroup'][index]['name'].toUpperCase()),
            );
          },
          itemCount: result.data['getAllMenuGroup'].length,
        );
      },
    ),
  );
}



Widget drawerCardsWithFoodTypeName(BuildContext context, String foodType) {
  return Card(
    margin: EdgeInsets.all(6),
    color: Theme.of(context).primaryColor,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          foodType,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    ),
  );
}
