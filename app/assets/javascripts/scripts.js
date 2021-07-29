(function($) {
  window.allfunction = {

    search: function() {
      $('.search-box').on("click", function(e) {
        e.stopPropagation()
        $('.search-area').toggleClass('active');

      })
      $('.search-cross').on("click", function(e) {
        e.stopPropagation()
        $('.search-area').removeClass('active');

      })
    },

    userDropdown: function() {
      $('.user-profile a').on("click", function(e) {
        e.preventDefault()
        $('.user-dropdown').parent().toggleClass('active');

      })
    },

    searchTyping: function() {
      $('body').on('.search-form input', function() {
        if ($(this).val().length === 0) {
          $(this).find('.search-typing').addClass('active');
        } else {
          $(this).find('.search-typing').removeClass('active');
        }
      });
    },


    // isotop masonary
    isotop: () => {
      if ($('.grid').length) {
        var $grid = $('.grid').isotope({
          itemSelector: '.grid-item',
          percentPosition: true,
          masonry: {
            horizontalOrder: false,
          }
        });
        $grid.imagesLoaded().progress(function() {
          $grid.isotope('layout')
        });
      }
    },
    // nice-select js
    nice_select: () => {
      if ($('.nice-select').length) {
        $('.nice-select').each(function() {
          var select = $(this),
            name = select.attr('name');

          select.hide();

          select.wrap('<div class="nice-select-wrap"></div>');

          var parent = select.parent('.nice-select-wrap');

          parent.append('<ul id=' + name + ' style="display:block"></ul>');

          select.find('option').each(function() {

            var option = $(this),
              value = option.attr('value'),
              label = option.text();

            if (option.is(":first-child")) {

              $('<a href="#" class="drop">' + label + '</a>').insertBefore(parent.find('ul'));

            } else {

              parent.find('ul').append('<li><a href="#" id="' + value + '">' + label + '</a></li>');

            }

          });

          parent.find('a').on('click', function(e) {
            e.stopPropagation()
            parent.toggleClass('down').find('ul').toggleClass('active');
            e.preventDefault();

          });
          $('body').on('click', function(e) {
            e.stopPropagation()
            parent.removeClass('down').find('ul').removeClass('active');

          });
          parent.find('ul a').on('click', function(e) {

            var niceOption = $(this),
              value = niceOption.attr('id'),
              text = niceOption.text();

            select.val(value);

            parent.find('.drop').text(text);

            e.preventDefault();

          });

        });
      }
    },
    // StopPropagations elements
    stopPropagationElements: () => {
      $('.contact-option-icone, .search-input-wrap').click(function(e) {
        e.stopPropagation()
      })
    },
    // Document click to hide elements
    elementHide: () => {
      $(document).click(function() {
        $('.contact-option-item').removeClass('add')
        $('.search-input-wrap').removeClass('active')
      })
    },
    init: function() {
      allfunction.elementHide()
      allfunction.stopPropagationElements()
      allfunction.isotop()
      allfunction.nice_select()
      allfunction.search()
      allfunction.searchTyping()
      allfunction.userDropdown()
    },
  }
})(jQuery);

$(document).ready(function() {
  allfunction.init();
  Filters.init();
  Search.init()


  $(".top-city-carousel").slick({
    arrows: true,
    autoplay: true,
    slidesToShow: 6,
    prevArrow: '<button type="button" class="slick-prev"><i class="ta-icon-angle-left"></i></button>',
    nextArrow: '<button type="button" class="slick-next"><i class="ta-icon-angle-right"></i></button>',
    responsive: [{
        breakpoint: 1199,
        settings: {
          slidesToShow: 5
        }
      },
      {
        breakpoint: 991,
        settings: {
          slidesToShow: 4
        }
      },
      {
        breakpoint: 768,
        settings: {
          slidesToShow: 3
        }
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 2
        }
      }
    ]
  });

  $(".featured-studio-carousel").slick({
    arrows: true,
    autoplay: true,
    slidesToShow: 3,
    prevArrow: '<button type="button" class="slick-prev"><i class="ta-icon-angle-left"></i></button>',
    nextArrow: '<button type="button" class="slick-next"><i class="ta-icon-angle-right"></i></button>',
    responsive: [{
        breakpoint: 991,
        settings: {
          slidesToShow: 2
        }
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 1
        }
      }
    ]
  });


  $(".list-image-carousel").slick({
    arrows: false,
    dots: true
  });
  $(".studio-img-carousel").slick({
    arrows: false,
    dots: true
  });


  $(".city-nav a").on('click', function() {
    $(this).addClass("active");
    $(".city-nav a").not(this).removeClass("active");
    var TargetId = $(this).attr('href');
    $('html, body').animate({
      scrollTop: $(TargetId).offset().top - 20
    }, 750, 'swing');
    return false;
  });

  $('#rightClick').click(function(e) {
    e.preventDefault();
    $('.studio-lists').animate({
      scrollLeft: "+=300px"
    }, "slow");
  });

  $('#leftClick').click(function(e) {
    e.preventDefault();
    $('.studio-lists').animate({
      scrollLeft: "-=300px"
    }, "slow");
  });


  // Mobile Menu
  $('#mobile-nav').slicknav({
    label: '',
    duration: 700,
    prependTo: '.mobile-menu'
  });

  $('.mobile-menu-icon').on('click', function() {
    $(".slicknav_nav").slideToggle();
    $(".header").toggleClass('bg-white');
  });

  $('.studio-date-time').on('click', function() {
    $(this).parent().toggleClass('active');
  });

  $('.see-more-section button').on('click', function(e) {
    e.preventDefault();

    $form = $(this).parents('form');
    $form.find('#page').val(parseInt($form.find('#page').val()) + 1);

    $form.submit();
  })

  $("input[name='search_path']").change(function() {
    var value = $(this).val();
    if (value === 'tattoos') {
      $('#global-search').attr({
        placeholder: `Search ${value} by style or body placement`,
        name: "query"
      });
    } else {
      $('#global-search').attr({
        placeholder: `Search ${value} by city or zip code`,
        name: "near"
      });
    }
  });
});
