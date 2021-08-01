class BookingSerializer < ActiveModel::Serializer
  belongs_to :sender
  belongs_to :receiver

  attributes :id,
             :description,
             :placement,
             :consult_artist,
             :custom_size,
             :urgency,
             :size_units,
             :first_tattoo,
             :colored

  def urgency
    object.urgency.strftime("%d-%m-%Y")
  end
end
