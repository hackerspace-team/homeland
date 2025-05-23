module Homeland
  class Pipeline
    class EmbedVideoFilter < HTML::Pipeline::TextFilter
      YOUTUBE_URL_REGEXP = %r{(\s|^|<div>|<br>)(https?://)(www.)?(youtube\.com/watch\?v=|youtu\.be/|youtube\.com/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(&\S+)?(\?\S+)?}
      YOUKU_URL_REGEXP = %r{(\s|^|<div>|<br>)(https?://)(v\.youku\.com/v_show/id_)([a-zA-Z0-9\-_=]*)(\.html)(&\S+)?(\?\S+)?}
      VIMEO_URL_REGEXP = %r{(\s|^|<div>|<br>)(https://)(vimeo\.com/)([0-9]+)(&\S+)?(\?\S+)?}
      BILI_URL_REGEXP = %r{(\s|^|<div>|<br>)(https?://)(www.)?(bilibili\.com/video/av)([0-9]+)(&\S+)?(\?\S+)?}
      BILI_B_URL_REGEXP = %r{(\s|^|<div>|<br>)(https?://)(www.)?(bilibili\.com/video/BV)([a-zA-Z0-9]+)(&\S+)?(\?\S+)?}

      def call
        wmode = context[:video_wmode]
        autoplay = context[:video_autoplay] || false
        hide_related = context[:video_hide_related] || false

        @text.gsub!(YOUTUBE_URL_REGEXP) do
          youtube_id = Regexp.last_match(5)
          close_tag = Regexp.last_match(1) if ["<br>", "<div>"].include? Regexp.last_match(1)
          src = "//www.youtube.com/embed/#{youtube_id}"
          params = []
          params << "wmode=#{wmode}" if wmode
          params << "autoplay=1" if autoplay
          params << "rel=0" if hide_related
          src += "?#{params.join "&"}" unless params.empty?
          embed_tag(close_tag, src)
        end

        @text.gsub!(VIMEO_URL_REGEXP) do
          vimeo_id = Regexp.last_match(4)
          close_tag = Regexp.last_match(1) if ["<br>", "<div>"].include? Regexp.last_match(1)
          src = "https://player.vimeo.com/video/#{vimeo_id}"
          embed_tag(close_tag, src)
        end

        @text.gsub!(YOUKU_URL_REGEXP) do
          youku_id = Regexp.last_match(4)
          src = "//player.youku.com/embed/#{youku_id}"
          close_tag = Regexp.last_match(1) if ["<br>", "<div>"].include? Regexp.last_match(1)
          embed_tag(close_tag, src)
        end

        @text.gsub!(BILI_URL_REGEXP) do
          bili_id = Regexp.last_match(5)
          src = "//player.bilibili.com/player.html?aid=#{bili_id}"
          close_tag = Regexp.last_match(1) if ["<br>", "<div>"].include? Regexp.last_match(1)
          embed_tag(close_tag, src)
        end

        @text.gsub!(BILI_B_URL_REGEXP) do
          bili_id = Regexp.last_match(5)
          src = "//player.bilibili.com/player.html?bvid=#{bili_id}"
          close_tag = Regexp.last_match(1) if ["<br>", "<div>"].include? Regexp.last_match(1)
          embed_tag(close_tag, src)
        end

        @text
      end

      def embed_tag(close_tag, src)
        %(#{close_tag}<span class="embed-responsive embed-responsive-16by9"><iframe class="embed-responsive-item" src="#{src}" allowfullscreen></iframe></span>)
      end
    end
  end
end
