// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

//const tokenAddress = "0xB164B0ac1b738882dE4B41d781F0A38671dE8F6b";

const StakingETHModule = buildModule("StakingETHModule", (m) => {

    const stakingETH = m.contract("StakingETH");

    return { stakingETH };
});

export default StakingETHModule;
