# Tracked, ready-to-run fixture for the test/live harness - one representative
# real-usage instance exercising the module's common path.
#
# Maintained by whoever adds a new optional input to the module: update this
# file in the same PR if you want live coverage of it.

env = "livetest"

tags = {
  purpose = "module-live-test"
}
