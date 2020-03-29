module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main =
    Browser.sandbox { init = init, view = view, update = update }


type alias Model =
    { name : String
    , age : Int
    , kind : DinoKind
    , dinoList : List Dino
    , formValidation : Bool
    }


type alias Dino =
    { name : String
    , age : Int
    , kind : DinoKind
    }


init : Model
init =
    Model "" 0 NoKind [] False


type Msg
    = DinoList
    | DinoName String
    | DinoAge String
    | SaveDinoKind String


type DinoKind
    = Big
    | Medium
    | Small
    | NoKind


update : Msg -> Model -> Model
update msg model =
    case msg of
        DinoName name ->
            if name == "" then
                { model | formValidation = False }

            else
                { model | name = name }

        DinoAge age ->
            if Maybe.withDefault 0 (String.toInt age) == 0 then
                { model | formValidation = False }

            else
                { model | age = Maybe.withDefault 0 (String.toInt age) }

        SaveDinoKind kind ->
            let
                transformedKind =
                    case kind of
                        "Big" ->
                            Big

                        "Medium" ->
                            Medium

                        "Small" ->
                            Small

                        _ ->
                            NoKind
            in
            if transformedKind == NoKind then
                { model | formValidation = False }

            else
                { model | kind = transformedKind }

        DinoList ->
            let
                newDino =
                    { name = model.name
                    , age = model.age
                    , kind = model.kind
                    }
            in
            if model.name == "" || model.age == 0 || model.kind == NoKind then
                model

            else
                { model | dinoList = newDino :: model.dinoList }


dinoAttributes =
    [ style "margin" "0px"
    , style "padding" "100px"
    , style "font-family" "system-ui"
    , style "background-color" "#e0e0d1"
    , style "color" "#993333"
    ]


buttonAttributes =
    [ style "color" "#ffffff"
    , style "background-color" "#000000"
    , style "text-transform" "capitalize"
    , style "border" "0px"
    , style "padding" "5px"
    , style "margin" "5px"
    , onClick DinoList
    ]


inputAttributes customInputs customPlaceHolders =
    [ onInput customInputs
    , placeholder customPlaceHolders
    , style "background-color" "#ffbb99"
    , style "color" "red"
    , style "border" "0px"
    , style "padding" "5px"
    , style "margin" "5px"
    ]


view : Model -> Html Msg
view model =
    div dinoAttributes
        [ h1 [] [ text "Dino Catalog!" ]
        , input (inputAttributes DinoName "Name") []
        , input (inputAttributes DinoAge "Age") []
        , input (inputAttributes SaveDinoKind "Kind") []
        , button buttonAttributes [ text "Send me a new Dino!" ]
        , br [] []
        , br [] []
        , viewDinos model
        , viewValidation model
        ]


viewValidation : Model -> Html msg
viewValidation model =
    if model.name == "" || model.age == 0 || model.kind == Big then
        div [ style "color" "red" ] [ text "Nothing to read" ]

    else
        div [ style "color" "green" ] [ text "Something to insert!" ]


viewDinos : Model -> Html Msg
viewDinos model =
    div []
        [ div []
            (List.map
                (\dino ->
                    let
                        dinoKindString =
                            case dino.kind of
                                Big ->
                                    "Big"

                                Medium ->
                                    "Medium"

                                Small ->
                                    "Small"

                                NoKind ->
                                    "No Kind!"

                        dinoAgeString =
                            String.fromInt dino.age
                    in
                    div []
                        [ h1 [] [ text dino.name ]
                        , h2 [] [ text dinoAgeString ]
                        , h2 [] [ text dinoKindString ]
                        ]
                )
                model.dinoList
            )
        ]