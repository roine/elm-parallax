module Parallax exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, src, style)


type alias BaseConfig =
    {}


type alias GroupConfig =
    { frames : Float, position : Position }


type Position
    = Front
    | Back


initialGroupConfig : GroupConfig
initialGroupConfig =
    { frames = 1
    , position = Front
    }


type alias LayerConfig =
    { speed : Float, image : Maybe Img }


initialLayerConfig : LayerConfig
initialLayerConfig =
    { speed = 1, image = Nothing }


type alias Img =
    { src : String }


base : BaseConfig -> List (Html msg) -> Html msg
base config children =
    div
        [ style baseStyle, class "parallax-base" ]
        children


layerGroup : GroupConfig -> List (Attribute msg) -> List (Html msg) -> Html msg
layerGroup config attributes children =
    div ([ style (groupStyle config), class "parallax-group" ] ++ attributes) children


layer : LayerConfig -> List (Attribute msg) -> List (Html msg) -> Html msg
layer { speed, image } attributes children =
    case image of
        Just imgInfo ->
            img ([ style (imageLayerStyle speed), src imgInfo.src ] ++ attributes) []

        Nothing ->
            div
                ([ style (layerStyle speed), class "parallax-layer" ] ++ attributes)
                children


baseStyle : List ( String, String )
baseStyle =
    [ ( "height", "100vh" )
    , ( "perspective", (toString perspective) ++ "px" )
    , ( "overflowX", "hidden" )
    , ( "overflowY", "auto" )
    , ( "transform", "translate3d(0, 0, 0)" )
    , ( "perspectiveOrigin", "100%" )
    ]


groupStyle : GroupConfig -> List ( String, String )
groupStyle { frames, position } =
    [ ( "position", "relative" )
    , ( "height", toString (frames * 100) ++ "vh" )
    , ( "transformStyle", "preserve-3d" )
    , ( "zIndex"
      , case position of
            Front ->
                "5000"

            Back ->
                "4900"
      )
    ]


imageLayerStyle speed =
    [ ( "position", "absolute" )
    , ( "top", "50%" )
    , ( "left", "50%" )
    , ( "willChange", "transform" )
    , ( "transformOrigin", "100%" )
    , ( "transform", "translate3d(-50%,-50%, " ++ (toString (translateZ speed)) ++ "px) scale(" ++ (toString (scale speed) ++ ")") )
    , ( "zIndex", (toString (speed * -100)) )
    ]


layerStyle : Float -> List ( String, String )
layerStyle speed =
    [ ( "position", "absolute" )
    , ( "top", "0" )
    , ( "left", "0" )
    , ( "right", "0" )
    , ( "bottom", "0" )
    , ( "willChange", "transform" )
    , ( "transformOrigin", "100%" )
    , ( "transform", "translateZ(" ++ (toString (translateZ speed)) ++ "px) scale(" ++ (toString (scale speed) ++ ")") )
    , ( "zIndex", (toString (speed * -100)) )
    ]


perspective =
    300


scale speed =
    1 + ((translateZ speed) * -1) / perspective


translateZ speed =
    speed * perspective
