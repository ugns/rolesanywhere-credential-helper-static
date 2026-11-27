# AWS IAM Roles Anywhere credential helper — static Linux builds

Unofficial UnderGrid distribution of unmodified [AWS upstream source](https://github.com/aws/rolesanywhere-credential-helper), compiled with musl and CGO enabled for portable Linux use. Not affiliated with or endorsed by AWS.

## Build locally

Use a native Linux AMD64 or ARM64 machine with Podman (or Docker):

```sh
make build
# or
make build ENGINE=docker
```

The binary is written to `dist/aws_signing_helper-<version>-linux-<arch>-static`. VERSION and UPSTREAM_COMMIT pin the source tag and its resolved commit. The build checks both, embeds the upstream version and verifies the ELF architecture and lack of an interpreter or shared-library dependencies.

## Support

PEM certificate/private-key authentication on Linux AMD64 was tested against live Roles Anywhere in Vault's Alpine container during the proof of concept. CI exercises version execution on both architectures across several Linux distributions and scratch. These smoke tests are not live authentication tests. ARM64 authentication, TPM and PKCS#11 are not validated; static musl cannot normally dynamically load PKCS#11 modules.

HTTPS authentication requires trusted CA certificates, DNS, network access, readable credentials and a compatible Linux kernel. Scratch images must supply these runtime resources.

## Releases

CI produces a combined release-assets artifact containing both architectures, SHA256SUMS, SPDX JSON SBOMs, dependency license bundles and toolchain metadata. Alpine is chosen for its native musl toolchain, not as a target operating system.

After merging a reviewed change to main, create and push a tag matching VERSION (for example, v1.8.6). The same CI matrix builds and verifies the assets, checks the tag is reachable from main, attests the packaged files, and creates a draft GitHub release. Review its license bundles, SBOMs, checksums and provenance before publishing. Protect release tags with repository rulesets. Never move a published tag or overwrite a published release.

Download the binary and SHA256SUMS from the published release. Verify the binary and its GitHub provenance before installation:

```sh
binary=aws_signing_helper-1.8.6-linux-amd64-static
grep -F "  $binary" SHA256SUMS | sha256sum --strict -c -
gh attestation verify "$binary" --repo ugns/rolesanywhere-credential-helper-static
install -m 0755 "$binary" /usr/local/bin/aws_signing_helper
```

Do not use unreviewed CI artifacts as production dependencies. The binary SBOM may not identify every statically linked C component; consult the recorded Alpine packages and license bundle as well. The build image is currently version-tagged and Alpine packages are resolved at build time; byte-for-byte reproducibility is not asserted.

## Updating upstream

Update VERSION and UPSTREAM_COMMIT together after reviewing upstream releases and verifying the tag's resolved commit. Renovate manages build-image and GitHub Actions dependencies; upstream source updates are manual for now.

## License

Build tooling is Apache-2.0. AWS upstream code remains subject to its own license and third-party notices; review these before redistributing binaries. The build collects AWS LICENSE/NOTICE, Go toolchain notices, Go dependency licenses and musl copyright. Review completeness, including any linked compiler runtime, before publishing.
