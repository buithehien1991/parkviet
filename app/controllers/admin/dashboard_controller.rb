# frozen_string_literal: true

class Admin::DashboardController < Admin::BaseController
  def index
    page_title "Admin Dashboard"
    apply_admin_breadcrumbs([ "Dashboard" ])

    render inertia: "Admin/Dashboard/Index", props: {
      stats: dashboard_stats,
      status_breakdown: status_breakdown,
      recent_users: User.order(created_at: :desc, id: :desc).limit(5).map { |user| user_summary(user) },
      attention: attention_summary
    }
  end

  private

  def dashboard_stats
    {
      total_users: User.count,
      active_users: User.active.count,
      inactive_users: User.inactive.count,
      admin_users: User.with_admin_access.count,
      new_users_last_7_days: User.where(created_at: 7.days.ago..).count
    }
  end

  def status_breakdown
    User.statuses.keys.map do |status|
      count = User.public_send(status).count

      {
        label: status.humanize,
        value: status,
        count:,
        percentage: percentage(count, User.count)
      }
    end
  end

  def attention_summary
    [
      {
        label: "Inactive accounts",
        value: User.inactive.count,
        description: "Accounts currently blocked from signing in."
      },
      {
        label: "Privileged accounts",
        value: User.with_admin_access.count,
        description: "Users with elevated workspace access."
      },
      {
        label: "New this week",
        value: User.where(created_at: 7.days.ago..).count,
        description: "Fresh accounts created in the last 7 days."
      }
    ]
  end

  def user_summary(user)
    {
      id: user.id,
      email: user.email,
      name: user.name.to_s,
      username: user.username.to_s,
      role: user.role_record&.name || user.role,
      status: user.status,
      created_at: user.created_at.to_date.iso8601
    }
  end

  def percentage(count, total)
    return 0 if total.zero?

    ((count.to_f / total) * 100).round
  end
end
