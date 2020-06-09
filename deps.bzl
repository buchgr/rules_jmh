load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def rules_jmh_deps(rules_jvm_external_tag="3.2", rules_jvm_external_sha = "82262ff4223c5fda6fb7ff8bd63db8131b51b413d26eb49e3131037e79e324af"):
  if "rules_jvm_external" not in native.existing_rules():
    http_archive(
        name = "rules_jvm_external",
        sha256 = rules_jvm_external_sha,
        strip_prefix = "rules_jvm_external-%s" % rules_jvm_external_tag,
        url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % rules_jvm_external_tag,
    )
