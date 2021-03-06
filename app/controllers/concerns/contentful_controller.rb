module ContentfulController
  extend ActiveSupport::Concern

  attr_accessor :index_query

  included do
    helper ContentfulRails::MarkdownHelper
    caches_action :index, :show, skip_digest: true, unless: :preview_enabled?
    before_action :list_content, only: :index
    before_action :load_content, only: :show
    rescue_from Contentful::NotFound, with: -> { render_404 } unless Rails.application.config.consider_all_requests_local
  end

  private

  def load_content
    check_preview
    content = class_name.find_by(slug: params[:id]).load.first
    raise(ActionController::RoutingError, 'Not Found') if content.nil?
    instance_variable_set("@#{controller_name.singularize}", content.decorate)
  end

  def list_content
    instance_variable_set("@#{controller_name}", list)
  end
  
  def list
    class_name.all.load
  end

  def class_name
    controller_name.classify.constantize
  end

  def preview_enabled?
    params[:preview_token] == ENV['PREVIEW_TOKEN'] || ENV['USE_PREVIEW_API']
  end

  def check_preview
    ContentfulModel.use_preview_api = preview_enabled?
  end

  module ClassMethods
    def index_query(query)
      prepend_before_action do
        self.index_query = query
      end
    end
  end
end
