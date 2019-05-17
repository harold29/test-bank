class AccountsController < ApplicationController
  before_action :authenticate_user!
  check_authorization
  load_and_authorize_resource :only => [:show]

  before_action :get_account, only: %i[transfer show]

  def show
    get_transactions(@account)
    respond_to :html
  end

  def index
    authorize! :index, Account if current_user.admin?
    @accounts = Account.all
    respond_to :html
  end

  def new
    authorize! :new, Account if current_user.admin?
    @account = Account.new
  end

  def create
    authorize! :create, Account if current_user.admin?
    @account = Account.new(account_params)

    if @account.save
      flash[:notice] = 'Account successfully created'
      redirect_to action: 'index'
    else
      flash[:error] = 'Error creating account'
      render action: 'new'
    end
  end

  def transfer
    destination = transfer_params[:account_number]
    amount = transfer_params[:amount].to_f

    if @account.active? && @account.transfer(destination, amount)
      flash[:notice] = 'Successful transfer'
    else
      flash[:error] = "Transfer failed, error: #{ @account.errors.messages[:base][0] }"
    end
    redirect_to action: 'show'
  end

  def deposit
    authorize! :deposit, Account if current_user.admin?
    destination = transfer_params[:account_number]
    amount = transfer_params[:amount].to_f
    account = Account.by_account_number(destination)

    if account.deposit(amount)
      flash[:notice] = 'Successful deposit'
    else
      flash[:error] = "Deposit failed, error: #{ @account.errors.messages[:base][0] }"
    end
    redirect_to action: 'index'
  end

  private

  def get_account
    @account = Account.by_user_id(current_user.id)
  end

  def get_transactions(account)
    @transactions = Transaction.by_relation(account.id)
  end

  def transfer_params
    params.require(:transfer).permit(:account_number, :amount)
  end

  def account_params
    params.require(:account).permit(:user_id, :amount, :active)
  end

end
