class MembersOnlyArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    if session[:user_id]
      articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
      render json: articles, each_serializer: ArticleListSerializer
    else
      render json: { "error": "Not authorized" }, status: :unauthorized
    end

  end

  def show
    if session[:user_id]
      article = Article.find(params[:id])
      render json: article
    else
      render json: { "error": "Not authorized" }, status: :unauthorized
    end

  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
