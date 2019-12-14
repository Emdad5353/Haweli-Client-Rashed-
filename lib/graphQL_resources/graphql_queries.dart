class QueryMutation {
//  String addPerson(String id, String name, String lastName, int age) {
//    return """
//      mutation{
//          addPerson(id: "$id", name: "$name", lastName: "$lastName", age: $age){
//            id
//            name
//            lastName
//            age
//          }
//      }
//    """;
//  }

  String paymentIntent() {
    return r"""
                    mutation paymentIntent(
                        $payment_method_types: [String],
                        $payment_method: String,
                        $amount: Float,
                        $currency: String
                        
                      ){
                    paymentIntent(
                      payment_method_types: $payment_method_types,
                      payment_method: $payment_method,
                      amount: $amount,
                      currency: $currency
                      
                    ){
                      msg,
                      clientSecret
                    }
}
                  """;
  }

  String createOrder() {
    return r"""
                    mutation CreateOrder($OrderModel: OrderInput){
                      CreateOrder(orderInput: $OrderModel){
                     
                        id
                        status
                      }
                    }
                  """;
  }

  String drawerQuery() {
    return r"""
                    query getMenuGroup{
                      getAllMenuGroup{
                        name
                        _id
                      }
                    }
                  """;
  }

  String bodyQuery(String groupID) {
    return r"""
                    query{
  getAllItemFromGroup(offset:0, groupId:"5ddbe0820d7b383f3cf64112"){
    menuItem{
      _id
      groupId{
        _id
      }
      name
      price
      modifierLevels{
        levelTitle,
      }
      hasSubItem
      subItem{
        modifierLevels{
          levelTitle
          modifiers{
            name
          }
        }
      }
    }
  }
}
                  """;
  }
}

//--------------------------------------get All Menu Group----------------------------------------
final String drawerQuery = r"""
                    query getMenuGroup{
                      getAllMenuGroup{
                        name
                        _id
                      }
                    }
                  """;

//--------------------------------------Get All Food Item----------------------------------------
final String bodyQuery = r"""
                   query getAllItem($offset: Int,) {
    getAllItem(offset: $offset) {
      menuItem {
        _id
        images
        allergyInfo
        description
        excludeDiscount
        groupId{
          _id
          name
        }
        hasSubItem
        images
        modifierLevels {
          _id
          levelTitle
          level
          maxAllowed
          modifiers {
            _id
            name
            price
          }
        }
        discount
        name
        price
        subItem {
          _id
          allergyInfo
          description
          excludeDiscount
          images
          modifierLevels {
            _id
            levelTitle
            level
            maxAllowed
            modifiers {
              _id
              name
              price
            }
          }
          discount
          name
          price
          suggestedQuantity
          status
        }
      }
      count
      msg
    }
  }
                  """;

//--------------------------------------Mutation SignIn Group----------------------------------------
final String mutationSignInQuery = r"""
                    mutation insert ($email:String!,$password:String!){
                      userLogin(email:$email, password:$password){
                        id
                        jwt
                        firstName
                        lastName
                        name
                        email
                        phoneno
                      }
                    }
                  """;

//--------------------------------------Mutation register Group----------------------------------------
final String mutationQuery = r"""
                    mutation insert($name:String!,$firstName:String!,$lastName:String!,$email:String!,$password:String!,$phoneno:String!){
                          userSignUp(
                            userSignUpData:{
                              name: $name
                              firstName: $firstName,
                              lastName: $lastName,
                              email: $email,
                              password:$password,
                              phoneno: $phoneno
                            }
                          ){
                            id,
                            name,
                            email,
                            password,
                            phoneno,
                            jwt
                          }
                        }
                  """;

final String mutationCartCreate = r"""
                    mutation CreateCart($cartInput: CartInput){
                      CreateCart(cartInput: $cartInput){
                        msg
                      }
                    }
                  """;

final String locationVerify = r"""
                    query validateLocation($postcode: String){
                      validateLocation(postcode: $postcode){
                        msg
                        id
                        deliveryCharge
                      }
                    }
                  """;
