class GenerateNftImageJob < ApplicationJob
  queue_as :default

  def perform(reward_id)
    reward = Reward.find(reward_id)
    response = HTTParty.post('https://api.dalle.com/generate', body: { prompt: 'watercolor trophy' })
    if response.success?
      reward.update(nft_image: response.parsed_response['image_url'])
    end
  end
end
