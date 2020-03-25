pragma solidity ^0.4.19;

library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract rightsTradeSystem {

    //right (rights of property)
    struct propertyRight {
        uint propertyRightId;//何番目に登録された財産（権利）か(0からスタート)、トレードで使用。

        // uint totalSupplyDisposable;
        uint totalSupplyAvailable;
        uint totalSupplyBeneficial;
        uint totalSupplyDisposable;
        string certificate;
        address [] beneficialHolders;

        // mapping (address =>uint) balancesDisposable;
        mapping (address =>uint) balancesAvailable;
        mapping (address =>uint) balancesBeneficial;
        mapping (address =>uint) balancesDisposable;

        //以下はレンディング機能を実装する際のもの
        // mapping (address =>lendingInfo) lendingTimesDisposable;
        // mapping (address =>lendingInfo) lendingTimesAvailable;
        // mapping (address =>lendingInfo) lendingTimesBeneficial;
    }


    //全ての権利情報
    propertyRight [] public propertyRights;


    //財産の権利を定義
    function _definePropertyRight(uint _totalSupplyAvailable, uint _totalSupplyBeneficial,uint _totalSupplyDisposable,string _certificate) public returns (uint) {
        uint propertyRightId = propertyRights.length;
        address[] memory whatever; //empty array
        propertyRights.push(propertyRight(propertyRightId,_totalSupplyAvailable,_totalSupplyBeneficial,_totalSupplyDisposable, _certificate,whatever));
        propertyRights[propertyRightId].balancesAvailable[msg.sender] = _totalSupplyAvailable;
        propertyRights[propertyRightId].balancesBeneficial[msg.sender] = _totalSupplyBeneficial;
        propertyRights[propertyRightId].balancesDisposable[msg.sender] = _totalSupplyDisposable;
        propertyRights[propertyRightId].beneficialHolders.push(msg.sender);
        return propertyRightId;
        return propertyRights[propertyRightId].balancesBeneficial[msg.sender];
    }

    // function _requestBalancesBeneficial (uint _propertyRightId) public returns(uint){
    //     return propertyRights[_propertyRightId].balancesBeneficial[msg.sender];
    // }

        //以下の５つnのfunctionはv1のもの。
    //権利を分割可能にv3にてアップデートしたため、無効化中。権利の分割が権利の分割が必要のない場合hnない場合などに利用。

    // 権利を買うBeneficial
    // function _buyBeneficial(uint _id) payable public {
    //     if(propertyRights[_id].priceBeneficial <= msg.value){
    //     propertyRights[_id].beneficialAddress = msg.sender;
    //     propertyRights[_id].priceBeneficial = 999999999;
    //     }
    // }


    // //権利を売りに出すDisposable
    // function _sellDisposable(uint _id, uint _price) public{
    //     //rightOwnerか検証
    //     if(propertyRights[_id].disposableAddress == msg.sender){
    //     propertyRights[_id].priceDisposable = _price;
    //     }
    // }

    // //権利を売りに出すAvailable
    // function _sellAvailable (uint _id, uint _price) public{
    //     //rightOwnerか検証
    //     if(propertyRights[_id].availableAddress == msg.sender){
    //     propertyRights[_id].priceAvailable = _price;
    //     }
    // }

    // //権利を買うDisposable
    // function _buyDisposable(uint _id) payable public {
    //     if(propertyRights[_id].priceDisposable <= msg.value){
    //     propertyRights[_id].disposableAddress = msg.sender;
    //     propertyRights[_id].priceDisposable = 999999999;
    //     }
    // }

    // //権利を買うAvailable
    // function _buyAvailable(uint _id) payable public {
    //     if(propertyRights[_id].priceAvailable <= msg.value){
    //     propertyRights[_id].availableAddress = msg.sender;
    //     propertyRights[_id].priceAvailable = 999999999;
    //     }
    // }


     //権利Availableを第三者へ付与する
    function _sendAvailable (uint _propertyRightId, uint _amount ,address _to) public{
        //その量のrightをamountとして持っているか検証
        if(propertyRights[_propertyRightId].balancesAvailable[msg.sender] >= _amount){
        propertyRights[_propertyRightId].balancesAvailable[msg.sender] -=_amount;
        propertyRights[_propertyRightId].balancesAvailable[_to] += _amount;
        propertyRights[_propertyRightId].beneficialHolders.push(_to);
        }
    }

     //権利Beneficialを第三者へ付与する
    function _sendBeneficial (uint _propertyRightId, uint _amount ,address _to) public{
        //その量のrightをamountとして持っているか検証
        if(propertyRights[_propertyRightId].balancesBeneficial[msg.sender] >= _amount){
        propertyRights[_propertyRightId].balancesBeneficial[msg.sender] -=_amount;
        propertyRights[_propertyRightId].balancesBeneficial[_to] += _amount;
        }
        // return  propertyRights[_propertyRightId].balancesBeneficial[msg.sender] ;
        // return  propertyRights[_propertyRightId].balancesBeneficial[_to];
    }

     //権利Disposableを第三者へ付与する
    function _sendDisposable (uint _propertyRightId, uint _amount ,address _to) public{
        //その量のrightをamountとして持っているか検証
        if(propertyRights[_propertyRightId].balancesDisposable[msg.sender] >= _amount){
        propertyRights[_propertyRightId].balancesDisposable[msg.sender] -=_amount;
        propertyRights[_propertyRightId].balancesDisposable[_to] += _amount;
        }
    }

    //Beneficial関連 財産に対しての対価支払い及び受け取り、それに伴う受益権を軸とした利益の分配
    function _pay (uint _propertyRightId) public payable {
        for (uint i = 0; i < propertyRights[_propertyRightId].beneficialHolders.length; i++) {
            propertyRights[_propertyRightId].beneficialHolders[i].transfer(msg.value*propertyRights[_propertyRightId].balancesBeneficial[propertyRights[_propertyRightId].beneficialHolders[i]]/propertyRights[_propertyRightId].totalSupplyBeneficial);
        }
    }


    function _checkBalancesDisposable (uint _propertyRightId, address _checkAddress)public returns (uint){
        return  propertyRights[_propertyRightId].balancesDisposable[_checkAddress];
    }

    function _checkBalancesAvailable(uint _propertyRightId, address _checkAddress)public returns (uint){
        return  propertyRights[_propertyRightId].balancesAvailable[_checkAddress];
    }

    function _checkBalancesBeneficial (uint _propertyRightId, address _checkAddress)public returns (uint){
        return  propertyRights[_propertyRightId].balancesBeneficial[_checkAddress];
    }

    function _checkBalancesDeposit(address _checkAddress) public returns(uint){
        return balancesDeposit[_checkAddress];
    }

    //証明書のcheck
    function _checkCertificate(uint _propertyRightId) public returns(string){
        return propertyRights[_propertyRightId].certificate;
    }






    // function _lendDisposable(uint _propertyRightId, address _to, uint _lendingTimes ){
    //     if(propertyRights[_propertyRightId].balancesDisposable[msg.sender]>0){
    //         propertyRights[_propertyRightId].balancesDisposable[msg.sender] = 0;
    //         propertyRights[_propertyRightId].balancesDisposable[_to] += propertyRights[_propertyRightId].balancesDisposable[msg.sender] ;
    //         propertyRights[_propertyRightId].lendingTimesDisposable[msg.sender] = now+_lendingTimes;
    //     }
    // }


    // function _withdrawDisposable(uint _propertyRightId, address _to){
    //     if(now > propertyRights[_propertyRightId].lendingTimesDisposable[msg.sender]){
    //         propertyRights[_propertyRightId].balancesDisposable[_to] = 0;
    //         propertyRights[_propertyRightId].balancesDisposable[_to] += propertyRights[_propertyRightId].balancesDisposable[msg.sender] ;
    //         propertyRights[_propertyRightId].lendingTimesDisposable[msg.sender] = now+_lendingTimes;
    //     }
    // }



    // struct lendingInfo{
    //     uint propertyRightId;
    //     uint lendingTimes;
    //     address to;
    // }

        //_deposit機能
    mapping (address =>uint) balancesDeposit;

      //_depositアクション
    function _deposit() public payable returns(uint){
        balancesDeposit[msg.sender] =+ msg.value;
        return balancesDeposit[msg.sender];
    }

     //_depositの引き出し機能
    function _withdrawDeposit() public {
        msg.sender.transfer(balancesDeposit[msg.sender]);
    }

     //_depositの引き出す権利の譲渡機能
    function _sendDeposit(address _to) {
        balancesDeposit[_to] =+ balancesDeposit[msg.sender];
        balancesDeposit[msg.sender] = 0;
    }



    //DEX機能（開発段階中）
    //大外で指定するKeyであるuintはPropertyのid。その次の内側のmappingで指定するのは0or1or2、
    //つまり権利の種類を指定。その次の内側のmappingで指定するのは(保有者のアドレス、残高)のペア
    // mapping (uint => mapping ( uint => mapping (address => uint))) public rteTokens;

    //Order
    //Cancel
    //Trade
    //Deposit
    //Withdraw




    //v1
    //自由に使用・収益・処分する権利を分割で売買
    //売り先指定不可

    //v2
    //struct propertyRightに変更不可のstring型格納変数を追加

    //v3
    //権利を分割可能にする。最大供給量の設定が可能に。
    //権利を第三者へ付与可能に

    //v4
    //財産に対しての対価支払い及びその受け取り、それに伴う受益権を軸とした利益の分配機能を追加

    //v5
    //deposit（信用の生成）

    //v6
    //３つの権利それぞれの時間制限付き貸借（実装中）
    //DEXの開発開始（実装中）

    //v7
    //deposit機能開発完了

    //所有権（しょゆうけん）とは、物の全面的支配すなわち自由に使用・収益・処分する権利。
    //Available Beneficial Disposable
}
