class SalmonInterpreter
  def initialize(body, params = {})
    raise(ArgumentError, "request body can't be empty") if !body || body.empty?

    @feed = SalmonInterpreter.find_feed(params[:feed_id])

    @salmon = SalmonInterpreter.parse(body)
    raise(ArgumentError, "can't parse salmon envelope") if @salmon.nil?

    @root_url = params[:root_url]
  end

  def interpret
  end

  # Isolating calls to external classes so we can stub these methods in test
  # and not have to load rails!

  def self.find_feed(id)
    # Using the bang version so we get a MongoMapper::DocumentNotFound exception
    Feed.find!(id)
  end

  def self.parse(body)
    OStatus::Salmon.from_xml body
  end
end