ruleset news_api {
  meta {
    use module news_keys
    configure using news_key = ""
    provides
        get_news
  }

  global {

    get_news = function() {
      the_key = news_key;
      url = <<https://newsapi.org/v2/top-headlines?country=us&apiKey=#{news_key}>>;
      result = http:get(url){"content"}.decode();
      result;
    }

  }

}
