module QRSelect
  class Result
    attr_reader :seed, :candidates
    
    def initialize(text)
      @seed = text
      @candidates = []
    end
    
    def highest_score_text
      scores = @candidates.map { |text| @seed.score_to(text) }
      @candidates[scores.index(scores.max)]
    end

    def to_hash
      {
        :seed => @seed.to_hash,
        :candidates => @candidates.map { |text|
          hash = text.to_hash
          hash[:score] = @seed.score_to(text)
          hash
        }
      }
    end
  end
end
