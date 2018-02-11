class Definition < ApplicationRecord
	belongs_to :word, inverse_of: :definitions
end
