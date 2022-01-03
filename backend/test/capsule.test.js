const Capsule = artifacts.require("Capsule");

contract("Capsule", async (accounts) => {
  let instance;
  beforeEach(async () => {
    instance = await Capsule.new();
  });
  it("create capsules", async () => {
    const {
      createCapsule,
      ownerCapsuleCount,
      capsuleToOwner,
      getTotalCapsules,
    } = instance;

    await createCapsule.sendTransaction("test", 10000000000);
    await createCapsule.sendTransaction("test", 10000000000);
    await createCapsule.sendTransaction("test", 10000000000);
    try {
      await instance.createCapsule.sendTransaction("test", 1);
      assert.fail("Unlock time is too early didn't fail");
    } catch (_) {}
    assert.equal(await getTotalCapsules(), 3);
    assert.equal(await ownerCapsuleCount(accounts[0]), 3);
    assert.equal(await capsuleToOwner(0), accounts[0]);
    assert.equal(await capsuleToOwner(1), accounts[0]);
  });
  it("destroy capsules", async () => {
    const {
      createCapsule,
      ownerCapsuleCount,
      getTotalCapsules,
      destroyCapsule,
    } = instance;
    await createCapsule.sendTransaction("test", 10000000000);
    await createCapsule.sendTransaction("test", 10000000000);
    await createCapsule.sendTransaction("test", 10000000000);
    await destroyCapsule(1);
    try {
      await destroyCapsule(1);
      assert.fail("Can't destroy an already destroyed capsule");
    } catch (_) {}
    try {
      await destroyCapsule(0, { from: accounts[1] });
      assert.fail("Can't destroy a capsule when you're not the owner");
    } catch (_) {}
    assert.equal(await getTotalCapsules(), 3);
    assert.equal(await ownerCapsuleCount(accounts[0]), 2);
  });
});
