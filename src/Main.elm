module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Set
import Time


type alias Position =
    ( Int, Int )


type alias Model =
    List Position


type Msg
    = NextStep Time.Posix
    | Reset


block : Model
block =
    [ ( 0, 0 ), ( 1, 0 ), ( 0, 1 ), ( 1, 1 ) ]


dieHard : Model
dieHard =
    [ ( 0, 1 ), ( 1, 0 ), ( 1, 1 ), ( 5, 0 ), ( 6, 0 ), ( 7, 0 ), ( 6, 2 ) ]


acorn : Model
acorn =
    [ ( 0, 0 ), ( 1, 0 ), ( 1, 2 ), ( 3, 1 ), ( 4, 0 ), ( 5, 0 ), ( 6, 0 ) ]


rPentomino : Model
rPentomino =
    [ ( 0, 1 ), ( 1, 1 ), ( -1, 0 ), ( 0, 0 ), ( 0, -1 ) ]


c10Orthogonal : Model
c10Orthogonal =
    [ ( 3, 0 )
    , ( 4, 0 )
    , ( 3, 1 )
    , ( 4, 1 )
    , ( 2, 3 )
    , ( 3, 3 )
    , ( 4, 3 )
    , ( 5, 3 )
    , ( 1, 4 )
    , ( 2, 4 )
    , ( 5, 4 )
    , ( 6, 4 )
    , ( 0, 5 )
    , ( 7, 5 )
    , ( 0, 7 )
    , ( 7, 7 )
    , ( 0, 8 )
    , ( 2, 8 )
    , ( 5, 8 )
    , ( 7, 8 )
    , ( 3, 9 )
    , ( 4, 9 )
    , ( 3, 10 )
    , ( 4, 10 )
    , ( 1, 11 )
    , ( 2, 11 )
    , ( 5, 11 )
    , ( 6, 11 )
    ]


init : () -> ( Model, Cmd Msg )
init flags =
    ( acorn, Cmd.none )


main : Program () Model Msg
main =
    Browser.element { init = init, view = view, update = update, subscriptions = subscriptions }


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 100 NextStep


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Reset ] [ text "Reset" ]
        , div [] (List.map aliveCell model)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            ( acorn, Cmd.none )

        NextStep _ ->
            ( nextStep model, Cmd.none )


nextStep : Model -> Model
nextStep model =
    model
        |> List.concatMap possibleNeighbours
        |> Set.fromList
        |> Set.toList
        |> List.filterMap (\position -> updatePosition model position)


updatePosition : Model -> Position -> Maybe Position
updatePosition model position =
    if willBeAlive (neighbourCount model position) (isAlive model position) then
        Just position

    else
        Nothing


willBeAlive : Int -> Bool -> Bool
willBeAlive numberOfNeighbours alive =
    numberOfNeighbours == 3 || numberOfNeighbours == 2 && alive


isAlive : Model -> Position -> Bool
isAlive model position =
    List.member position model


neighbourCount : Model -> Position -> Int
neighbourCount model position =
    position
        |> possibleNeighbours
        |> List.filter (isAlive model)
        |> List.length


possibleNeighbours : Position -> List Position
possibleNeighbours ( xPosition, yPosition ) =
    [ ( xPosition + 1, yPosition + 1 )
    , ( xPosition + 1, yPosition )
    , ( xPosition + 1, yPosition - 1 )
    , ( xPosition - 1, yPosition + 1 )
    , ( xPosition - 1, yPosition )
    , ( xPosition - 1, yPosition - 1 )
    , ( xPosition, yPosition + 1 )
    , ( xPosition, yPosition - 1 )
    ]


aliveCell : Position -> Html Msg
aliveCell ( xPosition, yPosition ) =
    div
        [ style "background-color" "black"
        , style "height" (String.fromInt cellSize ++ "px")
        , style "width" (String.fromInt cellSize ++ "px")
        , style "position" "absolute"
        , style "left" (String.fromInt (xPosition * (cellSize + 1) + offset) ++ "px")
        , style "bottom" (String.fromInt (yPosition * (cellSize + 1) + offset) ++ "px")
        ]
        []


cellSize : Int
cellSize =
    10


offset : Int
offset =
    200
