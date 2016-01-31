module SearchHelper

  def autosuggest_aggregate(response, fields, query)
    # Stores unique words and their autocorrect suggestions
    words = { }

    # Iterate over fields
    fields.each do |field|
      # Iterate over query words
      response.send(field).to_a.each do |word|
        # If any options are available
        if word.options.length > 0
          # Append word if it doesn't already exist
          new_word = false
          unless words.include? word.text
            words[word.text] = { text: '', score: nil, freq: nil }
            new_word = true
          end
          word.options.each do |option|
            if new_word or words[word.text][:score] * words[word.text][:freq] < option[:score] * option[:freq]
              words[word.text][:text] = option[:text]
              words[word.text][:score] = option[:score]
              words[word.text][:freq] = option[:freq]
            end
          end
        end
      end
    end

    new_query = query.dup

    # Generate a new string based on the high score suggestions
    words.each do |word, suggestion|
      if suggestion[:score] > 0.65
        new_query[word] = suggestion[:text]
      end
    end

    # Return the new query or false if there were no modifications
    return new_query unless new_query == query
    false
  end

end
