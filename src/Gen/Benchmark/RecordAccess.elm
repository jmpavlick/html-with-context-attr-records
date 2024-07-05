module Gen.Benchmark.RecordAccess exposing (..)

import Acc
import Elm
import Elm.Annotation as Type
import Gen.Html as H
import Gen.Html.Attributes as Ha
import Gen.Html.WithContext as Hw
import Gen.Html.WithContext.Attributes as Hwa
import List.Extra
import UiBuilder


build : List Elm.File
build =
    [ Elm.file [ "Gen", "Benchmark", "RecordAccess" ] <|
        baseline
            :: baselineWithContext
            :: List.concatMap toTestDecls [ 10, 100, 1000 ]
    ]


baselineWithContext : Elm.Declaration
baselineWithContext =
    Elm.declaration "baselineWithContext" <|
        Hw.toHtml Elm.unit <|
            Hw.div [] <|
                List.map
                    (\i ->
                        Hw.div [ Hwa.class ("class" ++ String.fromInt i) ] []
                    )
                    (List.range 1 1000)


baseline : Elm.Declaration
baseline =
    Elm.declaration "baseline" <|
        H.div [] <|
            List.map
                (\i ->
                    H.div [ Ha.class ("class" ++ String.fromInt i) ] []
                )
                (List.range 1 1000)


toTestDecls : Int -> List Elm.Declaration
toTestDecls max =
    let
        toLabel : String -> String
        toLabel l =
            l ++ String.fromInt max

        recordFields =
            List.map (\i -> "class" ++ String.fromInt i |> UiBuilder.toClass) <|
                List.range 1 max

        contextType : Type.Annotation
        contextType =
            Type.record <|
                List.map
                    (\field ->
                        ( field.name, field.type_ )
                    )
                    recordFields

        contextTypeDecl : Elm.Declaration
        contextTypeDecl =
            Elm.alias (toLabel "Context")
                contextType

        contextTypeRef : Type.Annotation
        contextTypeRef =
            Type.named [] (toLabel "Context" ++ " msg")

        contextValue : Elm.Expression
        contextValue =
            Elm.record <|
                List.map
                    (\field ->
                        ( field.name, field.expr )
                    )
                    recordFields

        contextValueDecl : Elm.Declaration
        contextValueDecl =
            Elm.declaration (toLabel "context") <|
                Elm.withType contextTypeRef <|
                    contextValue

        contextValueRef : Elm.Expression
        contextValueRef =
            Elm.value { importFrom = [], name = toLabel "context", annotation = Just <| contextTypeRef }

        repeats : Int
        repeats =
            1000 // max

        viewDecl : Elm.Declaration
        viewDecl =
            Elm.declaration (toLabel "view") <|
                Hw.toHtml contextValueRef <|
                    Hw.div [] <|
                        List.concatMap
                            (\group ->
                                List.map
                                    (\i ->
                                        Hw.div
                                            [ Hw.withContextAttribute
                                                (\attr ->
                                                    Elm.get ("class" ++ String.fromInt i) attr
                                                        |> Hw.htmlAttribute
                                                )
                                            ]
                                            []
                                    )
                                    group
                            )
                        <|
                            List.repeat repeats (List.range 1 max)
    in
    [ viewDecl
    , contextTypeDecl
    , contextValueDecl
    ]
