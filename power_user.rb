require './user_activity' #external library for user activity of given user

class PowerUser

  DEFAULT_KEY_ACTIVITIES = { 'analysis_performed' => 5, 'custom_audience_created' => 4, 'analysis_exported' => 2, 'report_downloaded' => 1}

  def initialize (email) # takes email value sent from "Client" as given user identification
    @email = email
  end

  def status (key_activities = DEFAULT_KEY_ACTIVITIES) # main procedure, in case of change in key activities definition it is possible to set key_activities with scores as a hash on input or change constant on line 5
    @key_activities = key_activities
    @user_activity = UserActivity.new(@email) #calls external library for user activity of given user
    @activities = @user_activity.activities(@key_activities.keys) #checks key activities of given user
    @score = score(@key_activities, @activities) #counts score of given user depending on score definition in key activities and numbers of occurences
    @status = category (@score) #assigns category of user depending on score
  end

  private

    def score (key_activities, activities) #counts score of given user depending on score definition in key activities and numbers of occurences
      @key_activities = key_activities
      @activities = activities
      @score = 0
      @activities.each { |key, value| @score = @score + value * @key_activities[key] }
      @score
    end

    def category (score) #assigns category of user depending on score
      @score = score
      case @score
        when 0..19
          @category = 'INACTIVE_USER' 
        when 20..99
          @category = 'ACTIVE_USER' 
        else
          @category = 'POWER_USER' 
      end
      @category
    end

end