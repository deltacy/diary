class User < ApplicationRecord
  diary_owner

  def full_name
    name
  end

  def first_name
    name
  end
end
