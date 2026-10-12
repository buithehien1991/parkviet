# frozen_string_literal: true

module ReactLayout
  extend ActiveSupport::Concern

  included do
    class_attribute :_react_layout_name, instance_writer: false, default: nil

    inertia_share react_layout: -> {
      current_react_layout
    }
  end

  class_methods do
    def react_layout(name)
      self._react_layout_name = name.to_s
    end
  end

  private

  def current_react_layout
    self.class._react_layout_name.presence || "application"
  end
end
