class Art < ApplicationRecord
    has_one_attached :photo
    belongs_to :status
    validates :title, presence: true
end
