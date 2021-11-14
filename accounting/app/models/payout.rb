class Payout < ApplicationRecord
  belongs_to :user

  def full_title
    "Payout #{id}"
  end
end
