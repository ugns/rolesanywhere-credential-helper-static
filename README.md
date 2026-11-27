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

CI produces per-architecture artifacts and SHA256SUMS. Public release automation, provenance and SBOM publication will be added after the initial build matrix is validated. Do not use unreviewed CI artifacts as production dependencies.

## Updating upstream

Update VERSION and UPSTREAM_COMMIT together after reviewing upstream releases and verifying the tag's resolved commit. Renovate manages build-image and GitHub Actions dependencies; upstream source updates are manual for now.

## License

Build tooling is Apache-2.0. AWS upstream code remains subject to its own license and third-party notices; review these before redistributing binaries.
