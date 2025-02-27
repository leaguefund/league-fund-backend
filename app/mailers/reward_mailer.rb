class RewardMailer < ApplicationMailer
  def send_reward_email(reward)
    @reward = reward
    mail(to: reward.user.email, subject: 'You have received a reward!')
  end
end
