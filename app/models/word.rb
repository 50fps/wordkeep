class Word < ApplicationRecord
	has_many :definitions, dependent: :destroy, inverse_of: :word
	accepts_nested_attributes_for :definitions, reject_if: proc { |attributes| attributes[:body].blank?}
end
