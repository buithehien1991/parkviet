# frozen_string_literal: true

module PagyMetadata
  private

  def pagy_metadata(pagy)
    {
      page: pagy.page,
      pages: pagy.pages,
      count: pagy.count,
      from: pagy.from,
      to: pagy.to,
      prev: pagy.previous,
      next: pagy.next
    }
  end
end
