# rules_jmh

Bazel rules for generating and running microbenchmarks with [JMH](https://openjdk.java.net/projects/code-tools/jmh/).

# Usage

Load the JMH dependencies in your WORKSPACE file

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_jmh",
    strip_prefix = "buchgr-rules_jmh-cf2fcbe",
    url = "https://github.com/buchgr/rules_jmh/zipball/cf2fcbe974219973fe7bf7168021eb67d5690482",
    sha256 = "c5b898ea1e40524b867c2fc88a27b3ae84b5fc7265b0e129b709a47abe961280",
)

load("@rules_jmh//:defs.bzl", "rules_jmh_dependencies")
rules_jmh_dependencies()
```

You can specify JMH benchmarks by using the `jmh_java_benchmarks` rule. It takes the same arguments as `java_binary` except for `main_class`. One can specify one or more JMH benchmarks in the `srcs` attribute.


```python
load("@rules_jmh//:defs.bzl", "jmh_java_benchmarks")

jmh_java_benchmarks(
    name = "example-benchmarks",
    srcs = ["Benchmark1.java", "Benchmark2.java"]
)
```

You can run the benchmark `//:example-benchmarks` using `bazel run`.
```sh
$ bazel run :example-benchmarks
```

and also pass JMH command line flags

```sh
$ bazel run :example-benchmarks -- -f 0 -bm avgt
```

Alternatively you can also build a standalone fat (deploy) jar that contains all dependencies and can be run without Bazel

```sh
# Build the jar file
$ bazel build :example-benchmarks_deploy.jar
# Shutdown Bazel for it to not interfere with your benchmark
$ bazel shutdown
# Run the benchmark
$ java -jar bazel-bin/example-benchmarks_deploy.jar
```