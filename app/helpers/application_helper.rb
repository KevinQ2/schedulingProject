module ApplicationHelper
  def is_host_member?(organization)
    OrganizationMember.exists?(
      :organization_id => organization,
      :user_id => current_user.id,
      :is_host => true
    )
  end

  def is_edit_member?(organization)
    member = OrganizationMember.find_by(
      :organization_id => organization,
      :user_id => current_user.id
    )

    return (member.is_host or member.can_edit)
  end

  def is_invite_member?(organization)
    member = OrganizationMember.find_by(
      :organization_id => organization,
      :user_id => current_user.id
    )

    return (member.is_host or member.can_invite)
  end

  def clear_schedule(project)
    ScheduleAllocation.where(:project_id => project).map(&:destroy)
  end
end
