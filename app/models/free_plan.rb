class FreePlan < Plan

  validates :remote_id, :interval, :interval_count, absence: true

end
