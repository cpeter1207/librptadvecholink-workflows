# EchoLink validation workflows

Reusable focused checks for `cpeter1207/librptadvecholink`.
`packet-fit.yml` accepts an exact source revision and uses the existing labeled
container launcher and current Debian 13 quality image. It does not log in to
EchoLink, access a radio, install to a node, merge code or release packages.

The full shared-library gate and release wrappers are added with the provider
contract. Production workflow logic is reused from the shared project workflows.
