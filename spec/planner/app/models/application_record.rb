class ApplicationRecord < ActiveRecord::Base
  include Diary::DiaryOwner
  include Diary::DiaryInvitee
  include Diary::Schedulable

  primary_abstract_class
end
