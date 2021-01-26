# frozen_string_literal: true

module AssetExtension
  extend ActiveSupport::Concern
  included do
    has_many :attachments, as: :attachable, class_name: 'Asset'
    accepts_nested_attributes_for :attachments,
                                  allow_destroy: true, reject_if: proc { |attrs| attrs['image'].blank? }
  end
end
