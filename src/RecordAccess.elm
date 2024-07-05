module RecordAccess exposing (suite)

import Benchmark
import Gen.Benchmark.RecordAccess as Gen



-- giant records


suite : Benchmark.Benchmark
suite =
    Benchmark.scale "When you're accessing a record property for an attribute within Html.WithContext:"
        [ ( "10 classes, 1000 elements", \() -> Gen.view10 )
        , ( "100 classes, 1000 elements", \() -> Gen.view100 )
        , ( "1000 classes, 1000 elements", \() -> Gen.view1000 )
        , ( "baseline with context: no record access, classes inlined", \() -> Gen.baselineWithContext )
        , ( "baseline: no record access, classes inlined", \() -> Gen.baseline )
        ]
