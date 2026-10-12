# frozen_string_literal: true

module Breadcrumbable
  extend ActiveSupport::Concern

  included do
    before_action :reset_page_metadata

    inertia_share breadcrumbs: -> {
      @breadcrumbs || []
    }

    inertia_share page_title: -> {
      @page_title
    }
  end

  private

  def breadcrumb(label, href = nil)
    @breadcrumbs ||= []
    @breadcrumbs << {
      label: label.to_s,
      href: href
    }
  end

  def page_title(title)
    @page_title = title.to_s
  end

  def reset_page_metadata
    @breadcrumbs = []
    @page_title = nil
  end
end
