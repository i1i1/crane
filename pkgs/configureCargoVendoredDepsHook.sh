configureCargoVendoredDepsHook() {
  local vendoredDir="${1:-${cargoVendorDir:?not defined}}"
  local cargoConfig="${2:-${CARGO_HOME:?not defined}/config.toml}"

  echo setting source replacement config in ${cargoConfig} using vendored directory ${vendoredDir}

  # NB: we add this configuration to $CARGO_HOME/config.toml
  # instead of .cargo/config.toml. This allows cargo to honor the
  # project's configuration (if it exists) with greater specificity
  # than the config we are adding. If the project knows what it is
  # doing and has its own source replacement going on, it can happily
  # ignore the changes we are trying to make!
  cat >>"${cargoConfig}" <<EOF
[source.crates-io]
replace-with = "nix-sources"

[source.nix-sources]
directory = "${vendoredDir}"
EOF
}

if [ -n "${cargoVendorDir-}" ]; then
  preConfigureHooks+=(configureCargoVendoredDepsHook)
else
  echo "cargoVendorDir not set, will not automatically configure vendored sources"
fi