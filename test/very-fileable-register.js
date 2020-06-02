const VeryFileableRegister = artifacts.require('VeryFileableRegister')

contract('VeryFileableRegister', (accounts) => {
  let instance
  const owner = accounts[0]
  const nonOwner = accounts[1]

  describe('constructor', () => {
    beforeEach(async () => {
      instance = await VeryFileableRegister.deployed()
    })
    
    it('has the correct starting fee per kb', async () => {
      const weiPerKb = (await instance.weiPerKb()).toNumber()
      expect(weiPerKb).to.eql(1000000000000)
    })

    it('has the correct base fee per kb', async () => {
      const baseFee = (await instance.baseFeeInWei()).toNumber()
      expect(baseFee).to.eql(1000000000000000)

    })

    it('has the correct owner', async () => {
      const ownerOfContract = await instance.owner()
      expect(ownerOfContract).to.eql(owner)
    })
  })

  describe('registerData', () => {

  })

  describe('updateWeiPerKb', () => {
    it('throws if called by not the owner', () => {

    })

  })

  describe('updateBaseFee', () => {
    it('throws if called by not the owner', () => {

    })
  })

  describe('getRegister', () => {

  })

  describe('Registered event', () => {

  })

  /*
    const metaCoinInstance = await MetaCoin.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (await metaCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoStartingBalance = (await metaCoinInstance.getBalance.call(accountTwo)).toNumber();

    // Make transaction from first account to second.
    const amount = 10;
    await metaCoinInstance.sendCoin(accountTwo, amount, { from: accountOne });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (await metaCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await metaCoinInstance.getBalance.call(accountTwo)).toNumber();

    assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
    assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  */
})
