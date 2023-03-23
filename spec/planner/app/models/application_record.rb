class ApplicationRecord < ActiveRecord::Base
  include Diary::DiaryOwner

  primary_abstract_class
end
