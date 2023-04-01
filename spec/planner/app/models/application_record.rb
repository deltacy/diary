class ApplicationRecord < ActiveRecord::Base
  include Diary::DiaryOwner
  include Diary::Schedulable

  primary_abstract_class
end
