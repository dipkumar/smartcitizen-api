class DeleteArchivedUsersJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # Do something later
    User.unscoped.where(workflow_state: "archived").each do |user|
      if user.created_at < 72.hours.ago
        CheckupNotifyJob.perform_later("deleting archived user #{user.id}")
        user.destroy!
      end
    end
  end
end
