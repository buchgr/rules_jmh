load("@rules_jvm_external//:defs.bzl", "maven_install")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def rules_jmh_dependencies(
    jmh_version = "1.21",
    repositories = ["https://repo1.maven.org/maven2"]):
    """Loads the dependencies of rules_jmh.

    Args:
      jmh_version: The version of the JMH library.
      repositories: A list of maven repository URLs where
        to fetch JMH from.
    """

    http_archive(
        name = "rules_jvm_external",
        strip_prefix = "rules_jvm_external-1.2",
        sha256 = "e5c68b87f750309a79f59c2b69ead5c3221ffa54ff9496306937bfa1c9c8c86b",
        url = "https://github.com/bazelbuild/rules_jvm_external/archive/1.2.zip"
    )

    maven_install(
        name = "rules_jmh_maven",
        artifacts = [
            "org.openjdk.jmh:jmh-core:{}".format(jmh_version),
            "org.openjdk.jmh:jmh-generator-annprocess:{}".format(jmh_version),
        ],
        repositories = repositories,
    )

def jmh_java_benchmarks(name, srcs, deps=[], tags=[], plugins=[], **kwargs):
    """Builds runnable JMH benchmarks.

    This rule builds a runnable target for one or more JMH benchmarks
    specified as srcs. It takes the same arguments as java_binary,
    except for main_class.
    """
    plugin_name = "_{}_jmh_annotation_processor".format(name)
    native.java_plugin(
        name = plugin_name,
        deps = ["@rules_jmh_maven//:org_openjdk_jmh_jmh_generator_annprocess"],
        processor_class = "org.openjdk.jmh.generators.BenchmarkProcessor",
        visibility = ["//visibility:private"],
        tags = tags,
    )
    native.java_binary(
        name = name,
        srcs = srcs,
        main_class = "org.openjdk.jmh.Main",
        deps = deps + ["@rules_jmh_maven//:org_openjdk_jmh_jmh_core"],
        plugins = plugins + [plugin_name],
        tags = tags,
        **kwargs
    )
