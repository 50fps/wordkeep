class WordsController < ApplicationController
before_action :set_word, only: [:show, :edit, :update, :destroy]

  def index
  	@words = Word.all
  end

  def new
  	@word = Word.new
  	@word.definitions.build
  end

  def create
  	@word = Word.new(secure_params)
  	if @word.save
  		flash[:notice] = "Successfully created new word"
  		redirect_to words_path
  	else
  		flash[:notice] = "Unable to create new word"
  		render :new
  	end
  end

  def show
  end

  def edit
  end

  def update
  	if @word.update_attributes(secure_params)
  		redirect_to @word, notice: 'Successfully updated word'
  	else
  		render :edit
  	end
  end

  def destroy
  	@word.destroy
  	redirect_to words_path
  end

  private

  def secure_params
  	params.require(:word).permit(:title, definitions_attributes: [:id, :body])
  end

  def set_word
  	@word = Word.find(params[:id])
  end
end
