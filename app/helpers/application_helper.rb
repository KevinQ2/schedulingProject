module ApplicationHelper
  def is_host_member?(organization)
    OrganizationMember.exists?(
      :organization_id => organization,
      :user_id => current_user.id,
      :is_host => true,
      :pending => false
    )
  end

  def is_edit_member?(organization)
    member = OrganizationMember.find_by(
      :organization_id => organization,
      :user_id => current_user.id,
      :pending => false
    )

    return (member.is_host or member.can_edit)
  end

  def is_invite_member?(organization)
    member = OrganizationMember.find_by(
      :organization_id => organization,
      :user_id => current_user.id,
      :pending => false
    )

    return (member.is_host or member.can_invite)
  end

  def is_pending_member?(organization)
    member = OrganizationMember.find_by(
      :organization_id => organization,
      :user_id => current_user.id
    )

    return member.pending
  end

  def clear_schedule(project)
    ScheduleAllocation.where(:project_id => project).map(&:destroy)
  end
end
