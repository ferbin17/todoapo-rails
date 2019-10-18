class Todo < ApplicationRecord

  validates_presence_of :body

  belongs_to :user

  has_many :shares
  has_many :users, through: :shares, dependent: :destroy

  has_many :comments, dependent: :destroy

  scope :search, lambda { |like_keyword| where("body LIKE ?", like_keyword) }
  scope :logged_user, lambda { |current_user| where(user_id: current_user.id) }
  scope :active_only, ->  { where(active: true) }
  scope :inactive_only, -> { where(active: false) }

  #function to sort todos with respect to posistion in descending order
  def self.sort
    @todos = Todo.all
    return @todos.order(position: :desc)
  end

  def self.move(direction, current_todo, current_user)
    @user = User.find(current_user.id)
    case direction
    when "down"
      @nexttodo = Todo.joins(:shares).select("shares.*,todos.*").where("position < ? and shares.user_id= ? and todos.active=?", current_todo.position, current_user.id, current_todo.active?).order(:position).limit(1)

      current_todo = current_todo.shares.where(user_id: current_user.id)
      @nexttodo = @nexttodo[0].shares.where(user_id: current_user.id)
      #
      position = @nexttodo[0].position
      @nexttodo[0].update(position: current_todo[0].position)
      current_todo[0].update(position: position)
    when "up"
      @nexttodo = Todo.joins(:shares).select("shares.*,todos.*").where("position > ? and shares.user_id= ? and todos.active=?", current_todo.position, current_user.id, current_todo.active?).order(:position).limit(1)

      current_todo = current_todo.shares.where(user_id: current_user.id)
      @nexttodo = @nexttodo[0].shares.where(user_id: current_user.id)

      position = @nexttodo[0].position
      @nexttodo[0].update(position: current_todo[0].position)
      current_todo[0].update(position: position)
    end
  end


end
