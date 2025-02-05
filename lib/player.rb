class Player
  # Create getters and setters for shape, number_id
  attr_accessor(:token, :number_id)

  def initialize(number_id, token)
    @number_id = number_id
    @token = token
  end
end