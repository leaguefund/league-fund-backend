class Reward < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :league, optional: true
end
