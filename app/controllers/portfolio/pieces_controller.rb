class Portfolio::PiecesController < ApplicationController
  layout('portfolio')

  def index
    @pieces = current_pieces
  end

  def show
    @piece = current_piece
  end

  def new
    @piece = Portfolio::Piece.new
  end

  def edit
    @piece = current_piece
  end

  def create
    @piece = Portfolio::Piece.new(piece_params)

    if @piece.save
      redirect_to(:portfolio_pieces, :notice => 'Portfolio piece created')
    else
      render(:new)
    end
  end

  def update
    @piece = current_piece
    if @piece.update_attributes(piece_params) # the permalink never changes
      redirect_to(:portfolio_pieces, :notice => 'Portfolio piece updated')
    else
      render(:edit)
    end
  end

  def destroy
    current_piece.destroy
    redirect_to(:portfolio, :notice => 'Portfolio piece deleted')
  end

  private

  def current_pieces
    Portfolio::Piece.order('published_at DESC').paginate(:per_page => 6, :page => params[:page])
  end

  def current_piece
    @_current_piece ||= Portfolio::Piece.find(params[:id])
  end

  def piece_params
    params
      .require(:portfolio_piece)
      .permit(
        :title,
        :published_at,
        :url,
        :subtitle,
        :image_html,
        :hack_blurb,
        :hacker_blurb
      )
  end
end
