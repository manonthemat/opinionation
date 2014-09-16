class PostSerializer < ActiveModel::Serializer
  attributes :id, :question, :poster, :post_pic, :post_favorite, :is_favorite, :answers

  delegate :current_user, to: :scope

  def poster
    user = {username: object.user.username, profile_pic: object.user.profile_pic(:small)}
  end

  def post_pic
    object.post_pic ? object.post_pic(:large) : object.user.profile_pic(:large)
  end

  def post_favorite
    if object.favorites.exists?(user_id: current_user.id)
      object.favorites.where(user_id: current_user.id).first
    else
      Favorite.new
    end
  end

  def is_favorite
    object.favorites.exists?(user_id: current_user.id) ? true : false
  end

  def answers
    answers_arr = []

    object.answers.each do |answer|

      a = {id: answer.id, body: answer.body, username: answer.user.username, user_pic: answer.user.profile_pic(:small), vote_count: answer.votes.count, current_user_endorsed: endorsement_check(answer) }
      
      answers_arr.push(a)
    end
    
    answers_arr
  end

  #called in answers method
  def endorsement_check(answer)
    answer.votes.exists?(user_id: current_user.id) ? true : false
  end

end
