class Asset < ApplicationRecord
  belongs_to :attachable, polymorphic: true
end
