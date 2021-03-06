class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :answerer, :body, :vote_count, :post_id, :user_vote

  delegate :current_user, to: :scope

  def answerer
    a = {username: object.user.username, user_pic: object.user.profile_pic(:small)}
  end

  def vote_count
    object.votes.count
  end

  def post_id
    object.post.id
  end

  def user_vote
    x = object.votes.where(user_id: current_user.id).first
    x != nil ? x : Vote.new
  end

end
