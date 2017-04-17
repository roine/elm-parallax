module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, src, style)
import Random
import Dict exposing (Dict)
import FontAwesome.Web as Icon
import Parallax


-- MODEL


type alias Model =
    { positionStars : Dict Int (List ( Int, Int ))
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.batch <| List.map (\idx -> Random.generate (StarPosition idx) (Random.list 20 <| Random.pair (Random.int 0 100) (Random.int 0 100))) (List.range 0 2) )


initialModel : Model
initialModel =
    { positionStars = Dict.empty
    }



-- UPDATE


type Msg
    = NoOp
    | StarPosition Int (List ( Int, Int ))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        StarPosition idx list ->
            { model | positionStars = Dict.insert idx list model.positionStars } ! []



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Parallax.base {}
            [ Parallax.layerGroup { frames = 1, position = Parallax.Front }
                [ style [ ( "background", "#112532" ) ] ]
                (List.map
                    (\( x, y ) ->
                        Parallax.layer { speed = 0.4, image = Nothing }
                            []
                            [ span
                                [ style
                                    [ ( "top", (toString y) ++ "%" )
                                    , ( "left", (toString x) ++ "%" )
                                    , ( "position", "absolute" )
                                    , ( "opacity", "0.9" )
                                    , ( "color", "rgb(205, 205, 0)" )
                                    ]
                                ]
                                [ i [ class "fa fa-star fa-2x" ] [] ]
                            ]
                    )
                    (Maybe.withDefault [] (Dict.get 0 model.positionStars))
                    ++ List.map
                        (\( x, y ) ->
                            Parallax.layer { speed = 0.2, image = Nothing }
                                []
                                [ span
                                    [ style
                                        [ ( "top", (toString y) ++ "%" )
                                        , ( "left", (toString x) ++ "%" )
                                        , ( "position", "absolute" )
                                        , ( "opacity", "0.7" )
                                        , ( "color", "rgb(205, 205, 0)" )
                                        ]
                                    ]
                                    [ i [ class "fa fa-star fa-lg" ] [] ]
                                ]
                        )
                        (Maybe.withDefault [] (Dict.get 1 model.positionStars))
                    ++ List.map
                        (\( x, y ) ->
                            Parallax.layer { speed = 0, image = Nothing }
                                []
                                [ span
                                    [ style
                                        [ ( "top", (toString y) ++ "%" )
                                        , ( "left", (toString x) ++ "%" )
                                        , ( "position", "absolute" )
                                        , ( "opacity", "0.5" )
                                        , ( "color", "yellow" )
                                        ]
                                    ]
                                    [ i [ class "fa fa-star" ] [] ]
                                ]
                        )
                        (Maybe.withDefault [] (Dict.get 2 model.positionStars))
                )
            , Parallax.layerGroup Parallax.initialGroupConfig
                [ style [ ( "background", "#2D6786" ) ] ]
                [ Parallax.layer { speed = 0.1, image = Nothing }
                    []
                    [ span
                        [ style
                            [ ( "position", "absolute" )
                            , ( "top", "10%" )
                            , ( "left", "80%" )
                            , ( "transform", "translate(-80%, 10%)" )
                            , ( "color", "white" )
                            , ( "fontSize", "20px" )
                            ]
                        ]
                        [ text "Right" ]
                    ]
                , Parallax.layer { speed = 0.5, image = Nothing }
                    []
                    [ span
                        [ style
                            [ ( "position", "absolute" )
                            , ( "top", "110%" )
                            , ( "left", "20%" )
                            , ( "transform", "translate(-20%, 110%)" )
                            , ( "color", "white" )
                            , ( "fontSize", "20px" )
                            ]
                        ]
                        [ text "Left" ]
                    ]
                ]
            , Parallax.layerGroup { frames = 1, position = Parallax.Back }
                []
                [ Parallax.layer { speed = 0.2, image = Just (Parallax.Img "img/image-1.jpg") }
                    []
                    []
                ]
            , Parallax.layerGroup Parallax.initialGroupConfig
                [ style [ ( "background", "white" ) ] ]
                [ Parallax.layer { speed = 0.8, image = Nothing }
                    []
                    [ span [ style absoluteCenter ] [ text "The End" ] ]
                ]
            ]
        ]


absoluteCenter : List ( String, String )
absoluteCenter =
    [ ( "position", "absolute" )
    , ( "top", "50%" )
    , ( "left", "50%" )
    , ( "transform", "translate(-50%, -50%)" )
    ]


subscriptions model =
    Sub.none



-- INIT


main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
