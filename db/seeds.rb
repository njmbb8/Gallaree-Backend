User.all.each do |user|
    user.build_conversation.save
end