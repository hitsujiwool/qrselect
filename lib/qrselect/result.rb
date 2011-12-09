module QRSelect
  class Result
    attr_reader :seed, :candidates
    
    def initialize(text)
      @seed = text
      @candidates = []
    end
    
    def highest_score_text
      scores = @candidates.map { |text| text.score_to(@seed) }
      @candidates[scores.index(scores.max)]
    end

    def to_hash
      {
        :seed => @seed.to_hash,
        :candidates => @candidates.map { |text| text.to_hash }
      }
    end
  end
end
