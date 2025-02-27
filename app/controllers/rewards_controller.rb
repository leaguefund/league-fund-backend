class RewardsController < ApplicationController
  def created
    reward = Reward.new(reward_params)
    if reward.save
      RewardMailer.send_reward_email(reward).deliver_later
      GenerateNftImageJob.perform_later(reward.id)
      render json: reward, status: :created
    else
      render json: reward.errors, status: :unprocessable_entity
    end
  end

  private

  def reward_params
    params.require(:reward).permit(:league_address, :name, :amount_usdc, :wallet, :season)
  end
end
