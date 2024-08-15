// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract TinyGambling is Initializable,OwnableUpgradeable,ReentrancyGuardUpgradeable{
    using SafeERC20 for IERC20;

    enum BettorType {
        Big,            // 大  0
        Small,          // 小
        Single,         // 单
        Double          // 双
    }

    struct RoundGame {
        uint256   startBlock;           // 起始区块
        uint256   endBlock;             // 结束区块
        uint256[2] threeNumbers;        // 三个数字
    }

    struct GuessBettor {
        address account;
        uint256 value;        // 投注金额 >= 10U
        uint256 hgmId;        // 游戏期数
        uint8   betType;      // 投注情况
        bool    hasReward;    // 是否结算
        bool    isReward;     // 是否中奖
        uint256 reWardVale;   // 奖励金额，投注失败为 0
    }

    struct  Profile {
        //积分
        uint256  points;

        //等级
        uint16 level;

        //剩余免费下注次数
        uint16 freeChances;

        //已获取奖金（包括游戏赢取和激励）
        uint256 hasClaimes;
    }

    mapping(address=>Profile) public profiles;

    IERC20 public betteToken;                                // 博彩 Token(USDT)
    uint256 public gameBlock;                                // 游戏的每期块的数量，默认 30，可以设置
    uint256 public hgmGlobalId;                              // 每一期游戏的 Id, 从 1 开始递增, 查看开始游戏函数
    address public luckyDrawer;
    uint256 public betteTokenDecimal;

    GuessBettor[] public guessBettorList;                       // 博彩人数
    mapping(uint256 => RoundGame) public roundGameInfo;         // 每期的结果
    mapping(uint256 => mapping(address => GuessBettor)) public GuessBettorMap;     // 玩家的历史记录

    event GuessBetterCreate (
        address account,
        uint256 value,
        uint16 betType
    );

    event AllocateRward(
        address indexed account,
        uint256  hgmId,
        uint8   betType,
        uint256 reWardVale,
        bool   hasReward
    );

    event IncentiveGet (
        address indexed account,
        uint256 amounts,
        string msg
    );

    event LevelUpgrade (
        address indexed account,
        uint16 newLevel
    );

    modifier onlyLuckyDrawer()  {
        require(luckyDrawer == msg.sender, "onlyLuckyDrawer: caller must be lucky drawer");
        _;
    }

    function initialize(address initialOwner, address _betteToken, address _luckyDrawer) public initializer {
        __Ownable_init(initialOwner);
        betteToken = IERC20(_betteToken);
        luckyDrawer = _luckyDrawer;
        gameBlock = 32;
        hgmGlobalId = 1;
        betteTokenDecimal = 18;
        uint256[2] memory fixedArray;
        roundGameInfo[hgmGlobalId] = RoundGame(block.number, (block.number + gameBlock), fixedArray);
    }

    function setGameBlock(uint256 _block) external onlyOwner {
        gameBlock = _block;
    }

    function setBetteToken(address _address, uint256 _betteTokenDecimal) external onlyOwner {
        betteToken = IERC20(_address);
        betteTokenDecimal = _betteTokenDecimal;
    }

    function getBalance() external view returns (uint256) {
        return betteToken.balanceOf(address(this));
    }

    function createBettor(uint256 _amount, uint8 _betType) external returns (bool) {

        return true;
    }
}
