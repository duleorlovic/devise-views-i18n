class SearchHappenings
  include ActiveModel::Model
  attr_accessor :city_name, :activity_id

  validates :city_name, :activity_id, presence: true

  # all results are grouped by happening

  def results
    return @results if @results.present?

    results =
      Happening
      .left_outer_joins(discipline_happenings: { discipline: :activity })
      .where(discipline_happenings: { disciplines: { activity: activity.self_and_used_in_activities } })
      .distinct

    @results = results
  end

  def activity
    Activity.find activity_id
  end

  def all_cities
    # TODO: Determine country based on IP address
    # TODO: promote cities which are already in db
    already = ['Beograd', 'Novi Sad']
    already +
      CS.states(:rs).keys.map { |state| CS.cities state }.flatten
  end

  def all_activities
    Activity.all
  end
end
