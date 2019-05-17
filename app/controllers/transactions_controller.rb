class TransactionsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @transactions = Transaction.all.order(created_at: :desc)
    respond_to :html
  end
end
