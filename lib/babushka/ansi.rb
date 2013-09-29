module Babushka
  class ANSI

    BG_OFFSET = 10
    COLOR_REGEX = /gr[ae]y|red|green|yellow|blue|pink|cyan|white/
    FG_REGEX = /\b#{COLOR_REGEX}\b/
    BG_REGEX = /\bon_#{COLOR_REGEX}\b/
    CTRL_REGEX = /\bbold|underlined?|blink(ing)?|reversed?\b/
    COLOR_OFFSETS = {
      'gray' => 90, 'grey' => 90,
      'red' => 31,
      'green' => 32,
      'yellow' => 33,
      'blue' => 34,
      'pink' => 35,
      'cyan' => 36,
      'white' => 37
    }
    CTRL_OFFSETS = {
      'bold' => 1,
      'underline' => 4, 'underlined' => 4,
      'blink' => 5, 'blinking' => 5,
      'reverse' => 7, 'reversed' => 7
    }

    # Wraps +text+ with ANSI escape codes to render it as described in
    # +description+. Some examples:
    #     Babushka::ANSI.wrap('babushka', 'green')            #=> "\e[32mbabushka\e[m"
    #     Babushka::ANSI.wrap('babushka', 'on grey')          #=> "\e[100mbabushka\e[m"
    #     Babushka::ANSI.wrap('babushka', 'underlined blue')  #=> "\e[34;4mbabushka\e[m"
    #     Babushka::ANSI.wrap('babushka', 'reverse')          #=> "\e[7mbabushka\e[m"
    def self.wrap text, description
      if Babushka::Base.cmdline.opts[:"[no_]color"] == false
        text
      else
        "#{escape_for(description)}#{text}\e[m"
      end
    end

    def self.escape_for description
      desc = description.strip.gsub(/\bon /, 'on_')
      codes = [fg_for(desc), bg_for(desc), ctrl_for(desc)]

      "\e[#{codes.compact.join(';')}m"
    end

    def self.fg_for desc
      COLOR_OFFSETS[desc[FG_REGEX]]
    end

    def self.bg_for desc
      offset = fg_for((desc[BG_REGEX] || '').sub(/^on_/, ''))
      offset + BG_OFFSET unless offset.nil?
    end

    def self.ctrl_for desc
      CTRL_OFFSETS[desc[CTRL_REGEX]]
    end
  end
end
