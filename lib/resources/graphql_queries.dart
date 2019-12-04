//--------------------------------------get All Menu Group----------------------------------------
final String drawerQuery = r"""
                    query getMenuGroup{
                      getAllMenuGroup{
                        name
                      }
                    }
                  """;

//--------------------------------------Get All Food Item----------------------------------------
final String bodyQuery = r"""
                    query getAllItem($offset: Int) {
    getAllItem(offset: $offset) {
      menuItem {
        _id
        images
        allergyInfo
        description
        excludeDiscount
        groupId {
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
