$ ->

  class TilesApp
    wrapper: $("#wrapper")
    
    tile_images: ["2.png", "3.png", "3-5.png", "4.png", "5.png", "6.png"]

    calculate_dimensions: =>
      window_width = $(window).width()

      @wrapper_width = window_width * 0.71
      @wrapper_height = @wrapper_width * 0.5
      @wrapper_margin_top = window_width * 0.083

      @wrapper.width(@wrapper_width).height(@wrapper_height).css("margin-top", @wrapper_margin_top + "px")

    load_next: =>
      if typeof @tile_images[@cur_image + 1] == "undefined"
        @cur_image = 0
      else
        @cur_image = @cur_image + 1

      @load_image @tile_images[@cur_image]

    load_image: (file_name, slide) =>
      slide ?= true

      image = $("<img src=\"/assets\/" + file_name + "\" />")
      image.width(@wrapper_width)
      image.css("margin-top", @wrapper_margin_top * -0.25)
      image.hide()

      @wrapper.append image

      if slide
        image.addClass("tile")
        image.delay(3000).fadeIn(1000)
        image.css("margin-left", @wrapper_width * -0.095)

        if $("img.tile").length > 1
          first_image = $("img.tile:first")

          if first_image.hasClass("tile")
            @template.fadeIn("slow")
            $("img.bg").css "opacity", 0

            first_image.animate
              "margin-left": Number(first_image.css("margin-left").replace("px", "")) - (@wrapper_width * 0.905)
            , 2000
      else
        image.addClass "bg"
        image.hide().fadeIn "slow"

    load: =>
      @calculate_dimensions()
      @cur_image = -1
      Tiles.load_image "1.png", false

      @template = $("<img id=\"template\" src=\"/assets\/template.png\" />")
      @template.width(@wrapper_width)
      @template.css("top", @wrapper_margin_top + (@wrapper_margin_top * -0.15))

      @wrapper.append @template
      @template.hide()

      @load_next()

      setInterval @load_next, 5000

  window.Tiles = new TilesApp

  $(window).on "resize", =>
    Tiles.calculate_dimensions()

  Tiles.load()
