module ApplicationHelper
  include Pagy::Frontend

  def full_title page_title = ""
    base_title = t("titles.base")
    page_title.empty? ? base_title : [page_title, base_title].join(" | ")
  end

  def current_translations
    @translations ||= I18n.backend.send :translations
    @translations[I18n.locale].with_indifferent_access
  end
end
