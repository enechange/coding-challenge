/**
 * スライダー
 */
export default function() {
  $('.js-Slider').slick({
    autoplay: true,
    autoplaySpeed: 5000,
    dots: false,
    arrows: true,
    variableWidth: true,
    infinite: false,
    slidesToShow: 3,
    responsive: [
      {
        breakpoint: 699,
        settings: {
          slidesToShow: 1,
          centerMode: true,
        },
      },
    ],
  });
}
