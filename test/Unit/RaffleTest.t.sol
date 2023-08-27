//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {Test,console} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract RaffleTest is Test{
    Raffle raffle;
    HelperConfig helperconfig;

    uint256  entranceFee;
    uint256 interval;
    address vrfCoordinator;
    bytes32 gasLane;
    uint64 subscriptionId;
    uint32 callBackGasLimit;


    address public PLAYER=makeAddr("player");//Creates an address derived from the provided name.
    uint256 public constant STARTING_USER_BALANCE=10 ether;
    function setup() external{
        DeployRaffle deployer=new DeployRaffle();
            (raffle,helperconfig)=deployer.run();
            (
                entranceFee,
                interval,
                vrfCoordinator,
                gasLane,
                subscriptionId,
                callBackGasLimit
            )=helperConfig.activeNetworkConfig();
        vm.deal(PLAYER,STARTING_USER_BALANCE);
    }

    function raffleInitialisesInOpenState() public view{
        assert(raffle.getRaffleState()==Raffle.RaffleState.OPEN);

    }

    function testRaffleRevertWhenYouDontPayEnough() public {
        //Arrange
        vm.prank(PLAYER);
        //Act
        vm.expectRevert(Raffle.Raffle__NotEnoughEthSent.selector);
        //assert
        raffle.enterRaffle();
    }

    function testRaffleRecordsPlayerWhenTheyEnter() public {
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        address playerRecorded=raffle.getPlayer(0);
        assert(playerRecorded==PLAYER);
    }

    function testEmitsEventOnEntrance(){
        vm.prank(PLAYER);
        
    }
}