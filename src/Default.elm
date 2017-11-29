module Default
    exposing
        ( Default
        , default
        , int
        , float
        , string
        , maybe
        , list
        , array
        , dict
        , tuple2
        , tuple3
        )

{-| A module to handle default values for any types.

Assume that you want stub functions when you are developing some applications.
You would declare dummy function that does not actualy execute `Task` but simply returns dummy value as follows.

```
stubInt : Task error Int -> Int
stubInt _ =
    0


stubString : Task error String -> String
stubString _ =
    ""
```

But are you still enough patient to define all of types even if you need `stubMaybeMaybeListInt` or many of combined types?

This is when you need this module.

You can declare general stub function and easily build any combined types.

    import Task exposing (Task)

    stubTask : Default a -> Task error a -> a
    stubTask def _ =
        default def

    stubTask int (Task.succeed 10)
    --> 0

    stubTask string (Task.succeed "foo")
    --> ""

    stubTask (maybe string) (Task.succeed <| Nothing)
    --> Just ""

    stubTask (maybe (maybe int)) (Task.succeed <| Just (Just 3))
    --> Just (Just 0)

# Types

@docs Default

# Getters

@docs default

# Basic default values

@docs int
@docs float
@docs string

# Combinators

@docs maybe
@docs list
@docs array
@docs dict
@docs tuple2
@docs tuple3
-}

import Array exposing (Array)
import Dict exposing (Dict)
import Task exposing (Task)


{-| Phantom type to define default value for type `a`.
-}
type Default a
    = Default a


{-| A getter function to unpack `Default`.
    default int
    --> 0

    default string
    --> ""

    default (maybe string)
    --> Just ""
-}
default : Default a -> a
default (Default a) =
    a


{-|
    default int
    --> 0
-}
int : Default Int
int =
    Default 0


{-|
    default float
    --> 0
-}
float : Default Float
float =
    Default 0


{-|
    default string
    --> ""
-}
string : Default String
string =
    Default ""


{-|
    default (maybe string)
    --> Just ""
-}
maybe : Default a -> Default (Maybe a)
maybe (Default a) =
    Default <| Just a


{-|
    default (list int)
    --> [ 0 ]
-}
list : Default a -> Default (List a)
list (Default a) =
    Default [ a ]


{-|
    import Array

    default (array (maybe int))
    --> Array.fromList [ Just 0 ]
-}
array : Default a -> Default (Array a)
array (Default a) =
    Default <| Array.fromList [ a ]


{-|
    import Dict

    default (dict int string)
    --> Dict.singleton 0 ""
-}
dict : Default comparable -> Default a -> Default (Dict comparable a)
dict (Default k) (Default v) =
    Default <| Dict.singleton k v


{-|
    default (tuple2 int string)
    --> ( 0, "" )
-}
tuple2 : Default a -> Default b -> Default ( a, b )
tuple2 (Default a) (Default b) =
    Default ( a, b )


{-|
    default (tuple3 int string (maybe int))
    --> ( 0, "", Just 0 )
-}
tuple3 : Default a -> Default b -> Default c -> Default ( a, b, c )
tuple3 (Default a) (Default b) (Default c) =
    Default ( a, b, c )
