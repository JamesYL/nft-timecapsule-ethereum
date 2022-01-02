const Capsule = artifacts.require("Capsule");

contract("Capsule", async (accounts) => {
  it("create capsule", async () => {
    const instance = await Capsule.deployed();
    await instance.createCapsule.sendTransaction("test", 10000000000);
    await instance.createCapsule.sendTransaction("test", 10000000000);
    assert.equal(await instance.getTotalCapsules(), 2);
    try {
      await instance.createCapsule.sendTransaction("test", 1);
      assert.fail("Unlock time is too early didn't fail");
    } catch (_) {}
  });
});
