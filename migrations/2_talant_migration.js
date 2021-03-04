// ----------------------------------------------------------------------------
// contracts 폴더 안에 있는 [Talant] contract를 읽어와 blockchain에 배포한다.
// ----------------------------------------------------------------------------
const TalantToken = artifacts.require("./Talant");

module.exports = function(deployer){
    deployer.deploy(TalantToken);
};