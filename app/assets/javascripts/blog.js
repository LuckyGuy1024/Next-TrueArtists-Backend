$(document).on('keydown', function(e) {
  if (e.keyCode === 27) { // ESC
    $('.search_block').hide();
  }
});

$(document).ready(function() {
  $('.menu-wrap').click(function() {
    $('html').addClass('open-menu');
    $('.menu-bg').fadeIn(600);
    return false
  });

  $('.menu-close').click(function() {
    $('html').removeClass('open-menu');
    $('.menu-bg').fadeOut(600);
    return false
  });

  $('.close-search').click(function() {
    $('.search_block').fadeOut(300);
    return false
  });

  $('.search-btn').click(function() {
    $('.search_block').fadeIn(300);
    return false
  });

  $('.slider').slick({
    dots: true,
    infinite: true,
    speed: 300,
    slidesToShow: 1,
    centerMode: true,
    variableWidth: true,
    responsive: [{
      breakpoint: 767,
      settings: {
        arrows: false,
      }
    }]
  });

  function fuctionMenu() {
    var windowTop = $(window).scrollTop();
    if (windowTop > 10) {
      $('.main-header').addClass('header-fixed');
    } else {
      $('.main-header').removeClass('header-fixed');
    }
  }
  fuctionMenu();

  $(window).scroll(function() {
    fuctionMenu();
  });

});
