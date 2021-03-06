# frozen_string_literal: true

class SharesController < ApplicationController
  respond_to :js

  # shows all the users with check for shared users on share button click
  def index
    @users =  User.all_user_except_one(current_user)
    @shares = Share.select_user_id.shared_users(params[:id])
  end

  # add or remove new users as shared users for a particular todo
  def create
    Share.manage_share(params)
    @shares = User.user_join_shares(params[:id])
  end
end
