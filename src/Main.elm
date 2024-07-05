module Main exposing (main)

import Benchmark
import Benchmark.Alternative
import Benchmark.Runner.Alternative as BenchmarkRunner exposing (defaultOptions, lightTheme)
import RecordAccess


main =
    BenchmarkRunner.programWith { defaultOptions | theme = lightTheme } suite


suite : Benchmark.Benchmark
suite =
    Benchmark.describe "How fast are you? Let's find out." [ RecordAccess.suite ]
