module SadhnaCardHelper
    
  def chad_map
    [
      ["1", "Chapter 1", 46],
      ["1_1", "Chapter 1 (Verses 1-23)", 23],
      ["1_2", "Chapter 1 (Verses 24-46)", 23],
      ["2", "Chapter 2", 72],
      ["2_1", "Chapter 2 (Verses 1-36)", 36],
      ["2_2", "Chapter 2 (Verses 37-72)", 36],
      ["3", "Chapter 3", 43],
      ["3_1", "Chapter 3 (Verses 1-21)", 21],
      ["3_2", "Chapter 3 (Verses 22-43)", 22],
      ["4", "Chapter 4", 42],
      ["4_1", "Chapter 4 (Verses 1-21)", 21],
      ["4_2", "Chapter 4 (Verses 22-42)", 21],
      ["5", "Chapter 5", 29],
      ["6", "Chapter 6", 47],
      ["6_1", "Chapter 6 (Verses 1-23)", 23],
      ["6_2", "Chapter 6 (Verses 24-47)", 24],
      ["7", "Chapter 7", 30],
      ["8", "Chapter 8", 28],
      ["9", "Chapter 9", 34],
      ["10", "Chapter 10", 42],
      ["10_1", "Chapter 10 (Verses 1-21)", 21],
      ["10_2", "Chapter 10 (Verses 22-42)", 21],
      ["11", "Chapter 11", 55],
      ["11_1", "Chapter 11 (Verses 1-27)", 27],
      ["11_2", "Chapter 11 (Verses 28-55)", 28],
      ["12", "Chapter 12", 20],
      ["13", "Chapter 13", 35],
      ["14", "Chapter 14", 27],
      ["15", "Chapter 15", 20],
      ["16", "Chapter 16", 24],
      ["17", "Chapter 17", 28],
      ["18", "Chapter 18", 78],
      ["18_1", "Chapter 18 (Verses 1-39)", 39],
      ["18_2", "Chapter 18 (Verses 40-78)", 39],
    ]
  end

  def get_chapter(chad)
    chad_map.each do |x|
      if x[0] == chad
        return x[1]
      end
    end
    return nil
  end

  def today_date
    Date.today
  end

  def reading_types
    ["Mins",
      "Hrs",
      "Pages"
    ]
  end

  def books
    [
      "Srimad Bhagavatam", 
      "Bhagavad Gita", 
      "Sri Caitanya Caritamrta", 
      "Nectar of Devotion", 
      "Nectar of Instruction",
      "Science of Self Realization",
      "Krsna, The Supreme Personality of Godhead", 
      "Teachings of Lord Caitanya",
      "Sri Isopanisad",
      "Journey of Self-Discovery",
      "Path of Perfection",
      "Perfect Questions Perfect Answers",
      "Message of Godhead",
      "Teachings of Queen Kunti",
      "Teachings of Lord Kapila",
      "Our Family Business",
      "Life Comes from Life",
      "On the Way to Krsna"
    ]
  end

end
