module ApplicationHelper
  def random_room_id
    rand(100**10).to_s.center(10, rand(10).to_s)
  end
end
